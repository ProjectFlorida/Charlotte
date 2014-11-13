//
//  CHLineChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartView.h"

extern NSString *const CHSupplementaryElementKindLine;

@class CHLineChartView;

@protocol CHLineChartViewDelegate <NSObject>
@optional

/**
 *  Tells the delegate that the chart view's cursor appeared
 *
 *  @param chartView The chart view containing the cursor
 *  @param page      The page of the point under the cursor
 *  @param index     The index of the point under the cursor
 *  @param value     The value of the point under the cursor
 *  @param position  The position of point under the cursor
 */
- (void)chartView:(CHLineChartView *)chartView cursorAppearedInPage:(NSInteger)page atIndex:(NSInteger)index value:(CGFloat)value position:(CGPoint)position;

/**
 *  Tells the delegate that the chart view's cursor moved
 *
 *  @param chartView The chart view containing the cursor
 *  @param page      The page of the point under the cursor
 *  @param index     The index of the point under the cursor
 *  @param value     The value of the point under the cursor
 *  @param position  The position of point under the cursor
 */
- (void)chartView:(CHLineChartView *)chartView cursorMovedInPage:(NSInteger)page toIndex:(NSInteger)index value:(CGFloat)value position:(CGPoint)position;

/**
 *  Tells the delegate that the chart view's cursor disappeared
 *
 *  @param chartView The chart view containing the cursor
 *  @param page      The page of the point under the cursor
 *  @param index     The index of the point under the cursor
 *  @param value     The value of the point under the cursor
 *  @param position  The position of point under the cursor
 */
- (void)chartView:(CHLineChartView *)chartView cursorDisappearedInPage:(NSInteger)page atIndex:(NSInteger)index value:(CGFloat)value position:(CGPoint)position;

@end

@protocol CHLineChartViewDataSource <NSObject>
@optional

/**
 *  Asks the data source for an array of CHChartRegion objects describing colored regions to draw below the line.
 *
 *  @param chartView The chart view requesting the regions.
 *  @param page      The page on which the regions should be drawn.
 *
 *  @return An array of CHChartRegion objects.
 */
- (NSArray *)chartView:(CHLineChartView *)chartView regionsInPage:(NSInteger)page;

/**
 *  Asks the data source for the width of the line in the specified page.
 *
 *  @param chartView The chart view requesting the line width
 *  @param page      The line's page index
 *
 *  @return A UIColor object.
 */
- (CGFloat)chartView:(CHLineChartView *)chartView lineWidthInPage:(NSInteger)page;

/**
 *  Asks the data source for the color of the line in the specified page.
 *
 *  @param chartView The chart view requesting the line color
 *  @param page      The line's page index
 *
 *  @return A UIColor object.
 */
- (UIColor *)chartView:(CHLineChartView *)chartView lineColorInPage:(NSInteger)page;

/**
 *  Asks the data source for the tint color of the line in the specified page.
 *  If a tint color is provided, a gradient will be drawn from the line's tint color (left) to the line's color (right).
 *
 *  @param chartView The chart view requesting the line color
 *  @param page      The line's page index
 *
 *  @return A UIColor object.
 */
- (UIColor *)chartView:(CHLineChartView *)chartView lineTintColorInPage:(NSInteger)page;

/**
 *  Asks the data source for the left line inset in the specified page.
 *  The chart's line will be dimmed on the left up to this index.
 *
 *  @param chartView The chart view requesting the line inset.
 *  @param page      The line's page index
 *
 *  @return An index specifying the right edge of the line's left inset.
 */
- (NSInteger)chartView:(CHLineChartView *)chartView leftLineInsetInPage:(NSInteger)page;

/**
 *  Asks the data source for the right line inset in the specified page.
 *  The chart's line will be dimmed on the left up to this index.
 *
 *  @param chartView The chart view requesting the line inset.
 *  @param page      The line's page index
 *
 *  @return An index specifying the right edge of the line's left inset.
 */
- (NSInteger)chartView:(CHLineChartView *)chartView rightLineInsetInPage:(NSInteger)page;

@end

@interface CHLineChartView : CHChartView

/// The chart's cursor animates between points with this duration.
@property (nonatomic, assign) CGFloat cursorMovementAnimationDuration;

/// The chart's cursor appears with this duration.
@property (nonatomic, assign) CGFloat cursorEntranceAnimationDuration;

/// The chart's cursor disappears with this duration.
@property (nonatomic, assign) CGFloat cursorExitAnimationDuration;

/// The line's insets will be drawn using the line's color with this alpha component.
@property (nonatomic, assign) CGFloat lineInsetAlpha UI_APPEARANCE_SELECTOR;

/// The width of the cursor column
@property (nonatomic, assign) CGFloat cursorColumnWidth UI_APPEARANCE_SELECTOR;

/// The color of the cursor column
@property (nonatomic, strong) UIColor *cursorColumnColor UI_APPEARANCE_SELECTOR;

/** 
 *  The tint color of the cursor column.
 *  If a tint color is provided, a gradient will be drawn from the column color (top) to the tint color (bottom)
 */
@property (nonatomic, strong) UIColor *cursorColumnTintColor UI_APPEARANCE_SELECTOR;

/// The radius of the cursor point
@property (nonatomic, assign) CGFloat cursorPointRadius UI_APPEARANCE_SELECTOR;

/**
 *  A Boolean value that determines whether the chart should display a cursor when touched.
 *  The default value is YES.
 */
@property (nonatomic, assign) BOOL cursorEnabled;

@property (nonatomic, weak) id<CHLineChartViewDelegate> lineChartDelegate;
@property (nonatomic, weak) id<CHLineChartViewDataSource> lineChartDataSource;

@end
