//
//  CHChartRegion.m
//  Charlotte
//
//  Created by Ben Guo on 10/22/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartRegion.h"

@implementation CHChartRegion

+ (instancetype)chartRegionWithRange:(NSRange)range color:(UIColor *)color
{
    CHChartRegion *region = [[CHChartRegion alloc] init];
    region.range = range;
    region.color = color;
    return region;
}

@end
