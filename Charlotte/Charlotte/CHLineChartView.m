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

NSString *const CHSupplementaryElementKindLine = @"CHSupplementaryElementKindLine";

@interface CHLineChartView ()

@property (nonatomic, strong) NSMapTable *visibleLineViews;

@end

@implementation CHLineChartView

- (void)initialize
{
    _visibleLineViews = [NSMapTable strongToWeakObjectsMapTable];
    self.cellReuseId = kCHPointCellReuseId;
    self.cellClass = [CHPointCell class];

    [super initialize];

    [self.collectionView registerClass:[CHLineView class]
            forSupplementaryViewOfKind:CHSupplementaryElementKindLine
                   withReuseIdentifier:kCHLineViewReuseId];
    self.collectionViewLayout = [[CHPagingLineChartFlowLayout alloc] init];
    [self.collectionView setCollectionViewLayout:self.collectionViewLayout animated:NO];

    [super initializeConstraints];
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
