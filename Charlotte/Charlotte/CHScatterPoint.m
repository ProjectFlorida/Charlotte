//
//  CHScatterPoint.m
//  Charlotte
//
//  Created by Ben Guo on 10/28/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHScatterPoint.h"

@implementation CHScatterPoint

+ (instancetype)pointWithValue:(CGFloat)val relativeXPosition:(CGFloat)x color:(UIColor *)color radius:(CGFloat)radius
{
    CHScatterPoint *point = [[CHScatterPoint alloc] init];
    point.value = val;
    point.relativeXPosition = x;
    point.color = color;
    point.radius = radius;
    return point;
}

@end
