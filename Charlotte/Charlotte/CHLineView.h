//
//  CHLineView.h
//  Charlotte
//
//  Created by Ben Guo on 10/16/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHScatterPoint.h"
#import "CHInteractivePoint.h"

@interface CHLineView : UIView

/// The line view's minimum displayable value
@property (nonatomic, readonly) CGFloat minValue;

/// The line view's maximum displayable value
@property (nonatomic, readonly) CGFloat maxValue;

/// The line view's footer height (set this to the chart view's footer height)
@property (nonatomic, assign) CGFloat footerHeight;

/// The line view's interactive point
@property (nonatomic, strong) CHInteractivePoint *interactivePoint;

/// The line's color
@property (nonatomic, strong) UIColor *lineColor;

/// The line's gradient colors (ordered from bottom to top)
@property (nonatomic, strong) NSArray *gradientColors;

/// The y-values of the line's gradient stops. Note that behavior is undefined for y values outside the line's range.
@property (nonatomic, strong) NSArray *gradientLocations;

/// The line's gradient locations

/// The line's width in points. Default is 4.0.
@property (nonatomic, assign) CGFloat lineWidth;

/// The duration of the line drawing animation.
@property (nonatomic, assign) NSTimeInterval lineDrawingAnimationDuration UI_APPEARANCE_SELECTOR;

/**
 *  Draws a line between the given values
 *
 *  @param values       An array of y-values describing the line.
 *  @param animated     Whether the drawing should be animated.
 */
- (void)drawLineWithValues:(NSArray *)values animated:(BOOL)animated;

/**
 *  Draws the given points
 *
 *  @param points       An array of CHScatterPoint objects
 *  @param animated     Whether the drawing should be animated.
 */
- (void)drawScatterPoints:(NSArray *)points animated:(BOOL)animated;

/**
 *  Draws the given interactive point
 *
 *  @param point        A CHInteractivePoint object
 *  @param animated     Whether the drawing should be animated.
 */
- (void)drawInteractivePoint:(CHInteractivePoint *)point animated:(BOOL)animated;

/**
 *  Sets the line view's min and max value.
 *
 *  @param minValue   The desired min value
 *  @param maxValue   The desired max value
 *  @param animated   Whether the transition should be animated
 *  @param completion A block object to be executed when the transition ends.
 */
- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue animated:(BOOL)animated completion:(void (^)(void))completion;

@end
