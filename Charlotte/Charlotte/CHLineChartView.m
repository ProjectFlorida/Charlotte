//
//  CHLineChartView.m
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHLineChartView.h"
#import "CHPointCell_Private.h"
#import "CHLineView.h"
#import "CHChartViewSubclass.h"
#import "CHPagingLineChartFlowLayout.h"
#import "CHTouchGestureRecognizer.h"
#import "CHHighlightPointView.h"
#import "CHGradientView.h"

NSString *const CHSupplementaryElementKindLine = @"CHSupplementaryElementKindLine";

@interface CHLineChartView ()

@property (nonatomic, strong) NSMapTable *visibleLineViews;
@property (nonatomic, strong) CHTouchGestureRecognizer *gestureRecognizer;
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

    _highlightMovementAnimationDuration = 0.1;
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
    _gestureRecognizer = [[CHTouchGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchGesture:)];
    [self addGestureRecognizer:_gestureRecognizer];

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
    self.highlightColumnView.frame = CGRectMake(self.highlightColumnView.frame.origin.x,
                                                0,
                                                self.highlightColumnView.frame.size.width,
                                                self.bounds.size.height);
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

- (void)updateRangeInVisibleLineViews
{
    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    NSEnumerator *keyEnumerator = [self.visibleLineViews keyEnumerator];
    NSIndexPath *indexPath;
    while ((indexPath = keyEnumerator.nextObject) && indexPath) {
        CHLineView *lineView = [self.visibleLineViews objectForKey:indexPath];
        [lineView setMinValue:min maxValue:max animated:YES completion:nil];
    }
}

- (void)updateRangeInVisibleCells
{
    [super updateRangeInVisibleCells];
    [self updateRangeInVisibleLineViews];
}

#pragma mark - Gesture recognizer

- (void)handleTouchGesture:(CHTouchGestureRecognizer *)gestureRecognizer
{
    BOOL touchBegan = NO;
    BOOL touchEnded = NO;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.highlightColumnView.alpha = 1;
        self.highlightPointView.alpha = 1;
        touchBegan = YES;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.highlightColumnView.alpha = 0;
        self.highlightPointView.alpha = 0;
        touchEnded = YES;
    }
    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    CGPoint touchLocation = [gestureRecognizer locationInView:self];
    CHPagingLineChartFlowLayout *layout = (CHPagingLineChartFlowLayout *)self.collectionViewLayout;
    NSInteger index = [layout nearestIndexAtLocation:touchLocation
                                              inPage:self.currentPage];
    CGFloat value = [self.dataSource chartView:self valueForPointInPage:self.currentPage atIndex:index];
    CGFloat scaledValue = [CHChartView scaledValue:value minValue:min maxValue:max];
    CGFloat height = self.bounds.size.height - self.footerHeight;
    CGFloat y = (1 - scaledValue) * height;

    void(^updateBlock)() = ^() {
        [self.highlightPointView setCenter:CGPointMake(touchLocation.x, y)];
        [self.highlightColumnView setCenter:CGPointMake(touchLocation.x, self.highlightColumnView.center.y)];
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
        if ([self.touchDelegate respondsToSelector:@selector(chartView:touchBeganInPage:nearestIndex:)]) {
            [self.touchDelegate chartView:self touchBeganInPage:self.currentPage nearestIndex:index];
        }
    }
    else if (touchEnded) {
        if ([self.touchDelegate respondsToSelector:@selector(chartView:touchEndedInPage:nearestIndex:)]) {
            [self.touchDelegate chartView:self touchEndedInPage:self.currentPage nearestIndex:index];
        }
    }
    else {
        if ([self.touchDelegate respondsToSelector:@selector(chartView:touchMovedInPage:nearestIndex:)]) {
            [self.touchDelegate chartView:self touchMovedInPage:self.currentPage nearestIndex:index];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHPointCell *cell = (CHPointCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.valueLabelHidden = YES;
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
    if (view) {
        return view;
    }
    if (kind == CHSupplementaryElementKindLine) {
        CHLineView *lineView = [collectionView dequeueReusableSupplementaryViewOfKind:CHSupplementaryElementKindLine
                                                                  withReuseIdentifier:kCHLineViewReuseId
                                                                         forIndexPath:indexPath];
        lineView.chartBackgroundColor = self.backgroundColor;
        lineView.footerHeight = self.footerHeight;
        CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
        CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
        NSInteger count = [self.dataSource chartView:self numberOfPointsInPage:indexPath.section];
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            CGFloat value = [self.dataSource chartView:self valueForPointInPage:indexPath.section atIndex:i];
            [points addObject:@(value)];
        }
        [lineView setMinValue:min maxValue:max animated:NO completion:nil];
        NSDictionary *regions = [self.lineChartDataSource chartView:self regionsInPage:self.currentPage];
        [lineView drawLineWithValues:points regions:regions];
        [self.visibleLineViews setObject:lineView forKey:indexPath];
        view = lineView;
    }
    return view;
}

@end
