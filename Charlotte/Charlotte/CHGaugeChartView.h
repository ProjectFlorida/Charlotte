//
//  CHGaugeChartView.h
//  Charlotte
//
//  Created by Ben Guo on 3/30/15.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHGaugeChartView, CHXAxisLabelView, CHLabel, CHGaugePointerView;
@protocol CHGaugeChartViewDataSource <NSObject>

/// Asks the data source for the minimum value of the chart view. Default is 0.
- (CGFloat)minValueInChartView:(CHGaugeChartView *)chartView;

/// Asks the data source for the maximum value of the chart view.
- (CGFloat)maxValueInChartView:(CHGaugeChartView *)chartView;

/// Asks the data source for the number of ranges
- (NSUInteger)numberOfRangesInChartView:(CHGaugeChartView *)chartView;

/// Asks the data source for the upper bound of the specified range.
/// This must be a monotonically increasing function of index.
- (CGFloat)chartView:(CHGaugeChartView *)chartView upperBoundOfRangeAtIndex:(NSUInteger)index;

/// Asks the data source for the color of the specified range
- (UIColor *)chartView:(CHGaugeChartView *)chartView colorOfRangeAtIndex:(NSUInteger)index;

/// Asks the data source for the number of x axis labels to display
- (NSUInteger)numberOfXAxisLabelsInChartView:(CHGaugeChartView *)chartView;

/// Asks the data source to configure the given x axis label view
- (void)chartView:(CHGaugeChartView *)chartView configureXAxisLabelView:(CHXAxisLabelView *)labelView
          atIndex:(NSUInteger)index withValue:(CGFloat)value;

/// Asks the data source for the value of the gauge's pointer
- (CGFloat)valueOfPointerInChartView:(CHGaugeChartView *)chartView;

/// Asks the data source to configure the gauge's pointer view
- (void)chartView:(CHGaugeChartView *)chartView configurePointerView:(CHGaugePointerView *)pointerView
        withValue:(CGFloat)value colorUnderPointer:(UIColor *)color;

/// Asks the data source for the value of the specified x axis label
- (CGFloat)chartView:(CHGaugeChartView *)chartView valueOfXAxisLabelAtIndex:(NSUInteger)index;

@end

@interface CHGaugeChartView : UIView

@property (nonatomic, weak) id<CHGaugeChartViewDataSource> dataSource;

/// The height of the gauge's band
@property (nonatomic, assign) CGFloat bandHeight UI_APPEARANCE_SELECTOR;

/// The duration used for all animations
@property (nonatomic, assign) CGFloat animationDuration UI_APPEARANCE_SELECTOR;

/// The spring damping used for all animations
@property (nonatomic, assign) CGFloat animationSpringDamping UI_APPEARANCE_SELECTOR;

/// The value of the minimum visible value
@property (nonatomic, assign) CGFloat minVisibleValue;

/// The value of the maximum visible value
@property (nonatomic, assign) CGFloat maxVisibleValue;

/// Animates the chart to display the range specified by the given min and length
- (void)animateToVisibleRangeWithMin:(CGFloat)min length:(CGFloat)length;

/// Animates the chart to display the range described by the given center and width
- (void)animateToVisibleRangeWithCenter:(CGFloat)center width:(CGFloat)width;

/// Reloads the chart (not animated)
- (void)reload;

/// Reloads only the value of the pointer (animated)
- (void)reloadPointerValue;

@end
