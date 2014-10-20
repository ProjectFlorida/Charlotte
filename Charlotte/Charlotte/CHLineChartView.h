//
//  CHLineChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartView.h"

extern NSString *const CHSupplementaryElementKindLine;

@protocol CHChartTouchDelegate <NSObject>

@optional
- (void)chartView:(CHChartView *)chartView touchBeganInPage:(NSInteger)page nearestIndex:(NSInteger)index;
- (void)chartView:(CHChartView *)chartView touchMovedInPage:(NSInteger)page nearestIndex:(NSInteger)index;
- (void)chartView:(CHChartView *)chartView touchEndedInPage:(NSInteger)page nearestIndex:(NSInteger)index;

@end

@interface CHLineChartView : CHChartView

/**
 *  The highlighted column displayed when the chart is touched animates between the chart's points with this duration.
 *  Default is 0.1
 */
@property (nonatomic, readonly) CGFloat highlightMovementAnimationDuration;
@property (nonatomic, weak) id<CHChartTouchDelegate> touchDelegate;

@end
