//
//  CHRangeChartContentView.m
//  Charlotte
//
//  Created by Ben Guo on 3/31/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import "CHGaugeChartContentView.h"
#import "CHXAxisLabelView.h"
#import "CHGradientView.h"
#import "CHGaugePointerView.h"
#import "UIView+Charlotte.h"
#import "CHGaugeChartView.h"

@interface CHGaugeChartContentView ()

@end

@implementation CHGaugeChartContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _minValue = 0;
        _pointerValue = 0;
        _maxValue = 1;
        _bandHeight = 100;
        _xAxisLabelViews = [NSMutableArray array];

        _gradientView = [[CHGradientView alloc] initWithFrame:CGRectZero];
        _gradientView.colors = @[[UIColor redColor], [UIColor blueColor], [UIColor redColor]];
        _gradientView.locations = @[@0, @0.5, @1];
        _gradientView.startPoint = CGPointMake(0, 0.5);
        _gradientView.endPoint = CGPointMake(1, 0.5);
        _pointerView = [[CHGaugePointerView alloc] initWithFrame:CGRectZero];
        _pointerView.clipsToBounds = NO;
        _leftGradientBufferView = [[UIView alloc] initWithFrame:CGRectZero];
        _rightGradientBufferView = [[UIView alloc] initWithFrame:CGRectZero];

        self.clipsToBounds = NO;
        [self addSubview:_gradientView];
        [self addSubview:_leftGradientBufferView];
        [self addSubview:_rightGradientBufferView];
        [self addSubview:_pointerView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGFloat height = CGRectGetHeight(bounds);
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat range = fabs(self.maxValue - self.minValue);
    CGFloat bufferWidth = width;
    self.gradientView.frame = CGRectMake(0, height - self.bandHeight, width, self.bandHeight);
    self.leftGradientBufferView.frame = CGRectMake(CGRectGetMinX(self.gradientView.frame) - bufferWidth,
                                                   CGRectGetMinY(self.gradientView.frame),
                                                   bufferWidth + 10, CGRectGetHeight(self.gradientView.frame));
    self.rightGradientBufferView.frame = CGRectMake(CGRectGetMaxX(self.gradientView.frame) - 10,
                                                    CGRectGetMinY(self.gradientView.frame),
                                                    bufferWidth, CGRectGetHeight(self.gradientView.frame));

    for (CHXAxisLabelView *xAxisLabelView in self.xAxisLabelViews) {
        CGFloat ratio = (xAxisLabelView.value - self.minValue)/range;
        CGFloat labelHeight = CGRectGetHeight(xAxisLabelView.bounds);
        xAxisLabelView.center = CGPointMake(width*ratio,
                                            height - (labelHeight/2.0));
    }

    CGFloat pointerXRatio = (self.pointerValue - self.minValue)/range;
    self.pointerView.frame = CGRectMake(width*pointerXRatio - 5, 0, 10,
                                        CGRectGetMidY(self.gradientView.frame));
    [self askDataSourceToConfigurePointerWithFrame:self.pointerView.frame];
}

- (void)askDataSourceToConfigurePointerWithFrame:(CGRect)pointerFrame
{
    CGPoint needlePositionPoint = CGPointMake(CGRectGetMidX(pointerFrame), 1);
    UIColor *color = [self.gradientView ch_colorAtPoint:needlePositionPoint];

    // configure pointer
    if ([self.parentView.dataSource respondsToSelector:@selector(chartView:configurePointerView:withValue:colorUnderPointer:)]) {
        [self.parentView.dataSource chartView:self.parentView configurePointerView:self.pointerView
                                    withValue:self.pointerValue colorUnderPointer:color];
    }
}

- (void)setPointerValueWithTransitionByMovingGradient:(CGFloat)pointerValue
{
    // get current range
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat range = fabs(self.maxValue - self.minValue);
    CGFloat delta = (pointerValue - self.pointerValue)/range;
    CGFloat deltaX = delta*width;
    CGRect targetPointerFrame = CGRectOffset(self.pointerView.frame, deltaX, 0);
    [UIView animateWithDuration:self.parentView.animationDuration
                          delay:0
         usingSpringWithDamping:self.parentView.animationSpringDamping
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.frame = CGRectOffset(self.frame, -deltaX, 0);
                         self.pointerView.frame = targetPointerFrame;
                     } completion:nil];

    // update pointer value and visible min/max
    self.pointerValue = pointerValue;
    self.parentView.minVisibleValue = self.parentView.minVisibleValue + delta;
    self.parentView.maxVisibleValue = self.parentView.maxVisibleValue + delta;
    [self askDataSourceToConfigurePointerWithFrame:targetPointerFrame];
}

@end
