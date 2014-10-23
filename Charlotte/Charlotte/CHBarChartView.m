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
    return cell;
}

@end
