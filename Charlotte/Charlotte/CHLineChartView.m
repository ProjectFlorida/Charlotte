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
#import "CHGradientView.h"
#import "CHFooterView.h"

NSString *const CHSupplementaryElementKindLine = @"CHSupplementaryElementKindLine";

@interface CHLineChartView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMapTable *visibleLineViews;
@property (nonatomic, strong) CHTouchGestureRecognizer *touchGR;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGR;
@property (nonatomic, strong) UIView *cursorView;
@property (nonatomic, strong) UIView *cursorDotView;
@property (nonatomic, assign) BOOL cursorIsActive;

@end

@implementation CHLineChartView

- (void)initialize
{
    self.cellReuseId = CHPointCellReuseId;
    self.cellClass = [CHPointCell class];

    [super initialize];

    _lineWidth = 2;
    _lineColor = [UIColor whiteColor];
    _lineTintColor = nil;

    _cursorEnabled = YES;
    _cursorIsActive = NO;
    _cursorMovementAnimationDuration = 0.2;
    _cursorEntranceAnimationDuration = 0.15;
    _cursorExitAnimationDuration = 0.15;
    _cursorWidth = 1;
    _cursorDotRadius = 4;
    _cursorTopInset = 20;
    _cursorView = [[UIView alloc] initWithFrame:CGRectZero];
    _cursorView.backgroundColor = [UIColor whiteColor];
    _cursorView.alpha = 0;
    _cursorDotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cursorDotRadius*2, _cursorDotRadius*2)];
    _cursorDotView.backgroundColor = [UIColor whiteColor];
    _cursorDotView.layer.cornerRadius = _cursorDotRadius;
    _cursorDotView.alpha = 0;
    [self addSubview:_cursorView];
    [self addSubview:_cursorDotView];

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
                   withReuseIdentifier:CHLineViewReuseId];
    self.collectionViewLayout = [[CHPagingLineChartFlowLayout alloc] init];
    [self.collectionView setCollectionViewLayout:self.collectionViewLayout animated:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
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
- (void)setCursorColor:(UIColor *)cursorColor
{
    _cursorColor = cursorColor;
    self.cursorView.backgroundColor = cursorColor;
    self.cursorDotView.backgroundColor = cursorColor;
}

- (void)setCursorDotRadius:(CGFloat)cursorDotRadius
{
    _cursorDotRadius = cursorDotRadius;
    self.cursorDotView.frame = CGRectMake(CGRectGetMinX(self.cursorDotView.frame),
                                          CGRectGetMinY(self.cursorDotView.frame),
                                          cursorDotRadius*2, cursorDotRadius*2);
    self.cursorDotView.layer.cornerRadius = cursorDotRadius;
}

- (void)setLineDrawingAnimationDuration:(NSTimeInterval)lineDrawingAnimationDuration
{
    _lineDrawingAnimationDuration = lineDrawingAnimationDuration;
    [[CHLineView appearance] setLineDrawingAnimationDuration:_lineDrawingAnimationDuration];
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

    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    index = MIN(MAX(0, index), pointCount - 1);
    NSNumber *value = [self.dataSource chartView:self valueForPointInPage:self.currentPage atIndex:index];
    BOOL isOnNullValue = !value || [value isKindOfClass:[NSNull class]];

    CGFloat scaledValue = [CHChartView scaledValue:[value floatValue]
                                          minValue:min maxValue:max];
    CGFloat height = self.bounds.size.height - self.headerHeight;
    CGFloat y = (1 - scaledValue)*(height - self.footerHeight) + self.headerHeight;
    CGFloat x = (index * cellWidth) + cellWidth*0.5 + pageInset.left + sectionInset.left;
    CGPoint highlightPointPosition = CGPointMake(x, y);

    BOOL touchBegan = NO;
    if ((gestureRecognizer.state == UIGestureRecognizerStateBegan && !isOnNullValue) ||
        (gestureRecognizer.state == UIGestureRecognizerStateChanged && !self.cursorIsActive && !isOnNullValue)) {
        self.cursorIsActive = YES;
        [UIView animateWithDuration:self.cursorEntranceAnimationDuration animations:^{
            self.cursorView.alpha = 1;
            self.cursorDotView.alpha = 1;
        }];
        touchBegan = YES;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
             gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        self.cursorIsActive = NO;
        [UIView animateWithDuration:self.cursorExitAnimationDuration animations:^{
            self.cursorView.alpha = 0;
            self.cursorDotView.alpha = 0;
        } completion:^(BOOL finished) {
            if ([self.lineChartDelegate respondsToSelector:@selector(chartView:cursorDisappearedInPage:atIndex:value:position:)]) {
                [self.lineChartDelegate chartView:self cursorDisappearedInPage:self.currentPage
                                          atIndex:index value:[value floatValue] position:highlightPointPosition];
            }
        }];
        self.touchGR.enabled = NO;
    }

    void(^updateBlock)() = ^() {
        self.cursorView.frame = CGRectMake(x - CGRectGetWidth(self.cursorView.bounds)/2.0,
                                           self.cursorTopInset,
                                           self.cursorWidth,
                                           MAX(0, y - self.cursorTopInset));
        self.cursorDotView.center = CGPointMake(x, y);
    };

    if (isOnNullValue) {
        return;
    }

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
                                      atIndex:index value:[value floatValue] position:highlightPointPosition];
        }
    }
    else if (self.cursorIsActive) {
        if ([self.lineChartDelegate respondsToSelector:@selector(chartView:cursorMovedInPage:toIndex:value:position:)]) {
            [self.lineChartDelegate chartView:self cursorMovedInPage:self.currentPage
                                      toIndex:index value:[value floatValue] position:highlightPointPosition];
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
    cell.xAxisLabelView.hidden = YES;
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
        if ([self.dataSource respondsToSelector:@selector(chartView:configureXAxisLabelView:forPointInPage:atIndex:)]) {
            for (int i=0; i < pointCount; i++) {
                UIView *labelView = [[self.xAxisLabelViewClass alloc] init];
                [self.dataSource chartView:self configureXAxisLabelView:labelView forPointInPage:indexPath.section
                                   atIndex:i];
                [labelView sizeToFit];
                CGFloat relativeX = 0.5;
                if (pointCount > 1) {
                    relativeX = (i/(float)(pointCount)) + (0.5/(float)(pointCount));
                }
                [footerView setXAxisLabelView:labelView atRelativeXPosition:relativeX];
            }
        }
        view = footerView;
    }
    else if (kind == CHSupplementaryElementKindLine) {
        CHLineView *lineView = [collectionView dequeueReusableSupplementaryViewOfKind:CHSupplementaryElementKindLine
                                                                  withReuseIdentifier:CHLineViewReuseId
                                                                         forIndexPath:indexPath];
        lineView.footerHeight = self.footerHeight;
        CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
        CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:pointCount];
        for (int i = 0; i < pointCount; i++) {
            id value = [self.dataSource chartView:self valueForPointInPage:indexPath.section atIndex:i];
            if (!value) {
                value = [NSNull null];
            }
            [values addObject:value];
        }

        lineView.lineWidth = self.lineWidth;
        lineView.lineColor = self.lineColor;
        lineView.lineTintColor = self.lineTintColor;

        [lineView setMinValue:min maxValue:max animated:NO completion:nil];
        [lineView drawLineWithValues:values animated:YES];
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
