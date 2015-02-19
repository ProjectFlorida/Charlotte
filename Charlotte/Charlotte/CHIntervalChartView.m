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
@property (nonatomic, assign) NSUInteger max;

@end

@implementation CHIntervalChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _intervalViews = @[];
        _animationDuration = 0.4;
        _animationDelay = 0.1;
        _animationSpringDamping = 0.7;
        _max = 0;
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

    for (CHIntervalView *view in self.intervalViews) {
        CGFloat relativeX = view.interval.range.location/(CGFloat)self.max;
        CGFloat relativeWidth = view.interval.range.length/(CGFloat)self.max;
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
        CGFloat relativeX = interval.range.location/(CGFloat)self.max;
        CGFloat relativeWidth = interval.range.length/(CGFloat)self.max;
        CHIntervalView *view = [[CHIntervalView alloc] initWithFrame:CGRectZero];
        view.interval = interval;
        view.backgroundColor = interval.color;
        view.frame = CGRectMake(relativeX*width, 0, relativeWidth*width, 0);
        view.layer.anchorPoint = CGPointMake(0, 1);
        view.transform = CGAffineTransformMakeScale(1, 0);
        self.intervalViews = [self.intervalViews arrayByAddingObject:view];
        [self addSubview:view];
    }

    if (animated) {
        CGFloat delay = 0;
        for (CHIntervalView *view in self.intervalViews) {
            [UIView animateWithDuration:self.animationDuration delay:delay
                 usingSpringWithDamping:self.animationSpringDamping initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn animations:^{
                                    view.transform = CGAffineTransformIdentity;
                                } completion:nil];
            delay += self.animationDelay;
        }
    }
    else {
        for (CHIntervalView *view in self.intervalViews) {
            view.transform = CGAffineTransformIdentity;
        }
    }
}

@end
