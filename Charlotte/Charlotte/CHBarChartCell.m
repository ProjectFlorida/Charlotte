//
//  CHBarChartCell.m
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHBarChartCell.h"
#import "CHBarChartView.h"

NSString *const CHPointCellReuseId = @"CHPointCell";

@interface CHBarChartCell ()

@property (nonatomic, readwrite) NSNumber *value;
@property (nonatomic, readwrite) CGFloat minValue;
@property (nonatomic, readwrite) CGFloat maxValue;

@property (nonatomic, strong) UIView *barView;

/// A gradient mask is applied to the container view
@property (nonatomic, strong) UIView *barContainerView;

@property (nonatomic, strong) CAGradientLayer *gradientMaskLayer;

@end

@implementation CHBarChartCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set default values
        _footerHeight = 30;
        _value = 0;
        _minValue = 0;
        _maxValue = 1;
        _animationDuration = 0;
        _glowRadius = 0;

        _relativeBarWidth = 0.5;
        _barColor = [UIColor whiteColor];

        _barContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _barView = [[UIView alloc] initWithFrame:CGRectZero];
        _barView.layer.shadowColor = _barColor.CGColor;
        _barView.layer.shadowRadius = _glowRadius;
        _barView.layer.shadowOpacity = 0;
        _barView.layer.shadowOffset = CGSizeZero;
        _barView.backgroundColor = [UIColor clearColor];
        _valueLabelView = [[CHBarValueLabelView alloc] initWithFrame:CGRectZero];
        [_barContainerView addSubview:_barView];

        _gradientMaskLayer = [CAGradientLayer layer];
        _gradientMaskLayer.startPoint = CGPointMake(0.5, 0);
        _gradientMaskLayer.endPoint = CGPointMake(0.5, 1);
        _gradientMaskLayer.locations = @[@0, @(0.15)];
        _gradientMaskLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor];

        _barContainerView.layer.mask = _gradientMaskLayer;
        [self.contentView addSubview:_barContainerView];
        [self.contentView addSubview:_valueLabelView];
    }
    return self;
}

- (CGRect)barViewFrame
{
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat scaledValue = [self scaledValue];
    CGFloat pointViewWidth = width/2.0;
    CGFloat centerY = (1 - scaledValue)*(height - self.footerHeight);
    CGRect frame = CGRectMake(centerX - pointViewWidth/2.0,
                              centerY - pointViewWidth/2.0,
                              pointViewWidth, pointViewWidth);
    CGFloat barWidth = self.relativeBarWidth * self.bounds.size.width;

    // clamp out of range bars so that they're always displayed
    // TODO: add a switch for this behavior
    CGFloat maxY = height - self.footerHeight - barWidth;

    // top of bar should align with value (rather than center of point)
    frame.origin.y += self.bounds.size.width/4.0;
    CGFloat barHeight = MAX(height - self.footerHeight - frame.origin.y, barWidth);

    frame.origin.y = MIN(maxY, frame.origin.y);
    frame.size.height = barHeight;
    frame.size.width = barWidth;
    frame.origin.x = centerX - frame.size.width/2.0;
    return frame;
}

- (CGPoint)valueLabelCenter
{
    CGFloat valueLabelHeight = CGRectGetHeight(self.valueLabelView.bounds);
    CGFloat y = CGRectGetMinY(self.barView.frame) - valueLabelHeight/2.0;
    CGFloat minY = CGRectGetMinY(self.bounds) + valueLabelHeight/2.0;
    y = MAX(y, minY);
    return CGPointMake(self.barView.center.x, y);
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.xAxisLabelView.frame = CGRectMake(0,
                                           CGRectGetHeight(self.bounds) - self.footerHeight,
                                           CGRectGetWidth(self.bounds), self.footerHeight);
    self.barContainerView.frame = self.bounds;
    self.barView.frame = [self barViewFrame];
    self.barView.layer.cornerRadius = self.barView.bounds.size.width / 2.0;

    self.valueLabelView.center = [self valueLabelCenter];

    self.gradientMaskLayer.frame = self.bounds;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.layer removeAllAnimations];
    self.value = 0;
    self.minValue = 0;
    self.maxValue = 1;
    self.footerHeight = 30;
    [self updateAnimated:NO completion:nil];
}

- (CGFloat)scaledValue
{
    CGFloat denominator = (self.maxValue - self.minValue);
    CGFloat value = self.value ? [self.value floatValue] : 0;
    return denominator == 0 ? 0 : (value - self.minValue)/denominator;
}

- (void)performFrameUpdates
{
    self.barView.frame = [self barViewFrame];
    self.valueLabelView.center = [self valueLabelCenter];
}

- (void)updateAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (animated) {
        [UIView animateWithDuration:self.animationDuration delay:0
             usingSpringWithDamping:self.animationSpringDamping
              initialSpringVelocity:0 options:0 animations:^{
                  [self performFrameUpdates];
              } completion:^(BOOL finished) {
                  if (completion) {
                      completion();
                  }
              }];
    }
    else {
        [self performFrameUpdates];
        if (completion) {
            completion();
        }
    }
}

#pragma mark - Setters

- (void)setXAxisLabelViewClass:(Class)xAxisLabelViewClass
{
    _xAxisLabelViewClass = xAxisLabelViewClass;
    if (self.xAxisLabelView) {
        [self.xAxisLabelView removeFromSuperview];
        self.xAxisLabelView = nil;
    }
    self.xAxisLabelView = [[self.xAxisLabelViewClass alloc] init];
    [self addSubview:self.xAxisLabelView];
    [self setNeedsLayout];
}

- (void)setValue:(NSNumber *)value animated:(BOOL)animated completion:(void (^)(void))completion;
{
    self.value = value;
    [self updateAnimated:animated completion:completion];
}

- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue
           animated:(BOOL)animated completion:(void (^)(void))completion
{
    self.minValue = minValue;
    self.maxValue = maxValue;
    [self updateAnimated:animated completion:completion];
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
    [self updateAnimated:NO completion:nil];
    [self setNeedsLayout];
}

- (void)setBarColor:(UIColor *)barColor
{
    _barColor = barColor;
    self.barView.backgroundColor = barColor;
    self.barView.layer.shadowColor = barColor.CGColor;
}

- (void)setGlowRadius:(CGFloat)glowRadius
{
    _glowRadius = glowRadius;
    self.barView.layer.shadowRadius = glowRadius;
}

@end
