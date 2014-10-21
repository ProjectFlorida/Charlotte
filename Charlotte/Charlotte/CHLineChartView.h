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

@protocol CHLineChartDataSource <NSObject>

/**
 *  Asks the data source for a dictionary describing colored regions to draw underneath the line on the given page.
 *
 *  @param chartView The chart view requesting the regions.
 *  @param page      The page on which the regions should be drawn.
 *
 *  @return An NSDictionary object describing the regions to draw.
 *  Keys in this dictionary should be NSRange objects corresponding to point indices on the given chart page.
 *  Values should be UIColor objects.
 */
- (NSDictionary *)chartView:(CHChartView *)chartView regionsInPage:(NSInteger)page;

@end

@interface CHLineChartView : CHChartView

/**
 *  The highlighted views displayed when the chart is touched animate between the chart's points with this duration.
 *  Default is 0.1
 */
@property (nonatomic, readonly) CGFloat highlightMovementAnimationDuration;
@property (nonatomic, weak) id<CHChartTouchDelegate> touchDelegate;
@property (nonatomic, weak) id<CHLineChartDataSource> lineChartDataSource;

@end
