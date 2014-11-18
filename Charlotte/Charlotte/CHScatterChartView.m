//
//  CHScatterChartView.m
//  Charlotte
//
//  Created by Ben Guo on 10/28/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHScatterChartView.h"
#import "CHChartViewSubclass.h"
#import "CHTouchGestureRecognizer.h"
#import "CHLineView.h"
#import "CHLineChartViewSubclass.h"
#import "CHFooterView.h"

@interface CHScatterChartView ()

@property (nonatomic, assign) CGPoint touchBeganLocation;

@end

@implementation CHScatterChartView

- (void)initialize
{
    [super initialize];
    self.cursorEnabled = NO;
    self.touchGR.enabled = YES;
    self.longPressGR.enabled = NO;
}

- (void)handleTouchGesture:(CHTouchGestureRecognizer *)gestureRecognizer
{
    [super handleTouchGesture:gestureRecognizer];
    CGPoint touchLocation = [gestureRecognizer locationInView:self];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.touchBeganLocation = touchLocation;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentPage];
        CHLineView *lineView = [self.visibleLineViews objectForKey:indexPath];
        CGFloat touchMargin = 20;
        CGRect pointFrame = [lineView convertRect:lineView.interactivePoint.view.frame toView:self];
        CGRect largerFrame = CGRectMake(pointFrame.origin.x - touchMargin,
                                        pointFrame.origin.y - touchMargin,
                                        pointFrame.size.width + touchMargin*2,
                                        pointFrame.size.height + touchMargin*2);
        BOOL touchBeganInPoint = CGRectContainsPoint(largerFrame, self.touchBeganLocation);
        BOOL touchEndedInPoint = CGRectContainsPoint(largerFrame, touchLocation);
        if (touchBeganInPoint && touchEndedInPoint &&
            [self.scatterChartDelegate respondsToSelector:@selector(chartView:didSelectInteractivePointInPage:frame:)])
        {
            [self.scatterChartDelegate chartView:self didSelectInteractivePointInPage:self.currentPage
                                           frame:pointFrame];
        }
    }
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
            CGFloat value = [self.scatterChartDataSource chartView:self valueOfScatterPointInPage:indexPath.section
                                                           atIndex:i];
            UIColor *color = [UIColor whiteColor];
            if ([self.scatterChartDataSource respondsToSelector:@selector(chartView:colorOfScatterPointInPage:atIndex:)]) {
                color = [self.scatterChartDataSource chartView:self colorOfScatterPointInPage:indexPath.section
                                                       atIndex:i];
            }
            CGFloat radius = 2;
            if ([self.scatterChartDataSource respondsToSelector:@selector(chartView:radiusOfScatterPointInPage:atIndex:)]) {
                radius = [self.scatterChartDataSource chartView:self radiusOfScatterPointInPage:indexPath.section
                                                        atIndex:i];
            }
            CHScatterPoint *point = [CHScatterPoint pointWithValue:value relativeXPosition:(i/(float)count)
                                                             color:color radius:radius];
            [points addObject:point];
        }
        [lineView drawScatterPoints:points animated:YES];

        if ([self.scatterChartDataSource respondsToSelector:@selector(chartView:viewForInteractivePointInPage:)] &&
            [self.scatterChartDataSource respondsToSelector:@selector(chartView:valueOfInteractivePointInPage:)] &&
            [self.scatterChartDataSource respondsToSelector:@selector(chartView:indexOfInteractivePointInPage:)]) {
            UIView *view = [self.scatterChartDataSource chartView:self viewForInteractivePointInPage:indexPath.section];
            CGFloat value = [self.scatterChartDataSource chartView:self valueOfInteractivePointInPage:indexPath.section];
            NSInteger index = [self.scatterChartDataSource chartView:self indexOfInteractivePointInPage:indexPath.section];
            CHInteractivePoint *point = [[CHInteractivePoint alloc] init];
            point.view = view;
            point.value = value;
            point.relativeXPosition = index/(float)count;
            [lineView drawInteractivePoint:point animated:YES];

        }
    }
    return view;
}

@end
