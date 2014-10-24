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

    [super initialize];

    self.xAxisLineHidden = YES;
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHBarCell *cell = (CHBarCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];

    // required
    cell.barColor = [self.barChartDataSource chartView:self colorForBarWithValue:cell.value
                                                inPage:indexPath.section atIndex:indexPath.row];
    cell.borderDashPattern = [self.barChartDataSource chartView:self borderDashPatternForBarWithValue:cell.value
                                                         inPage:indexPath.section atIndex:indexPath.row];
    cell.shadowOpacity = [self.barChartDataSource chartView:self shadowOpacityForBarWithValue:cell.value
                                                     inPage:indexPath.section atIndex:indexPath.row];
    cell.tintColor = [self.barChartDataSource chartView:self tintColorForBarWithValue:cell.value
                                                 inPage:indexPath.section atIndex:indexPath.row];
    cell.borderWidth = [self.barChartDataSource chartView:self borderWidthForBarWithValue:cell.value
                                                   inPage:indexPath.section atIndex:indexPath.row];
    cell.borderColor = [self.barChartDataSource chartView:self borderColorForBarWithValue:cell.value
                                                   inPage:indexPath.section atIndex:indexPath.row];

    return cell;
}

@end
