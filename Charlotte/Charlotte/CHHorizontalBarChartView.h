//
//  CHHorizontalBarChartView.h
//  Charlotte
//
//  Created by Ben Guo on 2/2/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHHorizontalBarChartView;

@protocol CHHorizontalBarChartViewDataSource <NSObject>

// TODO: documentation
- (NSUInteger)numberOfBarsInHorizontalBarChartView:(CHHorizontalBarChartView *)chartView;

- (CGFloat)horizontalBarChartView:(CHHorizontalBarChartView *)chartView valueOfBarAtIndex:(NSUInteger)index;

/// NOTE: currently, only a min value of 0 is supported
- (CGFloat)maxValueInHorizontalBarChartView:(CHHorizontalBarChartView *)chartView;

- (CGFloat)averageValueInHorizontalBarChartView:(CHHorizontalBarChartView *)chartView;

@optional
// TODO: documentation
- (UIColor *)horizontalBarChartView:(CHHorizontalBarChartView *)chartView colorOfBarAtIndex:(NSUInteger)index;

- (NSString *)horizontalBarChartView:(CHHorizontalBarChartView *)chartView leftLabelTextForBarWithValue:(CGFloat)value
                             atIndex:(NSUInteger)index;

- (NSString *)horizontalBarChartView:(CHHorizontalBarChartView *)chartView rightLabelTextForBarWithValue:(CGFloat)value
                             atIndex:(NSUInteger)index;

@end

@interface CHHorizontalBarChartView : UIView

/// The height of each cell. Each cell contains a bar and its corresponding labels.
@property (nonatomic, assign) CGFloat cellHeight UI_APPEARANCE_SELECTOR;

/// The font used for the left label of each bar
@property (nonatomic, strong) UIFont *leftLabelFont UI_APPEARANCE_SELECTOR;

/// The font used for the right label of each bar
@property (nonatomic, strong) UIFont *rightLabelFont UI_APPEARANCE_SELECTOR;

/// The spacing between adjacent cells
@property (nonatomic, assign) CGFloat lineSpacing UI_APPEARANCE_SELECTOR;

/// The dash pattern for each bar's line
@property (nonatomic, strong) NSArray *lineDashPattern UI_APPEARANCE_SELECTOR;

/// The color of each bar's line
@property (nonatomic, strong) UIColor *lineColor UI_APPEARANCE_SELECTOR;

/// The color of each bar's average tick
@property (nonatomic, strong) UIColor *averageTickColor UI_APPEARANCE_SELECTOR;

/// The color of the average tick when on top of a bar
@property (nonatomic, strong) UIColor *averageTickInverseColor UI_APPEARANCE_SELECTOR;

/// The width of each bar's average tick
@property (nonatomic, assign) CGFloat averageTickWidth UI_APPEARANCE_SELECTOR;

/// The height of each bar
@property (nonatomic, assign) CGFloat barHeight UI_APPEARANCE_SELECTOR;

/// The duration of the reload animation
@property (nonatomic, assign) CGFloat animationDuration UI_APPEARANCE_SELECTOR;

/// The spring damping of the reload animation
@property (nonatomic, assign) CGFloat animationSpringDamping UI_APPEARANCE_SELECTOR;

@property (nonatomic, weak) id<CHHorizontalBarChartViewDataSource> dataSource;

/// Reloads the chart's data. Note that this transition is not animated.
- (void)reloadData;

/**
 *  Reloads the chart's values, updating the currently displayed bars and labels.
 *  Note that this transition is animated, and cannot be used to add or remove bars.
 */
- (void)reloadValues;

@end
