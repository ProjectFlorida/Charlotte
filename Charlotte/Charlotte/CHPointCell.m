//
//  CHPointCell.m
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHPointCell.h"
#import "CHChartView.h"

NSString *const kCHPointCellReuseId = @"CHPointCell";

@interface CHPointCell ()

@property (nonatomic, readwrite) NSNumber *value;
@property (nonatomic, readwrite) CGFloat minValue;
@property (nonatomic, readwrite) CGFloat maxValue;
@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UIView *pointContainerView;

@end

@implementation CHPointCell

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

        _pointContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _xAxisLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _pointView = [[UIView alloc] initWithFrame:CGRectZero];
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];

        [_pointContainerView addSubview:_pointView];
        [self addSubview:_pointContainerView];
        [self addSubview:_xAxisLabel];
        [self addSubview:_valueLabel];
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
    return CGRectMake(centerX - pointViewWidth/2.0,
                      centerY - pointViewWidth/2.0,
                      pointViewWidth, pointViewWidth);
}

- (CGPoint)valueLabelCenter
{
    CGFloat valueLabelHeight = CGRectGetHeight(self.valueLabel.frame);
    CGFloat y = CGRectGetMinY(self.pointView.frame) - valueLabelHeight/2.0 - self.layoutMargins.bottom/2.0;
    return CGPointMake(self.pointView.center.x, y);
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat height = self.bounds.size.height;
    CGFloat centerX = CGRectGetMidX(self.bounds);

    self.xAxisLabel.center = CGPointMake(centerX,
                                         height - self.footerHeight/2.0);

    self.pointContainerView.frame = self.bounds;
    self.pointView.frame = [self pointViewFrame];
    self.pointView.layer.cornerRadius = self.pointView.bounds.size.width / 2.0;

    self.valueLabel.center = [self valueLabelCenter];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.layer removeAllAnimations];
    self.value = 0;
    self.minValue = 0;
    self.maxValue = 1;
    self.footerHeight = 30;
    self.xAxisLabel.text = @"";
    [self.xAxisLabel sizeToFit];
    [self updateAnimated:NO completion:nil];
}

- (CGFloat)scaledValue
{
    CGFloat value = self.value ? [self.value floatValue] : 0;
    return (value - self.minValue)/(self.maxValue - self.minValue);
}

- (void)reload
{
    self.pointView.frame = [self pointViewFrame];
    self.valueLabel.center = [self valueLabelCenter];
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
}

@end
