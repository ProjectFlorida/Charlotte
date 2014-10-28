//
//  CHChartRegion.m
//  Charlotte
//
//  Created by Ben Guo on 10/22/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartRegion.h"

@interface CHChartRegion ()

@property (nonatomic, strong, readwrite) UIColor *color;
@property (nonatomic, strong, readwrite) UIColor *tintColor;

@end

@implementation CHChartRegion

+ (instancetype)regionWithRange:(NSRange)range color:(UIColor *)color tintColor:(UIColor *)tintColor
{
    CHChartRegion *region = [[CHChartRegion alloc] init];
    region.range = range;
    region.color = color;
    region.tintColor = tintColor;
    return region;
}

@end
