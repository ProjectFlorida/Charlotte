//
//  CHBarChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartView.h"

@class CHBarChartView;

@protocol CHBarChartViewDataSource <NSObject>
@optional

/**
 *  Asks the data source for the specified bar's color.
 *
 *  @param chartview the chart view requesting the bar color
 *  @param page      the page index of the bar
 *  @param index     the index of the bar in the chart page
 *
 *  @return A UIColor object.
 */
- (UIColor *)chartView:(CHBarChartView *)chartView colorForBarWithValue:(CGFloat)value inPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for the specified bar's border dash pattern.
 *
 *  @param chartview the chart view requesting the dash pattern
 *  @param page      the page index of the bar
 *  @param index     the index of the bar in the chart page
 *
 *  @return An array of NSNumber objects that specify the lengths of the painted segments and unpainted segments, 
 *  respectively, of the dash pattern. You may return nil (a solid line).
 */
- (NSArray *)chartView:(CHBarChartView *)chartView borderDashPatternForBarWithValue:(CGFloat)value inPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for the specified bar's border color.
 *
 *  @param chartView The chart view requesting the border color
 *  @param page      The page index of the bar
 *  @param index     The index of the bar in the chart page
 *
 *  @return A UIColor object. You may return nil.
 */
- (UIColor *)chartView:(CHBarChartView *)chartView borderColorForBarWithValue:(CGFloat)value inPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for the specified bar's border width.
 *
 *  @param chartview the chart view requesting the border width
 *  @param page      the page index of the bar
 *  @param index     the index of the bar in the chart page
 *
 *  @return A CGFloat value.
 */
- (CGFloat)chartView:(CHBarChartView *)chartView borderWidthForBarWithValue:(CGFloat)value inPage:(NSInteger)page atIndex:(NSInteger)index;

@end

@interface CHBarChartView : CHChartView

@property (nonatomic, weak) id<CHBarChartViewDataSource> barChartDataSource;

/**
 *  The width of bars relative to their maximum width. Default is 0.5.
 *  If this value is set to 1.0, bars will be flush with each other.
 */
@property (nonatomic, assign) CGFloat relativeBarWidth;

@end
