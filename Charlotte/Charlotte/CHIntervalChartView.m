//
//  CHIntervalChartView.m
//  Charlotte
//
//  Created by Ben Guo on 1/30/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import "CHIntervalChartView.h"
#import "CHIntervalView.h"

NSString *const CHIntervalChartCellId = @"CHIntervalChartCell";

@interface CHIntervalChartView ()

@property (nonatomic, strong) NSArray *intervalViews;
@property (nonatomic, strong) UIView *axisLineView;
@property (nonatomic, assign) NSUInteger max;

@end

@implementation CHIntervalChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _intervalViews = @[];
        _animationDuration = 0.3;
        _animationDelay = 0.1;
        _animationSpringDamping = 0.7;
        _max = 0;
        _axisLineStrokeWidth = 1;
        _axisLineColor = [UIColor lightGrayColor];
        _axisLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _axisLineView.alpha = 0;
        _axisLineView.backgroundColor = _axisLineColor;
        [self addSubview:_axisLineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGFloat height = CGRectGetHeight(bounds);
    CGFloat width = CGRectGetWidth(bounds);
    if (self.max == 0) {
        return;
    }

    self.axisLineView.frame = CGRectMake(0, ceilf(CGRectGetMidY(bounds) - self.axisLineStrokeWidth/2.0),
                                         CGRectGetWidth(bounds), ceilf(self.axisLineStrokeWidth));
    for (CHIntervalView *view in self.intervalViews) {
        CGFloat relativeX = self.max == 0 ? 0 : view.interval.range.location/(CGFloat)self.max;
        CGFloat relativeWidth = self.max == 0 ? 0 :view.interval.range.length/(CGFloat)self.max;
        view.frame = CGRectMake(relativeX*width, CGRectGetMinY(self.bounds), relativeWidth*width, height);
    }
}

- (void)setIntervals:(NSArray *)intervals max:(NSUInteger)max animated:(BOOL)animated
{
    self.max = max;
    self.intervalViews = @[];
    CGRect bounds = self.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    NSArray *sortedIntervals = [intervals sortedArrayUsingComparator:^NSComparisonResult(CHInterval *i1, CHInterval *i2) {
        return i1.range.location > i2.range.location;
    }];
    for (CHInterval *interval in sortedIntervals) {
        CGFloat relativeX = self.max == 0 ? 0 : interval.range.location/(CGFloat)self.max;
        CGFloat relativeWidth = self.max == 0 ? 0 : interval.range.length/(CGFloat)self.max;
        CHIntervalView *view = [[CHIntervalView alloc] initWithFrame:CGRectZero];
        view.interval = interval;
        view.backgroundColor = interval.color;
        view.frame = CGRectMake(relativeX*width, 0, relativeWidth*width, 0);
        view.layer.anchorPoint = CGPointMake(0, 1);
        view.transform = CGAffineTransformMakeScale(1, 0);
        self.intervalViews = [self.intervalViews arrayByAddingObject:view];
        [self addSubview:view];
    }

    self.axisLineView.alpha = 0;
    if (animated) {
        CGFloat delay = 0;
        NSUInteger count = [self.intervalViews count];
        for (int i=0; i < count; i++) {
            CHIntervalView *view = self.intervalViews[i];
            [UIView animateWithDuration:self.animationDuration delay:delay
                 usingSpringWithDamping:self.animationSpringDamping initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn animations:^{
                                    view.transform = CGAffineTransformIdentity;
                                } completion:^(BOOL finished) {
                                    if (i == count - 1) {
                                        [UIView animateWithDuration:self.animationDuration
                                                              delay:0
                                                            options:UIViewAnimationOptionCurveEaseIn
                                                         animations:^{
                                                             self.axisLineView.alpha = 1;
                                        } completion:nil];
                                    }
                                }];
            delay += self.animationDelay;
        }
    }
    else {
        for (CHIntervalView *view in self.intervalViews) {
            view.transform = CGAffineTransformIdentity;
        }
        self.axisLineView.alpha = 1;
    }
}

#pragma mark - Setters

- (void)setAxisLineColor:(UIColor *)axisLineColor
{
    _axisLineColor = axisLineColor;
    self.axisLineView.backgroundColor = axisLineColor;
}

- (void)setAxisLineStrokeWidth:(CGFloat)axisLineStrokeWidth
{
    if (_axisLineStrokeWidth == axisLineStrokeWidth) {
        return;
    }
    _axisLineStrokeWidth = axisLineStrokeWidth;
    [self setNeedsLayout];
}

@end
