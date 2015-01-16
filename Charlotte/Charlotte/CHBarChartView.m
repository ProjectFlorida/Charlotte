//
//  CHBarChartView.m
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHBarChartView.h"
#import "CHBarCell.h"
#import "CHChartViewSubclass.h"

@implementation CHBarChartView

- (void)initialize
{
    self.cellReuseId = kCHBarCellReuseId;
    self.cellClass = [CHBarCell class];
    self.relativeBarWidth = 0.5;

    [super initialize];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHBarCell *cell = (CHBarCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];

    cell.relativeBarWidth = self.relativeBarWidth;

    if ([self.barChartDataSource respondsToSelector:@selector(chartView:colorForBarWithValue:inPage:atIndex:)]) {
        cell.barColor = [self.barChartDataSource chartView:self colorForBarWithValue:cell.value
                                                    inPage:indexPath.section atIndex:indexPath.row];
    }

    if ([self.barChartDataSource respondsToSelector:@selector(chartView:borderDashPatternForBarWithValue:inPage:atIndex:)]) {
        cell.borderDashPattern = [self.barChartDataSource chartView:self borderDashPatternForBarWithValue:cell.value
                                                             inPage:indexPath.section atIndex:indexPath.row];
    }

    if ([self.barChartDataSource respondsToSelector:@selector(chartView:borderWidthForBarWithValue:inPage:atIndex:)]) {
        cell.borderWidth = [self.barChartDataSource chartView:self borderWidthForBarWithValue:cell.value
                                                       inPage:indexPath.section atIndex:indexPath.row];
    }

    if ([self.barChartDataSource respondsToSelector:@selector(chartView:borderColorForBarWithValue:inPage:atIndex:)]) {
        cell.borderColor = [self.barChartDataSource chartView:self borderColorForBarWithValue:cell.value
                                                       inPage:indexPath.section atIndex:indexPath.row];
    }

    return cell;
}

@end
