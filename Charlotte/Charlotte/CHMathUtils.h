//
//  CHMathUtils.h
//  Charlotte
//
//  Created by Ben Guo on 4/7/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHMathUtils : NSObject

/// Returns the relative value of the given value in the given range.
+ (CGFloat)relativeValue:(CGFloat)value min:(CGFloat)min max:(CGFloat)max;

/// Returns the y position corresponding to the given value
+ (CGFloat)yPositionWithValue:(CGFloat)value min:(CGFloat)min max:(CGFloat)max height:(CGFloat)height;

@end
