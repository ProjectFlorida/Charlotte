//
//  CHLineChartView.m
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHLineChartView.h"
#import "CHPointCellSubclass.h"
#import "CHLineView.h"
#import "CHChartViewSubclass.h"
#import "CHPagingLineChartFlowLayout.h"
#import "CHTouchGestureRecognizer.h"
#import "CHCursorPointView.h"
#import "CHGradientView.h"
#import "CHFooterView.h"

NSString *const CHSupplementaryElementKindLine = @"CHSupplementaryElementKindLine";

@interface CHLineChartView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMapTable *visibleLineViews;
@property (nonatomic, strong) CHTouchGestureRecognizer *touchGR;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGR;
@property (nonatomic, strong) CHGradientView *cursorColumnView;
@property (nonatomic, strong) CHCursorPointView *cursorPointView;
@property (nonatomic, assign) CGFloat highlightColumnWidth;
@property (nonatomic, assign) BOOL cursorIsActive;

@end

@implementation CHLineChartView

- (void)initialize
{
    self.cellReuseId = kCHPointCellReuseId;
    self.cellClass = [CHPointCell class];

    [super initialize];

    _lineInsetAlpha = 0.1;

    _cursorEnabled = YES;
    _cursorIsActive = NO;
    _cursorMovementAnimationDuration = 0.2;
    _cursorEntranceAnimationDuration = 0.15;
    _cursorExitAnimationDuration = 0.15;
    _highlightColumnWidth = 4;
    _cursorColumnView = [[CHGradientView alloc] initWithFrame:CGRectMake(0, 0,
                                                                         _highlightColumnWidth,
                                                                         self.bounds.size.height)];
    _cursorColumnView.locations = @[@0, @0.35, @0.65, @1];
    _cursorColumnView.colors = @[[UIColor colorWithWhite:1 alpha:0.4],
                                  [UIColor colorWithWhite:1 alpha:0]];
    _cursorColumnView.startPoint = CGPointMake(0.5, 0);
    _cursorColumnView.endPoint = CGPointMake(0.5, 1);
    _cursorColumnView.alpha = 0;
    [self addSubview:_cursorColumnView];

    _cursorPointView = [[CHCursorPointView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _cursorPointView.alpha = 0;
    [self addSubview:_cursorPointView];

    _visibleLineViews = [NSMapTable strongToWeakObjectsMapTable];

    _longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    _longPressGR.minimumPressDuration = 0.1;
    [self addGestureRecognizer:_longPressGR];

    _touchGR = [[CHTouchGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchGesture:)];
    _touchGR.enabled = NO;
    _touchGR.delegate = self;
    [self addGestureRecognizer:_touchGR];

    self.multipleTouchEnabled = NO;

    [self.collectionView registerClass:[CHLineView class]
            forSupplementaryViewOfKind:CHSupplementaryElementKindLine
                   withReuseIdentifier:kCHLineViewReuseId];
    self.collectionViewLayout = [[CHPagingLineChartFlowLayout alloc] init];
    [self.collectionView setCollectionViewLayout:self.collectionViewLayout animated:NO];

    [self initializeConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cursorColumnView.frame = CGRectMake(self.cursorColumnView.frame.origin.x,
                                                0,
                                                self.cursorColumnView.frame.size.width,
                                                self.bounds.size.height - self.footerHeight);
}

- (void)updateAlphaInVisibleLineViews
{
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    CGFloat minAlpha = 0.3;
    CGFloat leftMargin = collectionViewWidth/2;
    CGFloat rightMargin = collectionViewWidth/2;
    NSEnumerator *keyEnumerator = [self.visibleLineViews keyEnumerator];
    NSIndexPath *indexPath;
    while ((indexPath = keyEnumerator.nextObject) && indexPath) {
        CHLineView *lineView = [self.visibleLineViews objectForKey:indexPath];
        CGFloat distanceFromLeftEdge = lineView.center.x - self.collectionView.contentOffset.x;
        CGFloat distanceFromRightEdge = collectionViewWidth - distanceFromLeftEdge;
        CGFloat alpha = 1;
        if (distanceFromLeftEdge < leftMargin) {
            alpha = MAX(distanceFromLeftEdge/leftMargin, minAlpha);
        }
        else if (distanceFromRightEdge < rightMargin) {
            alpha = MAX(distanceFromRightEdge/rightMargin, minAlpha);
        }
        lineView.alpha = alpha;
    }
}

- (void)updateAlphaInVisibleCells
{
    [super updateAlphaInVisibleCells];
    [self updateAlphaInVisibleLineViews];
}

- (void)updateRangeInVisibleLineViewsAnimated:(BOOL)animated
{
    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    NSEnumerator *keyEnumerator = [self.visibleLineViews keyEnumerator];
    NSIndexPath *indexPath;
    while ((indexPath = keyEnumerator.nextObject) && indexPath) {
        CHLineView *lineView = [self.visibleLineViews objectForKey:indexPath];
        [lineView setMinValue:min maxValue:max animated:animated completion:nil];
    }
}

- (void)updateRangeInVisibleCellsAnimated:(BOOL)animated
{
    [super updateRangeInVisibleCellsAnimated:animated];
    [self updateRangeInVisibleLineViewsAnimated:animated];
}

#pragma mark - Setters

- (void)setCursorColumnWidth:(CGFloat)cursorColumnWidth
{
    _cursorColumnWidth = cursorColumnWidth;
    CGRect currentFrame = self.cursorColumnView.frame;
    self.cursorColumnView.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y,
                                             cursorColumnWidth, currentFrame.size.height);
}

- (void)setCursorPointRadius:(CGFloat)cursorPointRadius
{
    _cursorPointRadius = cursorPointRadius;
    CGRect currentFrame = self.cursorPointView.frame;
    self.cursorColumnView.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y,
                                             cursorPointRadius*2.0, currentFrame.size.height);
}

- (void)setCursorColumnColor:(UIColor *)cursorColumnColor
{
    _cursorColumnColor = cursorColumnColor;
    self.cursorColumnView.colors = @[cursorColumnColor, self.cursorColumnView.colors[1]];
}

- (void)setCursorColumnTintColor:(UIColor *)cursorColumnTintColor
{
    _cursorColumnTintColor = cursorColumnTintColor;
    self.cursorColumnView.colors = @[self.cursorColumnView.colors[0], cursorColumnTintColor];
}

- (void)setLineInsetAlpha:(CGFloat)lineInsetAlpha
{
    _lineInsetAlpha = lineInsetAlpha;
    [self.collectionView reloadData];
}

- (void)setLineDrawingAnimationDuration:(NSTimeInterval)lineDrawingAnimationDuration
{
    _lineDrawingAnimationDuration = lineDrawingAnimationDuration;
    [[CHLineView appearance] setLineDrawingAnimationDuration:_lineDrawingAnimationDuration];
}

- (void)setRegionEntranceAnimationDuration:(NSTimeInterval)regionEntranceAnimationDuration
{
    _regionEntranceAnimationDuration = regionEntranceAnimationDuration;
    [[CHLineView appearance] setRegionEntranceAnimationDuration:_regionEntranceAnimationDuration];
}

#pragma mark - UIGestureRecognizerDelegate

// Make sure our gesture recognizer doesn't block other gesture recognizers
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Gesture recognizer action

- (void)handleLongPressGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.cursorEnabled) {
        return;
    }
    self.touchGR.enabled = YES;
    [self handleTouchGesture:gestureRecognizer];
}

- (void)handleTouchGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.cursorEnabled) {
        return;
    }
    CGPoint touchLocation = [gestureRecognizer locationInView:self];
    NSInteger pointCount = [self.dataSource chartView:self numberOfPointsInPage:self.currentPage];
    UIEdgeInsets sectionInset = self.collectionViewLayout.sectionInset;
    UIEdgeInsets pageInset = self.collectionViewLayout.pageInset;
    CGFloat sectionInsetWidth = sectionInset.left + sectionInset.right;
    CGFloat pageInsetWidth = pageInset.left + pageInset.right;
    CGFloat cellWidth = (self.bounds.size.width - sectionInsetWidth - pageInsetWidth)/pointCount;
    NSInteger index = (touchLocation.x - pageInset.left - sectionInset.left)/cellWidth;

    // Don't allow interaction in the dimmed line insets
    CGFloat leftInsetX = 0;
    if ([self.lineChartDataSource respondsToSelector:@selector(chartView:leftLineInsetInPage:)]) {
        NSInteger index = [self.lineChartDataSource chartView:self leftLineInsetInPage:self.currentPage];
        leftInsetX = cellWidth*index + cellWidth/2.0;
    }
    CGFloat rightInsetX = 0;
    if ([self.lineChartDataSource respondsToSelector:@selector(chartView:rightLineInsetInPage:)]) {
        NSInteger index = pointCount - 1 - [self.lineChartDataSource chartView:self
                                                          rightLineInsetInPage:self.currentPage];
        rightInsetX = cellWidth*index + cellWidth/2.0;
    }

    BOOL locationIsOutsideLine = NO;
    if (touchLocation.x < leftInsetX || touchLocation.x > rightInsetX) {
        locationIsOutsideLine = YES;
    }

    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    index = MIN(MAX(0, index), pointCount - 1);
    CGFloat value = [self.dataSource chartView:self valueForPointInPage:self.currentPage atIndex:index];
    CGFloat scaledValue = [CHChartView scaledValue:value minValue:min maxValue:max];
    CGFloat height = self.bounds.size.height - self.headerHeight;
    CGFloat y = (1 - scaledValue)*(height - self.footerHeight) + self.headerHeight;
    CGFloat x = (index * cellWidth) + cellWidth*0.5 + pageInset.left + sectionInset.left;
    CGPoint highlightPointPosition = CGPointMake(x, y);

    BOOL touchBegan = NO;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan && !locationIsOutsideLine) {
        self.cursorIsActive = YES;
        [UIView animateWithDuration:self.cursorEntranceAnimationDuration animations:^{
            self.cursorColumnView.alpha = 1;
            self.cursorPointView.alpha = 1;
        }];
        touchBegan = YES;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
             gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        self.cursorIsActive = NO;
        [UIView animateWithDuration:self.cursorExitAnimationDuration animations:^{
            self.cursorColumnView.alpha = 0;
            self.cursorPointView.alpha = 0;
        } completion:^(BOOL finished) {
            if ([self.lineChartDelegate respondsToSelector:@selector(chartView:cursorDisappearedInPage:atIndex:value:position:)]) {
                [self.lineChartDelegate chartView:self cursorDisappearedInPage:self.currentPage
                                          atIndex:index value:value position:highlightPointPosition];
            }
        }];
        self.touchGR.enabled = NO;
    }

    if (locationIsOutsideLine) {
        return;
    }

    void(^updateBlock)() = ^() {
        [self.cursorPointView setCenter:CGPointMake(x, y)];
        [self.cursorColumnView setCenter:CGPointMake(x, self.cursorColumnView.center.y)];
    };

    if (!touchBegan) {
        [UIView animateWithDuration:self.cursorMovementAnimationDuration animations:^{
            updateBlock();
        }];
    }
    else {
        updateBlock();
    }

    if (touchBegan) {
        if ([self.lineChartDelegate respondsToSelector:@selector(chartView:cursorAppearedInPage:atIndex:value:position:)]) {
            [self.lineChartDelegate chartView:self cursorAppearedInPage:self.currentPage
                                      atIndex:index value:value position:highlightPointPosition];
        }
    }
    else if (self.cursorIsActive) {
        if ([self.lineChartDelegate respondsToSelector:@selector(chartView:cursorMovedInPage:toIndex:value:position:)]) {
            [self.lineChartDelegate chartView:self cursorMovedInPage:self.currentPage
                                      toIndex:index value:value position:highlightPointPosition];
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHPointCell *cell = (CHPointCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.pointView.hidden = YES;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [super collectionView:collectionView
                         viewForSupplementaryElementOfKind:kind
                                               atIndexPath:indexPath];
    NSInteger pointCount = [self.dataSource chartView:self numberOfPointsInPage:indexPath.section];
    if (kind == CHSupplementaryElementKindFooter) {
        CHFooterView *footerView = (CHFooterView *)view;
        if ([self.dataSource respondsToSelector:@selector(configureXAxisLabel:forPointInPage:atIndex:inChartView:)]) {
            for (int i=0; i < pointCount; i++) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                [self.dataSource configureXAxisLabel:label forPointInPage:indexPath.section
                                             atIndex:i inChartView:self];
                CGFloat relativeX = 0.5;
                if (pointCount > 1) {
                    relativeX = (i/(float)(pointCount)) + (0.5/(float)(pointCount));
                }
                [footerView setXAxisLabel:label atRelativeXPosition:relativeX];
            }
        }
        view = footerView;
    }
    else if (kind == CHSupplementaryElementKindLine) {
        CHLineView *lineView = [collectionView dequeueReusableSupplementaryViewOfKind:CHSupplementaryElementKindLine
                                                                  withReuseIdentifier:kCHLineViewReuseId
                                                                         forIndexPath:indexPath];
        lineView.footerHeight = self.footerHeight;
        CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
        CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:pointCount];
        for (int i = 0; i < pointCount; i++) {
            CGFloat value = [self.dataSource chartView:self valueForPointInPage:indexPath.section atIndex:i];
            [values addObject:@(value)];
        }

        lineView.lineColor = [UIColor whiteColor];
        if ([self.lineChartDataSource respondsToSelector:@selector(chartView:lineColorInPage:)]) {
            lineView.lineColor = [self.lineChartDataSource chartView:self lineColorInPage:indexPath.section];
        }

        if ([self.lineChartDataSource respondsToSelector:@selector(chartView:lineTintColorInPage:)]) {
            lineView.lineTintColor = [self.lineChartDataSource chartView:self lineTintColorInPage:indexPath.section];
        }

        if ([self.lineChartDataSource respondsToSelector:@selector(chartView:lineWidthInPage:)]) {
            lineView.lineWidth = [self.lineChartDataSource chartView:self lineWidthInPage:indexPath.section];
        }

        NSArray *regions = nil;
        if ([self.lineChartDataSource respondsToSelector:@selector(chartView:regionsInPage:)]) {
            regions = [self.lineChartDataSource chartView:self regionsInPage:self.currentPage];
        }

        [lineView setMinValue:min maxValue:max animated:NO completion:nil];

        lineView.lineInsetAlpha = self.lineInsetAlpha;
        CGFloat leftInset = 0;
        if ([self.lineChartDataSource respondsToSelector:@selector(chartView:leftLineInsetInPage:)]) {
            leftInset = [self.lineChartDataSource chartView:self leftLineInsetInPage:indexPath.section];
        }
        CGFloat rightInset = 0;
        if ([self.lineChartDataSource respondsToSelector:@selector(chartView:rightLineInsetInPage:)]) {
            rightInset = [self.lineChartDataSource chartView:self rightLineInsetInPage:indexPath.section];
        }       
        [lineView drawLineWithValues:values regions:regions
                           leftInset:leftInset rightInset:rightInset animated:YES];
        [self.visibleLineViews setObject:lineView forKey:indexPath];
        view = lineView;
    }
    return view;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHPagingChartFlowLayout *layout = (CHPagingChartFlowLayout *)collectionViewLayout;
    CGFloat itemHeight = self.collectionView.bounds.size.height;
    CGFloat sectionInsetWidth = layout.sectionInset.left + layout.sectionInset.right;
    CGFloat pageInsetWidth = layout.pageInset.left + layout.pageInset.right;
    CGFloat itemWidth = (collectionView.bounds.size.width - sectionInsetWidth - pageInsetWidth);
    return CGSizeMake(itemWidth, itemHeight);
}

@end
