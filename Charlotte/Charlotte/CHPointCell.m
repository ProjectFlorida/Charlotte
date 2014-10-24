//
//  CHPointCell.m
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHPointCell.h"
#import "CHChartView.h"
#import "CHGradientView.h"

NSString *const kCHPointCellReuseId = @"CHPointCell";

@interface CHPointCell ()

@property (nonatomic, readwrite) CGFloat value;
@property (nonatomic, readwrite) CGFloat minValue;
@property (nonatomic, readwrite) CGFloat maxValue;
@property (nonatomic, strong) UILabel *xAxisLabel;
@property (nonatomic, strong) CHGradientView *pointView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) NSLayoutConstraint *pointViewPositionConstraint;
@property (nonatomic, strong) NSLayoutConstraint *pointViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *pointViewHeightConstraint;

@end

@implementation CHPointCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set default values
        _footerHeight = 30;
        _pointColor = [UIColor whiteColor];
        _value = 0;
        _minValue = 0;
        _maxValue = 1;

        // Initialize views
        _xAxisLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _xAxisLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _pointView = [[CHGradientView alloc] initWithFrame:CGRectZero];
        _pointView.backgroundColor = _pointColor;
        _pointView.translatesAutoresizingMaskIntoConstraints = NO;
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_valueLabel sizeToFit];

        // Add constraints for bar view and x-axis label
        [self addSubview:_xAxisLabel];
        [self addSubview:_pointView];
        NSLayoutConstraint *xAxisLabelCenterX = [NSLayoutConstraint constraintWithItem:_xAxisLabel
                                                                             attribute:NSLayoutAttributeCenterX
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1
                                                                              constant:0];
        NSLayoutConstraint *barViewCenterX = [NSLayoutConstraint constraintWithItem:_pointView
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1
                                                                           constant:0];
        NSArray *xAxisLabelV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:@{@"label": _xAxisLabel}];

        _pointViewPositionConstraint = [self pointViewPositionConstraintWithAttribute:NSLayoutAttributeCenterY
                                                                           multiplier:0];
        _pointViewWidthConstraint = [NSLayoutConstraint constraintWithItem:_pointView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:2];
        _pointViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_pointView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_pointView
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1
                                                                   constant:0];
        [self addConstraints:@[xAxisLabelCenterX, barViewCenterX]];
        [self addConstraints:xAxisLabelV];
        [self addConstraints:@[_pointViewWidthConstraint, _pointViewHeightConstraint, _pointViewPositionConstraint]];

        // Add constraints for value label
        [self addSubview:_valueLabel];
        NSLayoutConstraint *valueLabelX = [NSLayoutConstraint constraintWithItem:_valueLabel
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_pointView
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1
                                                                        constant:0];
        NSLayoutConstraint *valueLabelY = [NSLayoutConstraint constraintWithItem:_valueLabel
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_pointView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1
                                                                        constant:-4];
        [self addConstraints:@[valueLabelX, valueLabelY]];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.pointView.layer.cornerRadius = self.pointView.bounds.size.width / 2.0;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.value = 0;
    self.minValue = 0;
    self.maxValue = 1;
    self.footerHeight = 30;
    [self.layer removeAllAnimations];
    [self updateAnimated:NO completion:nil];
}

- (NSLayoutConstraint *)pointViewPositionConstraintWithAttribute:(NSLayoutAttribute)attribute
                                                      multiplier:(CGFloat)multiplier
{
    return [NSLayoutConstraint constraintWithItem:_pointView
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:multiplier
                                         constant:-self.footerHeight];
}

- (CGFloat)scaledValue
{
    return (self.value - self.minValue)/(self.maxValue - self.minValue);
}

- (void)updateAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    CGFloat scaledValue = [self scaledValue];
    [self removeConstraint:self.pointViewPositionConstraint];
    self.pointViewPositionConstraint = [self pointViewPositionConstraintWithAttribute:NSLayoutAttributeCenterY
                                                                           multiplier:(1 - scaledValue)];
    [self addConstraint:self.pointViewPositionConstraint];
    [self setNeedsUpdateConstraints];
    if (animated) {
        [UIView animateWithDuration:kCHPageTransitionAnimationDuration delay:0
             usingSpringWithDamping:kCHPageTransitionAnimationSpringDamping
              initialSpringVelocity:0 options:0 animations:^{
                  [self layoutIfNeeded];
              } completion:^(BOOL finished) {
                  if (completion) {
                      completion();
                  }
              }];
    }
    else {
        if (completion) {
            completion();
        }
    }
}

#pragma mark - Setters

- (void)setValue:(CGFloat)value animated:(BOOL)animated completion:(void (^)(void))completion;
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

- (void)setPointColor:(UIColor *)pointColor
{
    _pointColor = pointColor;
    self.pointView.backgroundColor = pointColor;
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
    [self updateAnimated:NO completion:nil];
}

@end
