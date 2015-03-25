//
//  CHPointCell.m
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHBarChartCell.h"
#import "CHChartView.h"

NSString *const CHPointCellReuseId = @"CHPointCell";

@interface CHBarChartCell ()

@property (nonatomic, readwrite) NSNumber *value;
@property (nonatomic, readwrite) CGFloat minValue;
@property (nonatomic, readwrite) CGFloat maxValue;
@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UIView *pointContainerView;
@property (nonatomic, strong) CAShapeLayer *borderLayer;
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

        _relativeBarWidth = 0.5;
        _barColor = [UIColor whiteColor];
        _borderColor = [UIColor whiteColor];
        _borderWidth = 2;
        _borderDashPattern = @[@2, @2];

        _pointContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _pointView = [[UIView alloc] initWithFrame:CGRectZero];
        _pointView.backgroundColor = [UIColor clearColor];
        _valueLabelView = [[CHBarValueLabelView alloc] initWithFrame:CGRectZero];
        [_pointContainerView addSubview:_pointView];

        _borderLayer = [CAShapeLayer layer];
        _borderLayer.lineWidth = _borderWidth;
        _borderLayer.fillColor = nil;
        _borderLayer.strokeColor = _borderColor.CGColor;
        _borderLayer.lineDashPattern = _borderDashPattern;
        [_pointView.layer addSublayer:_borderLayer];

        _gradientMaskLayer = [CAGradientLayer layer];
        _gradientMaskLayer.startPoint = CGPointMake(0.5, 0);
        _gradientMaskLayer.endPoint = CGPointMake(0.5, 1);
        _gradientMaskLayer.locations = @[@0, @(0.15)];
        _gradientMaskLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor];

        _pointContainerView.layer.mask = _gradientMaskLayer;
        [self.contentView addSubview:_pointContainerView];
        [self.contentView addSubview:_valueLabelView];
    }
    return self;
}

- (CGRect)pointViewFrame
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
    CGFloat y = CGRectGetMinY(self.pointView.frame) - valueLabelHeight/2.0;
    CGFloat minY = CGRectGetMinY(self.bounds) + valueLabelHeight/2.0;
    y = MAX(y, minY);
    return CGPointMake(self.pointView.center.x, y);
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.xAxisLabelView.frame = CGRectMake(0,
                                           CGRectGetHeight(self.bounds) - self.footerHeight,
                                           CGRectGetWidth(self.bounds), self.footerHeight);
    self.pointContainerView.frame = self.bounds;
    self.pointView.frame = [self pointViewFrame];
    self.pointView.layer.cornerRadius = self.pointView.bounds.size.width / 2.0;

    self.valueLabelView.center = [self valueLabelCenter];

    self.gradientMaskLayer.frame = self.bounds;
    if (!CGRectEqualToRect(self.borderLayer.frame, self.pointView.bounds)) {
        self.borderLayer.frame = self.pointView.bounds;
        self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.pointView.bounds
                                                           cornerRadius:self.pointView.bounds.size.width/2.0].CGPath;
    }
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

- (void)reload
{
    self.pointView.frame = [self pointViewFrame];
    self.valueLabelView.center = [self valueLabelCenter];
    self.borderLayer.frame = self.pointView.bounds;
    self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.pointView.bounds
                                                       cornerRadius:self.pointView.bounds.size.width/2.0].CGPath;
}

- (void)updateAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (animated) {
        [UIView animateWithDuration:self.animationDuration delay:0
             usingSpringWithDamping:self.animationSpringDamping
              initialSpringVelocity:0 options:0 animations:^{
                  [self reload];
              } completion:^(BOOL finished) {
                  if (completion) {
                      completion();
                  }
              }];
    }
    else {
        [self reload];
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
    self.pointView.backgroundColor = self.barColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.borderLayer.strokeColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.borderLayer.lineWidth = borderWidth;
}

- (void)setBorderDashPattern:(NSArray *)borderDashPattern
{
    _borderDashPattern = borderDashPattern;
    self.borderLayer.lineDashPattern = borderDashPattern;
}

@end
