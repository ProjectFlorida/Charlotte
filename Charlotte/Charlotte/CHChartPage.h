//
//  CHChartPage.h
//  Charlotte
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

@import UIKit;

@interface CHChartPage : NSObject

/// The chart page's minimum value.
@property (nonatomic, assign) CGFloat minValue;

/// The chart page's maximum value.
@property (nonatomic, assign) CGFloat maxValue;

/**
 * The chart page's values. Set this property to an array of CHChartPageValue objects.
 * The order of objects in this array corresponds to the left-to-right order of points
 * in this chart page.
 */
@property (nonatomic, strong) NSArray *values;

@end
