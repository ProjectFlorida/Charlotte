//
//  CHScatterChartView.m
//  Charlotte
//
//  Created by Ben Guo on 10/28/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHScatterChartView.h"
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
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
        gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        CGFloat touchMargin = 20;
        CGRect pointFrame = [self.lineView convertRect:self.lineView.interactivePoint.view.frame toView:self];
        CGRect largerFrame = CGRectMake(pointFrame.origin.x - touchMargin,
                                        pointFrame.origin.y - touchMargin,
                                        pointFrame.size.width + touchMargin*2,
                                        pointFrame.size.height + touchMargin*2);
        BOOL touchBeganInPoint = CGRectContainsPoint(largerFrame, self.touchBeganLocation);
        BOOL touchEndedInPoint = CGRectContainsPoint(largerFrame, touchLocation);
        if (touchBeganInPoint && touchEndedInPoint &&
            [self.scatterChartDelegate respondsToSelector:@selector(chartView:didSelectInteractivePointWithFrame:)])
        {
            [self.scatterChartDelegate chartView:self didSelectInteractivePointWithFrame:pointFrame];
        }
    }
}

- (void)reloadData
{
    [super reloadData];
    NSInteger count = [self.scatterChartDataSource numberOfScatterPointsInChartView:self];
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        CGFloat value = [self.scatterChartDataSource chartView:self valueOfScatterPointAtIndex:i];
        UIColor *color = [UIColor whiteColor];
        if ([self.scatterChartDataSource respondsToSelector:@selector(chartView:colorOfScatterPointAtIndex:)]) {
            color = [self.scatterChartDataSource chartView:self colorOfScatterPointAtIndex:i];
        }
        CGFloat radius = 2;
        if ([self.scatterChartDataSource respondsToSelector:@selector(chartView:radiusOfScatterPointAtIndex:)]) {
            radius = [self.scatterChartDataSource chartView:self radiusOfScatterPointAtIndex:i];
        }
        CHScatterPoint *point = [CHScatterPoint pointWithValue:value relativeXPosition:(i/(float)count)
                                                         color:color radius:radius];
        [points addObject:point];
    }
    [self.lineView drawScatterPoints:points animated:YES];

    if ([self.scatterChartDataSource respondsToSelector:@selector(viewForInteractivePointInChartView:)] &&
        [self.scatterChartDataSource respondsToSelector:@selector(valueOfInteractivePointInChartView:)] &&
        [self.scatterChartDataSource respondsToSelector:@selector(indexOfInteractivePointInChartView:)]) {
        UIView *view = [self.scatterChartDataSource viewForInteractivePointInChartView:self];
        CGFloat value = [self.scatterChartDataSource valueOfInteractivePointInChartView:self];
        NSInteger index = [self.scatterChartDataSource indexOfInteractivePointInChartView:self];
        CHInteractivePoint *point = [[CHInteractivePoint alloc] init];
        point.view = view;
        point.value = value;
        point.relativeXPosition = index/(float)count;
        [self.lineView drawInteractivePoint:point animated:YES];
    }
}

@end
