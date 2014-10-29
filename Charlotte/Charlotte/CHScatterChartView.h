//
//  CHScatterChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/28/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHLineChartView.h"

@class CHScatterChartView;

@protocol CHScatterChartViewDataSource <NSObject>

/**
 *  Asks the data source for the number of scatter points in the specified page.
 *
 *  @param chartView The chart view requesting the number of points
 *  @param page      The index of the page in `chartView`
 *
 *  @return The number of scatter points in the specified page.
 */
- (NSInteger)chartView:(CHScatterChartView *)chartView numberOfScatterPointsInPage:(NSInteger)page;

/**
 *  Asks the data source for the value of the specified scatter point.
 *
 *  @param chartView The chart view requesting the value
 *  @param page      The index of the page in `chartView`
 *  @param index     The index of the scatter point in `page`
 *
 *  @return The scatter point's value.
 */
- (CGFloat)chartView:(CHScatterChartView *)chartView valueOfScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index;

@optional

/**
 *  Asks the data source for the index of the interactive point.
 *  This index should be greater than or equal to 0 and less than the number of scatter points in the page.
 *
 *  @param chartView The chart view requesting the index
 *  @param page      The index of the page in `chartView
 *
 *  @return The index of the interactive point.
 */
- (NSInteger)chartView:(CHScatterChartView *)chartView indexOfInteractivePointInPage:(NSInteger)page;

/**
 *  Asks the data source for the value of the interactive point.
 *
 *  @param chartView The chart view requesting the index
 *  @param page      The index of the page in `chartView
 *
 *  @return The value of the interactive point.
 */
- (CGFloat)chartView:(CHScatterChartView *)chartView valueOfInteractivePointInPage:(NSInteger)page;

/**
 *  Asks the data source for the interactive point's view.
 *
 *  @param chartView The chart view requesting the index
 *  @param page      The index of the page in `chartView
 *
 *  @return A UIView object.
 */
- (UIView *)chartView:(CHScatterChartView *)chartView viewForInteractivePointInPage:(NSInteger)page;

/**
 *  Asks the data source for the color of the specified scatter point.
 *
 *  @param chartView The chart view requesting the color
 *  @param page      The index of the page in `chartView`
 *  @param index     The index of the scatter point in `page`
 *
 *  @return The scatter point's color. The default is white.
 */
- (UIColor *)chartView:(CHScatterChartView *)chartView colorOfScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for the radius of the specified scatter point.
 *
 *  @param chartView The chart view requesting the radius
 *  @param page      The index of the page in `chartView`
 *  @param index     The index of the scatter point in `page`
 *
 *  @return The scatter point's radius, in points. The default is 2.
 */
- (CGFloat)chartView:(CHScatterChartView *)chartView radiusOfScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index;

@end

@protocol CHScatterChartViewDelegate <NSObject>
@optional

- (void)chartView:(CHScatterChartView *)chartView didSelectInteractivePointInPage:(NSInteger)page frame:(CGRect)frame;

@end

@interface CHScatterChartView : CHLineChartView

@property (nonatomic, weak) id<CHScatterChartViewDataSource> scatterChartDataSource;
@property (nonatomic, weak) id<CHScatterChartViewDelegate> scatterChartDelegate;

@end
