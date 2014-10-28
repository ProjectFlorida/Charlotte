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
 *  Asks the data source for an array of CHChartRegion objects describing colored regions to draw below the line.
 *
 *  @param chartView The chart view requesting the regions.
 *  @param page      The page on which the regions should be drawn.
 *
 *  @return An array of CHChartRegion objects.
 */
- (NSArray *)chartView:(CHChartView *)chartView regionsInPage:(NSInteger)page;

@end

@interface CHLineChartView : CHChartView

/**
 *  The highlighted views displayed when the chart is touched animate between the chart's points with this duration.
 */
@property (nonatomic, readonly) CGFloat highlightMovementAnimationDuration;

/**
 *  The highlighted views displayed when the chart is touched appear with this duration.
 */
@property (nonatomic, readonly) CGFloat highlightEntranceAnimationDuration;

/**
 *  The highlighted views displayed when the chart is touched disappear with this duration.
 */
@property (nonatomic, readonly) CGFloat highlightExitAnimationDuration;

/**
 *  A Boolean value that determines whether tapping the chart causes the nearest point to be highlighted.
 *  The default value is YES.
 */
@property (nonatomic, assign) BOOL showsHighlightWhenTouched;

@property (nonatomic, weak) id<CHChartTouchDelegate> touchDelegate;
@property (nonatomic, weak) id<CHLineChartDataSource> lineChartDataSource;

@end
