//
//  CHChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

@import UIKit;

extern CGFloat const kCHPageTransitionAnimationDuration;
extern CGFloat const kCHPageTransitionAnimationSpringDamping;

extern NSString *const CHSupplementaryElementKindHeader;

@class CHChartView;
@protocol CHChartViewDataSource <NSObject>

- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView;

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page;

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for a label to display above the specified point.
 *
 *  @param chartView The chart view requesting the label
 *  @param value     The point's value
 *  @param page      A page index in the chart view
 *  @param index     A point index in the chart page
 *
 *  @return A UILabel object that the chart view can use to configure the specified label. You may return nil.
 */
- (UILabel *)chartView:(CHChartView *)chartView labelForPointWithValue:(CGFloat)value inPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for a label to display on the x-axis below the specified point.
 *
 *  @param chartView The chart view requesting the label
 *  @param page      A page index in the chart view
 *  @param index     A point index in the chart page
 *
 *  @return A UILabel object that the chart view can use to configure the specified x-axis label. You may return nil.
 */
- (UILabel *)chartView:(CHChartView *)chartView xAxisLabelForPointInPage:(NSInteger)page atIndex:(NSInteger)index;

- (NSInteger)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page;

- (NSInteger)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page;

/// The total number of distinct horizontal gridlines that may be displayed
- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView;

- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index;

@optional

/**
 *  Asks the data source for a label to display on the specified gridline.
 *
 *  @param chartView The chart view requesting the label
 *  @param index     The index of the gridline
 *
 *  @return A UILabel object.
 */
- (UILabel *)chartView:(CHChartView *)chartView labelForHorizontalGridlineAtIndex:(NSInteger)index;

@end

@protocol CHChartViewDelegate <NSObject>

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page;

@end

@interface CHChartView : UIView

@property (nonatomic, weak) id<CHChartViewDataSource> dataSource;
@property (nonatomic, weak) id<CHChartViewDelegate> delegate;

- (void)reloadData;
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

@end
