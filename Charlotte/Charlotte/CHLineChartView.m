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
    _visibleLineViews = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory];
    self.cellReuseId = kCHPointCellReuseId;
    self.cellClass = [CHPointCell class];

    [super initialize];

    [self.collectionView registerClass:[CHLineView class]
            forSupplementaryViewOfKind:CHSupplementaryElementKindLine
                   withReuseIdentifier:kCHLineViewReuseId];
    self.collectionViewLayout = [[CHPagingLineChartFlowLayout alloc] init];
    [self.collectionView setCollectionViewLayout:self.collectionViewLayout animated:NO];
}

- (void)redrawVisibleLineViews
{
    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    for (CHLineView *lineView in [[self.visibleLineViews objectEnumerator] allObjects]) {
        NSInteger pointCount = [self.dataSource chartView:self numberOfPointsInPage:self.currentPage]; //TODO use actual page
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:pointCount];
        NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentPage];
        CGSize cellSize = [self collectionView:self.collectionView layout:self.collectionViewLayout
                        sizeForItemAtIndexPath:firstCellIndexPath];
        for (int i = 0; i < pointCount; i++) {
            CGFloat value = [self.dataSource chartView:self valueForPointInPage:self.currentPage atIndex:i];
            CGFloat relativeValue = [CHChartView relativeValue:value minValue:min maxValue:max];
            CGFloat displayHeight = cellSize.height - self.footerHeight;
            CGFloat centerXOffset = cellSize.width/2.0;
            CGFloat x = (i*cellSize.width) + centerXOffset;
            CGFloat y = (1 - relativeValue) * displayHeight - self.footerHeight;
            CGPoint point = CGPointMake(x, y);
            [points addObject:[NSValue valueWithCGPoint:point]];
        }
        [lineView setPoints:points];
    }
}

- (void)updateRangeInVisibleCells
{
    [super updateRangeInVisibleCells];
    [self redrawVisibleLineViews];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHPointCell *cell = (CHPointCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.valueLabelHidden = YES;
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
        view = [collectionView dequeueReusableSupplementaryViewOfKind:CHSupplementaryElementKindLine
                                                  withReuseIdentifier:kCHLineViewReuseId
                                                         forIndexPath:indexPath];
        [self.visibleLineViews setObject:view forKey:indexPath];
    }
    return view;
}

@end
