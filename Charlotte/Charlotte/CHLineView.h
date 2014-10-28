//
//  CHLineView.h
//  Charlotte
//
//  Created by Ben Guo on 10/16/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHScatterPoint.h"

extern NSString *const kCHLineViewReuseId;

@interface CHLineView : UICollectionReusableView

@property (nonatomic, readonly) CGFloat minValue;
@property (nonatomic, readonly) CGFloat maxValue;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, strong) UIColor *chartBackgroundColor;

/**
 *  Draws a line between the given values, with colored regions below the line specified by the given array.
 *
 *  @param regions An array of CHChartRegion objects.
 */
- (void)drawLineWithValues:(NSArray *)values regions:(NSArray *)regions;

/**
 *  Draws the given points
 *
 *  @param points An array of CHScatterPoint objects
 */
- (void)drawScatterPoints:(NSArray *)points;

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
