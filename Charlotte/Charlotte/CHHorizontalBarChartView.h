//
//  CHHorizontalBarChartView.h
//  Charlotte
//
//  Created by Ben Guo on 2/2/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHHorizontalBarChartView, CHHorizontalBarCell;

@protocol CHHorizontalBarChartViewDataSource <NSObject>

// TODO: documentation
- (NSUInteger)numberOfBarsInHorizontalBarChartView:(CHHorizontalBarChartView *)chartView;

- (CGFloat)horizontalBarChartView:(CHHorizontalBarChartView *)chartView valueOfBarAtIndex:(NSUInteger)index;

/// NOTE: currently, only a min value of 0 is supported
- (CGFloat)maxValueInHorizontalBarChartView:(CHHorizontalBarChartView *)chartView;

- (void)horizontalBarChartView:(CHHorizontalBarChartView *)chartView configureBar:(CHHorizontalBarCell *)barCell
                     withValue:(CGFloat)value atIndex:(NSUInteger)index;

@end

@interface CHHorizontalBarChartView : UIView

/// The height of each cell. Each cell contains a bar and its corresponding labels.
@property (nonatomic, assign) CGFloat cellHeight UI_APPEARANCE_SELECTOR;

/// The spacing between adjacent cells
@property (nonatomic, assign) CGFloat lineSpacing UI_APPEARANCE_SELECTOR;

@property (nonatomic, weak) id<CHHorizontalBarChartViewDataSource> dataSource;

/// Reloads the chart's data. Note that this transition is not animated.
- (void)reloadData;

/**
 *  Reloads the chart's values, updating the currently displayed bars and labels.
 *  Note that this transition is animated, and cannot be used to add or remove bars.
 */
- (void)reloadValues;

@end
