//
//  CHLineView.h
//  Charlotte
//
//  Created by Ben Guo on 10/16/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHScatterPoint.h"
#import "CHInteractivePoint.h"

extern NSString *const kCHLineViewReuseId;

@interface CHLineView : UICollectionReusableView

/// The line view's minimum displayable value
@property (nonatomic, readonly) CGFloat minValue;

/// The line view's maximum displayable value
@property (nonatomic, readonly) CGFloat maxValue;

/// The line view's footer height (set this to the chart view's footer height)
@property (nonatomic, assign) CGFloat footerHeight;

/// The line view's interactive point
@property (nonatomic, strong) CHInteractivePoint *interactivePoint;

/// The line's primary color (drawn on the right).
@property (nonatomic, strong) UIColor *lineColor;

/// The line's tint color (drawn on the left). Set this to nil for no tint.
@property (nonatomic, strong) UIColor *lineTintColor;

/// The line's width in points. Default is 4.0.
@property (nonatomic, assign) CGFloat lineWidth;

/// The alpha component of the line's inset (applied to lineColor).
@property (nonatomic, assign) CGFloat lineInsetAlpha;

/**
 *  Draws a line between the given values, with colored regions below the line specified by the given array.
 *
 *  @param values       An array of y-values describing the line.
 *  @param regions      An array of CHChartRegion objects.
 *  @param leftInset    The line will be dimmed on the left up to this index.
 *  @param rightInset   The line will be dimmed on the right beginning at the index.
 */
- (void)drawLineWithValues:(NSArray *)values regions:(NSArray *)regions leftInset:(NSInteger)leftInset rightInset:(NSInteger)rightInset;

/**
 *  Draws the given points
 *
 *  @param points An array of CHScatterPoint objects
 */
- (void)drawScatterPoints:(NSArray *)points;

/**
 *  Draws the given interactive point
 *
 *  @param point A CHInteractivePoint object
 */
- (void)drawInteractivePoint:(CHInteractivePoint *)point;

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
