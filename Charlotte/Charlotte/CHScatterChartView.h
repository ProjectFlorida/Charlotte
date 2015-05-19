//
//  CHScatterChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/28/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHLineChartView.h"

@class CHScatterChartView;

@protocol CHScatterChartViewDataSource <NSObject>

/**
 *  Asks the data source for the number of scatter points in the specified page.
 *
 *  @param chartView The chart view requesting the number of points
 *
 *  @return The number of scatter points in the specified page.
 */
- (NSInteger)numberOfScatterPointsInChartView:(CHScatterChartView *)chartView;

/**
 *  Asks the data source for the value of the specified scatter point.
 *
 *  @param chartView The chart view requesting the value
 *  @param index     The index of the scatter point in `page`
 *
 *  @return The scatter point's value.
 */
- (CGFloat)chartView:(CHScatterChartView *)chartView valueOfScatterPointAtIndex:(NSInteger)index;

@optional

/**
 *  Asks the data source for the index of the interactive point.
 *  This index should be greater than or equal to 0 and less than the number of scatter points in the page.
 *
 *  @param chartView The chart view requesting the index
 *
 *  @return The index of the interactive point.
 */
- (NSInteger)indexOfInteractivePointInChartView:(CHScatterChartView *)chartView;

/**
 *  Asks the data source for the value of the interactive point.
 *
 *  @param chartView The chart view requesting the index
 *
 *  @return The value of the interactive point.
 */
- (CGFloat)valueOfInteractivePointInChartView:(CHScatterChartView *)chartView;

/**
 *  Asks the data source for the interactive point's view.
 *
 *  @param chartView The chart view requesting the index
 *  @param page      The index of the page in `chartView
 *
 *  @return A UIView object.
 */
- (UIView *)viewForInteractivePointInChartView:(CHScatterChartView *)chartView;

/**
 *  Asks the data source for the color of the specified scatter point.
 *
 *  @param chartView The chart view requesting the color
 *  @param index     The index of the scatter point in `page`
 *
 *  @return The scatter point's color. The default is white.
 */
- (UIColor *)chartView:(CHScatterChartView *)chartView colorOfScatterPointAtIndex:(NSInteger)index;

/**
 *  Asks the data source for the radius of the specified scatter point.
 *
 *  @param chartView The chart view requesting the radius
 *  @param index     The index of the scatter point in `page`
 *
 *  @return The scatter point's radius, in points. The default is 2.
 */
- (CGFloat)chartView:(CHScatterChartView *)chartView radiusOfScatterPointAtIndex:(NSInteger)index;

@end

@protocol CHScatterChartViewDelegate <NSObject>
@optional

/**
 *  Tells the delegate that the user selected the interactive point in the specified page
 *
 *  @param chartView The chart view notifying the delegate
 *  @param frame     The frame of the interactive point in `chartView`
 */
- (void)chartView:(CHScatterChartView *)chartView didSelectInteractivePointWithFrame:(CGRect)frame;

@end

@interface CHScatterChartView : CHLineChartView

@property (nonatomic, weak) id<CHScatterChartViewDataSource> scatterChartDataSource;
@property (nonatomic, weak) id<CHScatterChartViewDelegate> scatterChartDelegate;

@end
