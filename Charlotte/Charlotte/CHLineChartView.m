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

- (void)setPointsInLineView:(CHLineView *)lineView atIndexPath:(NSIndexPath *)indexPath
{
    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    NSInteger pointCount = [self.dataSource chartView:self numberOfPointsInPage:indexPath.section];
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:pointCount];
    NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    CGSize cellSize = [self collectionView:self.collectionView layout:self.collectionViewLayout
                    sizeForItemAtIndexPath:firstCellIndexPath];
    //*/
    if (indexPath.section == self.currentPage) {
        NSLog(@"-----");
    }
    //*/
    for (int i = 0; i < pointCount; i++) {
        CGFloat value = [self.dataSource chartView:self valueForPointInPage:indexPath.section atIndex:i];
        CGFloat relativeValue = [CHChartView relativeValue:value minValue:min maxValue:max];
        CGFloat displayHeight = cellSize.height - self.footerHeight;
        CGFloat centerXOffset = cellSize.width/2.0;
        CGFloat x = (i*cellSize.width) + centerXOffset;
        CGFloat y = (1 - relativeValue) * displayHeight - self.footerHeight;
        //*/
        if (indexPath.section == self.currentPage) {
            NSLog(@"l: %f %f %f ", y, value, relativeValue);
        }
        //*/
        CGPoint point = CGPointMake(x, y);
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    if (indexPath.section == self.currentPage) {
        [lineView setPoints:points log:YES];
    }
    else {
        [lineView setPoints:points];
    }
}

- (void)redrawVisibleLineViews
{
    NSEnumerator *keyEnumerator = [self.visibleLineViews keyEnumerator];
    NSIndexPath *indexPath;
    while ((indexPath = keyEnumerator.nextObject) && indexPath) {
        CHLineView *lineView = [self.visibleLineViews objectForKey:indexPath];
        [self setPointsInLineView:lineView atIndexPath:indexPath];
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
//        [self setPointsInLineView:lineView atIndexPath:indexPath];
        [self.visibleLineViews setObject:lineView forKey:indexPath];
        view = lineView;
    }
    return view;
}

@end
