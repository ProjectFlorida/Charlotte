//
//  CHRangeChartContentView.h
//  Charlotte
//
//  Created by Ben Guo on 3/31/15.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHGaugePointerView, CHGradientView, CHGaugeChartView;

@interface CHGaugeChartContentView : UIView

/// The pointer view
@property (nonatomic, strong) CHGaugePointerView *pointerView;

/// The gradient band
@property (nonatomic, strong) CHGradientView *gradientView;

/// This view is used to extend the leftmost color further than the true left edge)
@property (nonatomic, strong) UIView *leftGradientBufferView;

/// This view is used to extend the rightmost color further than the true right edge)
@property (nonatomic, strong) UIView *rightGradientBufferView;

/// An array of CHXAxisLabelViews
@property (nonatomic, strong) NSMutableArray *xAxisLabelViews;

/// The value corresponding to the right edge of the view. Default is 0.
@property (nonatomic, assign) CGFloat minValue;

/// The value corresponding to the right edge of the view. Default is 1.
@property (nonatomic, assign) CGFloat maxValue;

/// The value of the pointer's position
@property (nonatomic, assign) CGFloat pointerValue;

/// The height of the gauge's band
@property (nonatomic, assign) CGFloat bandHeight;

/// The content view's parent chart view
@property (nonatomic, weak) CHGaugeChartView *parentView;

/// Updates the pointer value with an animation
- (void)setPointerValueWithTransitionByMovingGradient:(CGFloat)pointerValue;

@end
