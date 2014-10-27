//
//  CHBarChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartView.h"

@protocol CHBarChartDataSource <NSObject>

/**
 *  Asks the data source for the specified bar's color.
 *
 *  @param chartview the chart view requestign the shadow opacity
 *  @param page      the page index of the bar
 *  @param index     the index of the bar in the chart page
 *
 *  @return A UIColor object.
 */
- (UIColor *)chartView:(CHChartView *)chartView colorForBarWithValue:(CGFloat)value inPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for the specified bar's border dash pattern.
 *
 *  @param chartview the chart view requestign the shadow opacity
 *  @param page      the page index of the bar
 *  @param index     the index of the bar in the chart page
 *
 *  @return An array of NSNumber objects that specify the lengths of the painted segments and unpainted segments, 
 *  respectively, of the dash pattern. You may return nil (a solid line).
 */
- (NSArray *)chartView:(CHChartView *)chartView borderDashPatternForBarWithValue:(CGFloat)value inPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for the specified bar's shadow opacity.
 *
 *  @param chartView The chart view requestign the shadow opacity
 *  @param page      The page index of the bar
 *  @param index     The index of the bar in the chart page
 *
 *  @return A value in the range 0.0 (transparent) to 1.0 (opaque)
 */
- (CGFloat)chartView:(CHChartView *)chartView shadowOpacityForBarWithValue:(CGFloat)value inPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for the specified bar's border color.
 *
 *  @param chartView The chart view requestign the shadow opacity
 *  @param page      The page index of the bar
 *  @param index     The index of the bar in the chart page
 *
 *  @return A UIColor object. You may return nil.
 */
- (UIColor *)chartView:(CHChartView *)chartView borderColorForBarWithValue:(CGFloat)value inPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for the specified bar's tint color.
 *  If a tint color is provided, the bar will be drawn with a gradient from its color to its tint color.
 *
 *  @param chartView The chart view requestign the shadow opacity
 *  @param page      The page index of the bar
 *  @param index     The index of the bar in the chart page
 *
 *  @return A UIColor object. You may return nil.
 */
- (UIColor *)chartView:(CHChartView *)chartView tintColorForBarWithValue:(CGFloat)value inPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for the specified bar's border width.
 *
 *  @param chartview the chart view requestign the shadow opacity
 *  @param page      the page index of the bar
 *  @param index     the index of the bar in the chart page
 *
 *  @return A CGFloat value.
 */
- (CGFloat)chartView:(CHChartView *)chartView borderWidthForBarWithValue:(CGFloat)value inPage:(NSInteger)page atIndex:(NSInteger)index;

@end

@interface CHBarChartView : CHChartView

@property (nonatomic, weak) id<CHBarChartDataSource> barChartDataSource;

@end
