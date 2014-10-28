//
//  CHChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHGridlineView.h"
@import UIKit;

extern CGFloat const kCHPageTransitionAnimationDuration;
extern CGFloat const kCHPageTransitionAnimationSpringDamping;

extern NSString *const CHSupplementaryElementKindHeader;
extern NSString *const CHSupplementaryElementKindFooter;

@class CHChartView;
@protocol CHChartViewDataSource <NSObject>

/**
 *  Asks the data source for the number of points in the specified page.
 *
 *  @param chartView The chart view requesting the number of points
 *  @param page      The index of the page in `chartView`
 *
 *  @return The number of points in the specified page
 */
- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page;

/**
 *  Asks the data source for the value of the specified point.
 *
 *  @param chartView The chart view requesting the value
 *  @param page      The index of the page in `chartView`
 *  @param index     The index of the point in `page`
 *
 *  @return The point's value.
 */
- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for the minimum y value in the specified page.
 *
 *  @param chartView The chart view requesting the min value
 *  @param page      The index of the page in `chartView`
 *
 *  @return The minimum y value in the specified page
 */
- (NSInteger)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page;

/**
 *  Asks the data source for the maximum y value in the specified page.
 *
 *  @param chartView The chart view requesting the max value
 *  @param page      The index of the page in `chartView`
 *
 *  @return The maximum y value in the specified page
 */
- (NSInteger)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page;

// TODO: make this @optional
/**
 *  Asks the data source for the number of pages in the chart view.
 *
 *  @param chartView The chart view requesting the number of pages
 *
 *  @return The number of pages in `chartView`. The default value is 1.
 */
- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView;

// TODO: make this @optional
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

// TODO: make this @optional
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

// TODO: make this @optional
/**
 *  Asks the data source for the number of gridlines in the chart view.
 *
 *  @param chartView The chart view requesting the number of gridlines
 *
 *  @return The total number of gridlines in the chart view
 */
- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView;

// TODO: make this @optional
/**
 *  Asks the data source for the value of the specified gridline
 *
 *  @param chartView The chart view requesting the value of the gridline
 *  @param index     The index of the gridline
 *
 *  @return The value of the gridline
 */
- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index;

@optional
/**
 *  Asks the data source for a view to use as the specified gridline's label.
 *  By default, a gridline will display its value, rounded to the nearest integer.
 *
 *  @param chartView The chart view requesting the label
 *  @param value     The value of the gridline
 *  @param index     The index of the gridline
 *
 *  @return A UIView object.
 */
- (UIView *)chartView:(CHChartView *)chartView labelViewForHorizontalGridlineWithValue:(CGFloat)value atIndex:(NSInteger)index;

/**
 *  Asks the data source for the specified gridline's line dash pattern.
 *  By default, the gridline will display a solid line.
 *
 *  The dash pattern is specified as an array of NSNumber objects that specify the lengths
 *  of the painted segments and unpainted segments, respectively, of the dash pattern.
 *
 *  @param chartView The chart view requesting the line dash pattern
 *  @param index     The index of the gridline
 *
 *  @return An array of NSNumber objects.
 */
- (NSArray *)chartView:(CHChartView *)chartView lineDashPatternForHorizontalGridlineAtIndex:(NSInteger)index;

/**
 *  Asks the data source for the color of the specified gridline's line.
 *
 *  @param chartView The chart view requesting the line color
 *  @param index     The index of the gridline
 *
 *  @return A UIColor object.
 */
- (UIColor *)chartView:(CHChartView *)chartView lineColorForHorizontalGridlineAtIndex:(NSInteger)index;

/**
 *  Asks the data source for the position of the label on the specified gridline.
 *  By default, the label will be positioned at the bottom left corner of the gridline view.
 *
 *  @param chartView The chart view requesting the position
 *  @param index     The index of the gridline
 *
 *  @return A CHViewPosition value.
 */
- (CHViewPosition)chartView:(CHChartView *)chartView labelPositionForHorizontalGridlineAtIndex:(NSInteger)index;

@end

@protocol CHChartViewDelegate <NSObject>

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page;

@end

@interface CHChartView : UIView

@property (nonatomic, weak) id<CHChartViewDataSource> dataSource;
@property (nonatomic, weak) id<CHChartViewDelegate> delegate;

@property (nonatomic, assign, getter=isXAxisLineHidden) BOOL xAxisLineHidden;

- (void)reloadData;
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

@end
