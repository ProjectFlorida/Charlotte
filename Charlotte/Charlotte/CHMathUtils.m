//
//  CHMathUtils.m
//  Charlotte
//
//  Created by Ben Guo on 4/7/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import "CHMathUtils.h"

@implementation CHMathUtils

+ (CGFloat)relativeValue:(CGFloat)value min:(CGFloat)min max:(CGFloat)max
{
    CGFloat denominator = max - min;
    return denominator == 0 ? 0 : (value - min)/denominator;
}

+ (CGFloat)yPositionWithValue:(CGFloat)value min:(CGFloat)min max:(CGFloat)max height:(CGFloat)height
{
    CGFloat minToMaxRange = max - min;
    if (minToMaxRange == 0) {
        return 0;
    }
    CGFloat distancePerUnitValue = height/minToMaxRange;
    CGFloat distanceFromZero = (-value) * distancePerUnitValue;
    CGFloat zeroPosition = height - ((0 - min)*distancePerUnitValue);
    return zeroPosition + distanceFromZero;
}

+ (CGFloat)trueMinValueWithMin:(CGFloat)min max:(CGFloat)max height:(CGFloat)height footerHeight:(CGFloat)footerHeight;
{
    CGFloat heightFromMinToMax = height - footerHeight;
    CGFloat minToMaxRange = max - min;
    CGFloat unitPerPixel = minToMaxRange/heightFromMinToMax;
    CGFloat footerHeightInUnits = unitPerPixel*footerHeight;
    return min - footerHeightInUnits;
}

@end
