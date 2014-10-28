//
//  CHChartRegion.h
//  Charlotte
//
//  Created by Ben Guo on 10/22/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

@import UIKit;

@interface CHChartRegion : NSObject

/**
 *  The region's range.
 *  This range describes a range of point indices in the chart page displaying the region.
 */
@property (nonatomic, assign) NSRange range;

/**
 *  The region's primary color.
 *  If `tintColor` is set, the region will be filled with a gradient from `color` (top) to `tintColor` (bottom).
 */
@property (nonatomic, strong, readonly) UIColor *color;

/**
 *  The region's tint color. If nil, the region will be drawn with a solid color.
 */
@property (nonatomic, strong, readonly) UIColor *tintColor;

/**
 *  Returns a region object configured with the given parameters
 *
 *  @param range     The region's range
 *  @param color     The color of the region
 *  @param tintColor The region's tint color
 *
 *  @return A CHChartRegion object.
 */
+ (instancetype)regionWithRange:(NSRange)range color:(UIColor *)color tintColor:(UIColor *)tintColor;

@end
