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
#import "CHHighlightPointView.h"
#import "CHGradientView.h"
#import "CHFooterView.h"

NSString *const CHSupplementaryElementKindLine = @"CHSupplementaryElementKindLine";

@interface CHLineChartView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMapTable *visibleLineViews;
@property (nonatomic, strong) CHTouchGestureRecognizer *touchGR;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGR;
@property (nonatomic, strong) CHGradientView *highlightColumnView;
@property (nonatomic, strong) CHHighlightPointView *highlightPointView;
@property (nonatomic, assign) CGFloat highlightColumnWidth;

@end

@implementation CHLineChartView

- (void)initialize
{
    self.cellReuseId = kCHPointCellReuseId;
    self.cellClass = [CHPointCell class];

    [super initialize];

    _showsHighlightWhenTouched = YES;
    _highlightMovementAnimationDuration = 0.2;
    _highlightEntranceAnimationDuration = 0.15;
    _highlightExitAnimationDuration = 0.15;
    _highlightColumnWidth = 19;
    _highlightColumnView = [[CHGradientView alloc] initWithFrame:CGRectMake(0, 0,
                                                                            _highlightColumnWidth,
                                                                            self.bounds.size.height)];
    _highlightColumnView.locations = @[@0, @0.35, @0.65, @1];
    _highlightColumnView.colors = @[[[UIColor whiteColor] colorWithAlphaComponent:0.4],
                                    [[UIColor whiteColor] colorWithAlphaComponent:0.15],
                                    [[UIColor whiteColor] colorWithAlphaComponent:0.15],
                                    [[UIColor whiteColor] colorWithAlphaComponent:0.4]];
    _highlightColumnView.startPoint = CGPointMake(0, 0.5);
    _highlightColumnView.endPoint = CGPointMake(1, 0.5);
    _highlightColumnView.alpha = 0;
    [self addSubview:_highlightColumnView];

    _highlightPointView = [[CHHighlightPointView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                 _highlightColumnWidth*0.85,
                                                                                 _highlightColumnWidth*0.85)];
    _highlightPointView.alpha = 0;
    [self addSubview:_highlightPointView];

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
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 28, 0, 28);
    [self.collectionView setCollectionViewLayout:self.collectionViewLayout animated:NO];

    [self initializeConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.highlightColumnView.frame = CGRectMake(self.highlightColumnView.frame.origin.x,
                                                0,
                                                self.highlightColumnView.frame.size.width,
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
    self.touchGR.enabled = YES;
    [self handleTouchGesture:gestureRecognizer];
}

- (void)handleTouchGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.showsHighlightWhenTouched) {
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

    if (index == NSNotFound) {
        return;
    }

    BOOL touchBegan = NO;
    BOOL touchEnded = NO;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:self.highlightEntranceAnimationDuration animations:^{
            self.highlightColumnView.alpha = 1;
            self.highlightPointView.alpha = 1;
        }];
        touchBegan = YES;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:self.highlightExitAnimationDuration animations:^{
            self.highlightColumnView.alpha = 0;
            self.highlightPointView.alpha = 0;
        }];
        touchEnded = YES;
        self.touchGR.enabled = NO;
    }
    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    index = MIN(MAX(0, index), pointCount - 1);
    CGFloat value = [self.dataSource chartView:self valueForPointInPage:self.currentPage atIndex:index];
    CGFloat scaledValue = [CHChartView scaledValue:value minValue:min maxValue:max];
    CGFloat height = self.bounds.size.height - self.headerHeight;
    CGFloat y = (1 - scaledValue) * height + self.headerHeight - self.footerHeight;
    CGFloat x = MIN(MAX(self.collectionViewLayout.pageInset.left + self.collectionViewLayout.sectionInset.left,
                        touchLocation.x),
                    self.bounds.size.width - self.collectionViewLayout.pageInset.right - self.collectionViewLayout.sectionInset.right);
    CGPoint highlightPointPosition = CGPointMake(x, y);

    void(^updateBlock)() = ^() {
        [self.highlightPointView setCenter:CGPointMake(x, y)];
        [self.highlightColumnView setCenter:CGPointMake(x, self.highlightColumnView.center.y)];
    };

    if (!touchBegan) {
        [UIView animateWithDuration:self.highlightMovementAnimationDuration animations:^{
            updateBlock();
        }];
    }
    else {
        updateBlock();
    }

    if (touchBegan) {
        if ([self.lineChartDelegate respondsToSelector:@selector(chartView:highlightBeganInPage:atIndex:value:position:)]) {
            [self.lineChartDelegate chartView:self highlightBeganInPage:self.currentPage
                                      atIndex:index value:value position:highlightPointPosition];
        }
    }
    else if (touchEnded) {
        if ([self.lineChartDelegate respondsToSelector:@selector(chartView:highlightEndedInPage:atIndex:value:position:)]) {
            [self.lineChartDelegate chartView:self highlightEndedInPage:self.currentPage
                                      atIndex:index value:value position:highlightPointPosition];
        }
    }
    else {
        if ([self.lineChartDelegate respondsToSelector:@selector(chartView:highlightMovedInPage:toIndex:value:position:)]) {
            [self.lineChartDelegate chartView:self highlightMovedInPage:self.currentPage
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
                [self.dataSource configureXAxisLabel:label forPointInPage:indexPath.section atIndex:i inChartView:self];
                [footerView setXAxisLabel:label atRelativeXPosition:i/(float)pointCount];
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
        [lineView drawLineWithValues:values regions:regions];
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
