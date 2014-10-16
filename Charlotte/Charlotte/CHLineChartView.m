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

@implementation CHLineChartView

- (void)initialize
{
    self.cellReuseId = kCHPointCellReuseId;
    self.cellClass = [CHPointCell class];

    [super initialize];

    [self.collectionView registerClass:[CHLineView class]
            forSupplementaryViewOfKind:CHSupplementaryElementKindLine
                   withReuseIdentifier:kCHLineViewReuseId];
    self.collectionViewLayout = [[CHPagingLineChartFlowLayout alloc] init];
    [self.collectionView setCollectionViewLayout:self.collectionViewLayout animated:NO];
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
    NSInteger page = indexPath.section;
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
        view.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.1];

        CGFloat min = [self.dataSource chartView:self minValueForPage:page];
        CGFloat max = [self.dataSource chartView:self maxValueForPage:page];
        NSInteger pointCount = [self.dataSource chartView:self numberOfPointsInPage:page];
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:pointCount];
        for (int i = 0; i < pointCount; i++) {
            CGFloat value = [self.dataSource chartView:self valueForPointInPage:page atIndex:i];
            CGFloat relativeValue = [CHChartView relativeValue:value minValue:min maxValue:max];
            CGPoint point = CGPointMake(i, relativeValue);
            [points addObject:[NSValue valueWithCGPoint:point]];
        }
        [((CHLineView *)view) setPoints:points];
    }
    return view;
}

@end
