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

@interface CHLineChartView : CHChartView

/// The chart's cursor animates between points with this duration.
@property (nonatomic, assign) CGFloat cursorMovementAnimationDuration;

/// The chart's cursor appears with this duration.
@property (nonatomic, assign) CGFloat cursorEntranceAnimationDuration;

/// The chart's cursor disappears with this duration.
@property (nonatomic, assign) CGFloat cursorExitAnimationDuration;

/// The width of the cursor
@property (nonatomic, assign) CGFloat cursorWidth UI_APPEARANCE_SELECTOR;

/// The top inset of the cursor
@property (nonatomic, assign) CGFloat cursorTopInset UI_APPEARANCE_SELECTOR;

/// The radius of the cursor dot
@property (nonatomic, assign) CGFloat cursorDotRadius UI_APPEARANCE_SELECTOR;

/// The color of the cursor
@property (nonatomic, strong) UIColor *cursorColor UI_APPEARANCE_SELECTOR;

/// The duration of the line drawing animation.
@property (nonatomic, assign) NSTimeInterval lineDrawingAnimationDuration UI_APPEARANCE_SELECTOR;

/// The width of the line
@property (nonatomic, assign) CGFloat lineWidth UI_APPEARANCE_SELECTOR;

/// The color of the line
@property (nonatomic, strong) UIColor *lineColor UI_APPEARANCE_SELECTOR;

/// The tint color of the line. Default is nil (no tint). Tint color is drawn on the left
@property (nonatomic, strong) UIColor *lineTintColor UI_APPEARANCE_SELECTOR;

/**
 *  A Boolean value that determines whether the chart should display a cursor when touched.
 *  The default value is YES.
 */
@property (nonatomic, assign) BOOL cursorEnabled;

@property (nonatomic, weak) id<CHLineChartViewDelegate> lineChartDelegate;

@end
