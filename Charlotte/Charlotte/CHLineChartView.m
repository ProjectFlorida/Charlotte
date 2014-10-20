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
#import "CHChartView_Private.h"
#import "CHPagingLineChartFlowLayout.h"
#import "CHTouchGestureRecognizer.h"

NSString *const CHSupplementaryElementKindLine = @"CHSupplementaryElementKindLine";

@interface CHLineChartView ()

@property (nonatomic, strong) NSMapTable *visibleLineViews;
@property (nonatomic, strong) CHTouchGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) UIView *highlightView;
@property (nonatomic, assign) CGFloat highlightViewWidth;

@end

@implementation CHLineChartView

- (void)initialize
{
    self.cellReuseId = kCHPointCellReuseId;
    self.cellClass = [CHPointCell class];

    [super initialize];

    _highlightViewWidth = 20;
    _highlightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _highlightViewWidth, self.bounds.size.height)];
    _highlightView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.4];
    _highlightView.alpha = 0;
    [self addSubview:_highlightView];

    _visibleLineViews = [NSMapTable strongToWeakObjectsMapTable];
    _gestureRecognizer = [[CHTouchGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)];
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
    self.highlightView.frame = CGRectMake(self.highlightView.frame.origin.x,
                                          0,
                                          self.highlightView.frame.size.width,
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

- (void)touchAction:(CHTouchGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.highlightView.alpha = 1;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.highlightView.alpha = 0;
    }
    CGPoint location = [gestureRecognizer locationInView:self];
    [self.highlightView setCenter:CGPointMake(location.x, self.highlightView.center.y)];
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
        [lineView redrawWithValues:points];
        [self.visibleLineViews setObject:lineView forKey:indexPath];
        view = lineView;
    }
    return view;
}

@end
