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
- (CGFloat)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page;

/**
 *  Asks the data source for the maximum y value in the specified page.
 *
 *  @param chartView The chart view requesting the max value
 *  @param page      The index of the page in `chartView`
 *
 *  @return The maximum y value in the specified page
 */
- (CGFloat)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page;

/**
 *  Asks the data source for the number of gridlines in the chart view.
 *
 *  @param chartView The chart view requesting the number of gridlines
 *
 *  @return The total number of gridlines in the chart view
 */
- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView;

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
 *  Asks the data source for the number of pages in the chart view.
 *
 *  @param chartView The chart view requesting the number of pages
 *
 *  @return The number of pages in `chartView`. The default value is 1.
 */
- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView;

/**
 *  Asks the data source to configure the label displayed above the specified point.
 *  Note: Remember to resize the given label to the desired size after configuring it.
 *
 *  @param label     The label to configure
 *  @param value     The point's value
 *  @param page      The point's page index in the chart view
 *  @param index     The point's index in the chart page
 *  @param chartView The chart view providing the label
 */
- (void)configureLabel:(UILabel *)label forPointWithValue:(CGFloat)value inPage:(NSInteger)page atIndex:(NSInteger)index inChartView:(CHChartView *)chartView;

/**
 *  Asks the data source to configure the label to display on the x-axis below the specified point.
 *  Note: Remember to resize the given label to the desired size after configuring it.
 *
 *  @param label     The label to configure
 *  @param page      A page index in the chart view
 *  @param index     A point index in the chart page
 *  @param chartView The chart view providing the label
 */
- (void)configureXAxisLabel:(UILabel *)label forPointInPage:(NSInteger)page atIndex:(NSInteger)index inChartView:(CHChartView *)chartView;

/**
 *  Asks the data source for a view to use as the specified gridline's label.
 *  By default, a gridline will display its value, rounded to the nearest integer.
 *
 *  @param chartView The chart view requesting the label view
 *  @param value     The value of the gridline
 *  @param index     The index of the gridline
 *
 *  @return A UIView object.
 */
- (UIView *)chartView:(CHChartView *)chartView labelViewForHorizontalGridlineWithValue:(CGFloat)value atIndex:(NSInteger)index;

/**
 *  Asks the data source for a view to use as the chart's y-axis label. 
 *  Note: This view will be displayed in the chart's header. Remember to adjust the chart's headerHeight accordingly.
 *
 *  @param chartView The chart view requesting the label view
 *
 *  @return A UIView object.
 */
- (UIView *)labelViewForYAxisInChartView:(CHChartView *)chartView;

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
 *  Asks the data source for the width of the specified gridline's line.
 *
 *  @param chartView The chart view requesting the line color
 *  @param index     The index of the gridline
 *
 *  @return A float value indicating the width of the line in points.
 */
- (CGFloat)chartView:(CHChartView *)chartView lineWidthForHorizontalGridlineAtIndex:(NSInteger)index;

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

/// Whether or not the chart's x axis is hidden
@property (nonatomic, assign, getter=isXAxisLineHidden) BOOL xAxisLineHidden UI_APPEARANCE_SELECTOR;

/// The chart's header height
@property (nonatomic, assign) CGFloat headerHeight UI_APPEARANCE_SELECTOR;

/// The chart's footer height
@property (nonatomic, assign) CGFloat footerHeight UI_APPEARANCE_SELECTOR;

/// The chart's page inset. This refers to the spacing between a page's edges and the view's bounds.
@property (nonatomic, assign) UIEdgeInsets pageInset UI_APPEARANCE_SELECTOR;

/// The chart's section inset. This refers to the spacing at the outer edges of the section.
@property (nonatomic, assign) UIEdgeInsets sectionInset UI_APPEARANCE_SELECTOR;

/// The width of the chart's x axis
@property (nonatomic, assign) CGFloat xAxisLineWidth UI_APPEARANCE_SELECTOR;

/// The color of the chart's x axis
@property (nonatomic, strong) UIColor *xAxisLineColor UI_APPEARANCE_SELECTOR;

/// When chart elements page into view, their alpha values will transition from this value to 1.0.
@property (nonatomic, assign) CGFloat pagingAlpha UI_APPEARANCE_SELECTOR;

/**
 *  A Boolean value indicating whether value labels should be hidden on pages that aren't the current page.
 *  Default is YES.
 */
@property (nonatomic, assign) BOOL hidesValueLabelsOnNonCurrentPages;

/// The chart's current page.
@property (assign, nonatomic) NSInteger currentPage;

/**
 *  Reloads the chart view.
 */
- (void)reloadData;

/**
 *  Scrolls to the specified page
 *
 *  @param page                     The index of the desired page
 *  @param animateScrolling         YES if the scrolling should be animated, NO if it should be immediate.
 *  @param animateRange             YES if the range transition should be animated, NO if it should be immediate.
 */
- (void)scrollToPage:(NSInteger)page animateScrolling:(BOOL)animateScrolling animateRangeTransition:(BOOL)animateRange;

@end
