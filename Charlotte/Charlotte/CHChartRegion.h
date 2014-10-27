//
//  CHChartRegion.h
//  Charlotte
//
//  Created by Ben Guo on 10/22/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

@import UIKit;

@interface CHChartRegion : NSObject

@property (nonatomic, assign) NSRange range;

/**
 *  The region's primary color.
 *  If `tintColor` is set, the region will be filled with a gradient from `color` (top) to `tintColor` (bottom).
 */
@property (nonatomic, strong, readonly) UIColor *color;

/// The region's tint color. If nil, the region will be drawn with a solid color.
@property (nonatomic, strong, readonly) UIColor *tintColor;

+ (instancetype)chartRegionWithRange:(NSRange)range color:(UIColor *)color tintColor:(UIColor *)tintColor;

@end
