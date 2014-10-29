//
//  CHLineChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartView.h"

extern NSString *const CHSupplementaryElementKindLine;

@class CHLineChartView;

@protocol CHLineChartViewDelegate <NSObject>
@optional

/**
 *  Tells the delegate that the user began highlighting a point in the chart view
 *
 *  @param chartView The chart view being highlighted
 *  @param page      The page of the current highlighted point
 *  @param index     The index of the current highlighted point
 *  @param position  The position of the highlighted point
 */
- (void)chartView:(CHLineChartView *)chartView highlightBeganInPage:(NSInteger)page atIndex:(NSInteger)index position:(CGPoint)position;

/**
 *  Tells the delegate that the user moved to highlight a different point in the chart view
 *
 *  @param chartView The chart view being highlighted
 *  @param page      The page of the current highlighted point
 *  @param index     The index of the current highlighted point
 *  @param position  The position of the highlighted point
 */
- (void)chartView:(CHLineChartView *)chartView highlightMovedInPage:(NSInteger)page toIndex:(NSInteger)index position:(CGPoint)position;

/**
 *  Tells the delegate that the user stopped highlighting a point in the chart view
 *
 *  @param chartView The chart view that was being highlighted
 *  @param page      The page of the last highlighted point
 *  @param index     The index of the last highlighted point
 *  @param position  The position of the last highlighted point
 */
- (void)chartView:(CHLineChartView *)chartView highlightEndedInPage:(NSInteger)page atIndex:(NSInteger)index position:(CGPoint)position;

@end

@protocol CHLineChartViewDataSource <NSObject>
@optional

/**
 *  Asks the data source for an array of CHChartRegion objects describing colored regions to draw below the line.
 *
 *  @param chartView The chart view requesting the regions.
 *  @param page      The page on which the regions should be drawn.
 *
 *  @return An array of CHChartRegion objects.
 */
- (NSArray *)chartView:(CHLineChartView *)chartView regionsInPage:(NSInteger)page;

/**
 *  Asks the data source for the color of the line in the specified page.
 *
 *  @param chartView The chart view requesting the line color
 *  @param page      The line's page index
 *
 *  @return A UIColor object.
 */
- (UIColor *)chartView:(CHLineChartView *)chartView lineColorInPage:(NSInteger)page;

/**
 *  Asks the data source for the tint color of the line in the specified page.
 *  If a tint color is provided, a gradient will be drawn from the line's tint color (left) to the line's color (right).
 *
 *  @param chartView The chart view requesting the line color
 *  @param page      The line's page index
 *
 *  @return A UIColor object.
 */
- (UIColor *)chartView:(CHLineChartView *)chartView lineTintColorInPage:(NSInteger)page;

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

@property (nonatomic, weak) id<CHLineChartViewDelegate> lineChartDelegate;
@property (nonatomic, weak) id<CHLineChartViewDataSource> lineChartDataSource;

@end
