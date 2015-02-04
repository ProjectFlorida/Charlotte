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
    self.cellReuseId = CHBarCellReuseId;
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

    if ([self.barChartDataSource respondsToSelector:@selector(chartView:colorForBarInPage:atIndex:)]) {
        cell.barColor = [self.barChartDataSource chartView:self colorForBarInPage:indexPath.section
                                                   atIndex:indexPath.row];
    }

    if ([self.barChartDataSource respondsToSelector:@selector(chartView:borderDashPatternForBarInPage:atIndex:)]) {
        cell.borderDashPattern = [self.barChartDataSource chartView:self borderDashPatternForBarInPage:indexPath.section
                                                            atIndex:indexPath.row];
    }

    if ([self.barChartDataSource respondsToSelector:@selector(chartView:borderWidthForBarInPage:atIndex:)]) {
        cell.borderWidth = [self.barChartDataSource chartView:self borderWidthForBarInPage:indexPath.section
                                                      atIndex:indexPath.row];
    }

    if ([self.barChartDataSource respondsToSelector:@selector(chartView:borderColorForBarInPage:atIndex:)]) {
        cell.borderColor = [self.barChartDataSource chartView:self borderColorForBarInPage:indexPath.section
                                                      atIndex:indexPath.row];
    }

    return cell;
}

@end
