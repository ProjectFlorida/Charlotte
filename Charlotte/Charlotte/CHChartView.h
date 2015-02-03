//
//  CHChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHGridlineView.h"
@import UIKit;

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
 *  @return The point's value as a boxed float. Return nil or NSNull to represent a missing value.
 */
- (NSNumber *)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index;

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
 *  @param chartView The chart view providing the label
 *  @param label     The label to configure
 *  @param page      The point's page index in the chart view
 *  @param index     The point's index in the chart page
 */
- (void)chartView:(CHChartView *)chartView configureLabel:(UILabel *)label forPointInPage:(NSInteger)page
          atIndex:(NSInteger)index;

/**
 *  Asks the data source to configure the label to display on the x-axis below the specified point.
 *  Note: Remember to resize the given label to the desired size after configuring it.
 *
 *  @param chartView The chart view providing the label
 *  @param label     The label to configure
 *  @param page      A page index in the chart view
 *  @param index     A point index in the chart page
 */
- (void)chartView:(CHChartView *)chartView configureXAxisLabel:(UILabel *)label forPointInPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source for a view to use as the specified gridline's left label.
 *  By default, a gridline will have a left label displaying its value rounded to the nearest integer.
 *
 *  @param chartView The chart view requesting the label view
 *  @param value     The value of the gridline
 *  @param index     The index of the gridline
 *
 *  @return A UIView object.
 */
- (UIView *)chartView:(CHChartView *)chartView leftLabelViewForHorizontalGridlineWithValue:(CGFloat)value atIndex:(NSInteger)index;

/**
 *  Asks the data source for a view to use as the specified gridline's lower left label.
 *  Default is no label. Use this method to add subtitles to gridlines.
 *
 *  @param chartView The chart view requesting the label view
 *  @param value     The value of the gridline
 *  @param index     The index of the gridline
 *
 *  @return A UIView object.
 */
- (UIView *)chartView:(CHChartView *)chartView lowerLeftLabelViewForHorizontalGridlineWithValue:(CGFloat)value atIndex:(NSInteger)index;

/**
 *  Asks the data source for a view to use as the specified gridline's right label. Default is no label.
 *
 *  @param chartView The chart view requesting the label view
 *  @param value     The value of the gridline
 *  @param index     The index of the gridline
 *
 *  @return A UIView object.
 */
- (UIView *)chartView:(CHChartView *)chartView rightLabelViewForHorizontalGridlineWithValue:(CGFloat)value atIndex:(NSInteger)index;

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
 *  Asks the data source for the inset of the specified gridline's line.
 *
 *  @param chartView The chart view requesting the line inset
 *  @param index     The index of the gridline
 *
 *  @return A UIEdgeInsets value. Only left and right insets are honored.
 */
- (UIEdgeInsets)chartView:(CHChartView *)chartView lineInsetForHorizontalGridlineAtIndex:(NSInteger)index;

@end

@protocol CHChartViewDelegate <NSObject>

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page;

@end

@interface CHChartView : UIView

@property (nonatomic, weak) id<CHChartViewDataSource> dataSource;
@property (nonatomic, weak) id<CHChartViewDelegate> delegate;

/// The chart's header height
@property (nonatomic, assign) CGFloat headerHeight UI_APPEARANCE_SELECTOR;

/// The chart's footer height
@property (nonatomic, assign) CGFloat footerHeight UI_APPEARANCE_SELECTOR;

/// The chart's page inset. This refers to the spacing between a page's edges and the view's bounds.
@property (nonatomic, assign) UIEdgeInsets pageInset UI_APPEARANCE_SELECTOR;

/// The chart's section inset. This refers to the spacing at the outer edges of the section.
@property (nonatomic, assign) UIEdgeInsets sectionInset UI_APPEARANCE_SELECTOR;

/// When chart elements page into view, their alpha values will transition from this value to 1.0.
@property (nonatomic, assign) CGFloat pagingAlpha UI_APPEARANCE_SELECTOR;

/// The view used as the chart's y-axis label
@property (nonatomic, strong) UIView *yAxisLabelView;

/// The duration of the page transition animation
@property (nonatomic, assign) CGFloat pageTransitionAnimationDuration UI_APPEARANCE_SELECTOR;

/// The spring damping of the page transition animation
@property (nonatomic, assign) CGFloat pageTransitionAnimationSpringDamping UI_APPEARANCE_SELECTOR;

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
