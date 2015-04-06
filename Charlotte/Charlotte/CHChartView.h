//
//  CHChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHGridlineView.h"
@import UIKit;

@class CHChartView, CHBarChartCell;
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
- (NSInteger)numberOfGridlinesInChartView:(CHChartView *)chartView;

/**
 *  Asks the data source for the value of the specified gridline
 *
 *  @param chartView The chart view requesting the value of the gridline
 *  @param index     The index of the gridline
 *
 *  @return The value of the gridline
 */
- (CGFloat)chartView:(CHChartView *)chartView valueForGridlineAtIndex:(NSInteger)index;

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
 *  Asks the data source to configure the cell at the given index
 *
 *  @param chartView The chart view providing the label
 *  @param cell      The cell to configure
 *  @param page      The point's page index in the chart view
 *  @param index     The point's index in the chart page
 */
- (void)chartView:(CHChartView *)chartView configureCell:(CHBarChartCell *)cell forPointInPage:(NSInteger)page
          atIndex:(NSInteger)index;

/**
 *  Asks the data source to configure the label view to display on the x-axis below the specified point.
 *
 *  @param chartView The chart view providing the label view
 *  @param view      The view to configure. 
 *                   Unless you register your own xAxisLabelViewClass, this view will be a CHXAxisLabelView.
 *  @param page      A page index in the chart view
 *  @param index     A point index in the chart page
 */
- (void)chartView:(CHChartView *)chartView configureXAxisLabelView:(UIView *)view
   forPointInPage:(NSInteger)page atIndex:(NSInteger)index;

/**
 *  Asks the data source to configure the gridline view at the given index
 *
 *  @param chartView    The chart view providing the gridline view
 *  @param gridlineView The gridline view to configure
 *  @param value        The value of the gridline
 *  @param index        The index of the gridline
 */
- (void)chartView:(CHChartView *)chartView configureGridlineView:(CHGridlineView *)gridlineView
        withValue:(CGFloat)value atIndex:(NSInteger)index;

@end

@protocol CHChartViewDelegate <NSObject>

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page;

@end

@interface CHChartView : UIView

@property (nonatomic, weak) id<CHChartViewDataSource> dataSource;
@property (nonatomic, weak) id<CHChartViewDelegate> delegate;

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

/// The duration with which the bar's glow should fade in.
/// Note that by default, bars will not glow. See CHBarChartViewCell for glow configuration options.
@property (nonatomic, assign) CGFloat glowAppearanceAnimationDuration UI_APPEARANCE_SELECTOR;

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

/**
 *  Registers the class for use in creating x-axis label views. CHXAxisLabelView is registered by default.
 *
 *  @param class The UIView subclass to use for creating x axis label views
 */
- (void)registerXAxisLabelViewClass:(Class)class;

@end
