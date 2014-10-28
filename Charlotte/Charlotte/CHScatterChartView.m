//
//  CHScatterChartView.m
//  Charlotte
//
//  Created by Ben Guo on 10/28/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHScatterChartView.h"
#import "CHChartViewSubclass.h"
#import "CHLineView.h"

@implementation CHScatterChartView

- (void)initialize
{
    [super initialize];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [super collectionView:collectionView
                         viewForSupplementaryElementOfKind:kind
                                               atIndexPath:indexPath];
    if (kind == CHSupplementaryElementKindLine) {
        CHLineView *lineView = (CHLineView *)view;
        NSInteger count = [self.scatterChartDataSource chartView:self numberOfScatterPointsInPage:indexPath.section];
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            CGFloat value = [self.scatterChartDataSource chartView:self valueForScatterPointInPage:indexPath.section
                                                           atIndex:i];
            CGFloat relativeX = i/(float)count;
            UIColor *color = [UIColor greenColor];
            CGFloat radius = 2;
            CHScatterPoint *point = [CHScatterPoint pointWithValue:value relativeXPosition:relativeX
                                                             color:color radius:radius];
            [points addObject:point];
        }
        [lineView drawScatterPoints:points];
    }
    return view;
}

@end
