//
//  CHIntervalChartView.h
//  Charlotte
//
//  Created by Ben Guo on 1/30/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHInterval.h"

@interface CHIntervalChartView : UIView

/// The spring damping of interval entrance animations
@property (nonatomic, assign) CGFloat animationSpringDamping UI_APPEARANCE_SELECTOR;

/// The duration of interval entrance animations
@property (nonatomic, assign) CGFloat animationDuration UI_APPEARANCE_SELECTOR;

/// The duration of the delay between interval entrance animations
@property (nonatomic, assign) CGFloat animationDelay UI_APPEARANCE_SELECTOR;

/// The stroke width of the axis line
@property (nonatomic, assign) CGFloat axisLineStrokeWidth UI_APPEARANCE_SELECTOR;

/// The color of the axis line
@property (nonatomic, strong) UIColor *axisLineColor UI_APPEARANCE_SELECTOR;

/**
 *  Sets the chart's intervals
 *
 *  @param intervals An array of CHInterval objects
 *  @param max       The chart's maximum displayable value. Note that the chart's min value is always 0.
 *  @param animated  Whether the transition should be animated
 */
- (void)setIntervals:(NSArray *)intervals max:(NSUInteger)max animated:(BOOL)animated;

@end
