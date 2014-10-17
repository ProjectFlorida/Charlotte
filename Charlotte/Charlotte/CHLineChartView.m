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
    cell.valueLabelHidden = NO;
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
        CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
        CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
        NSInteger pointCount = [self.dataSource chartView:self numberOfPointsInPage:indexPath.section];
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:pointCount];
        for (int i = 0; i < pointCount; i++) {
            CGFloat value = [self.dataSource chartView:self valueForPointInPage:indexPath.section atIndex:i];
            CGPoint point = CGPointMake(i, value);
            [points addObject:[NSValue valueWithCGPoint:point]];
        }
        [lineView setMinValue:min maxValue:max animated:NO completion:nil];
        [lineView setPoints:points];
        [self.visibleLineViews setObject:lineView forKey:indexPath];
        view = lineView;
    }
    return view;
}

@end
