//
//  CHScatterChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/28/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHLineChartView.h"

@protocol CHScatterChartViewDataSource <NSObject>

/**
 *  Asks the data source for the number of scatter points in the specified page.
 *
 *  @param chartView The chart view requesting the number of points
 *  @param page      The index of the page in `chartView`
 *
 *  @return The number of scatter points in the specified page.
 */
- (NSInteger)chartView:(CHChartView *)chartView numberOfScatterPointsInPage:(NSInteger)page;

/**
 *  Asks the data source for the value of the specified scatter point.
 *
 *  @param chartView The chart view requesting the value
 *  @param page      The index of the page in `chartView`
 *  @param index     The index of the scatter point in `page`
 *
 *  @return The scatter point's value.
 */
- (CGFloat)chartView:(CHChartView *)chartView valueForScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index;

@optional

/**
 *  Asks the data source for the color of the specified scatter point.
 *
 *  @param chartView The chart view requesting the color
 *  @param page      The index of the page in `chartView`
 *  @param index     The index of the scatter point in `page`
 *
 *  @return The scatter point's color. The default is white.
 */
- (UIColor *)chartView:(CHChartView *)chartView colorForScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for the radius of the specified scatter point.
 *
 *  @param chartView The chart view requesting the radius
 *  @param page      The index of the page in `chartView`
 *  @param index     The index of the scatter point in `page`
 *
 *  @return The scatter point's radius, in points. The default is 2.
 */
- (CGFloat)chartView:(CHChartView *)chartView radiusForScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index;

@end

@interface CHScatterChartView : CHLineChartView

@property (nonatomic, weak) id<CHScatterChartViewDataSource> scatterChartDataSource;

@end
