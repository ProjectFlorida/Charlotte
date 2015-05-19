//
//  CHMathUtils.h
//  Charlotte
//
//  Created by Ben Guo on 4/7/15.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHMathUtils : NSObject

/// Returns the relative value of the given value in the given range.
+ (CGFloat)relativeValue:(CGFloat)value min:(CGFloat)min max:(CGFloat)max;

/// Returns the y position corresponding to the given value.
+ (CGFloat)yPositionWithValue:(CGFloat)value min:(CGFloat)min max:(CGFloat)max height:(CGFloat)height;

/// Returns the chart's true min value, accounting for the chart's footer.
+ (CGFloat)trueMinValueWithMin:(CGFloat)min max:(CGFloat)max height:(CGFloat)height footerHeight:(CGFloat)footerHeight;

@end
