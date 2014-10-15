//
//  CHBarChartView.m
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHBarChartView.h"
#import "CHBarCell.h"
#import "CHChartView_Private.h"

@implementation CHBarChartView

- (void)initialize
{
    [super initialize];
    self.cellReuseId = kCHBarCellReuseId;
    [self.collectionView registerClass:[CHBarCell class] forCellWithReuseIdentifier:kCHBarCellReuseId];
}

@end
