//
//  CHBarCell.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHBarCell.h"
#import "CHChartView.h"

NSString *const kCHBarCellReuseId = @"BarCell";
CGFloat const kCHZeroValueAnimationDuration = 0.2;

@interface CHBarCell ()

@property (nonatomic, readwrite) CGFloat value;
@property (nonatomic, readwrite) CGFloat minValue;
@property (nonatomic, readwrite) CGFloat maxValue;
@property (nonatomic, strong) UILabel *xAxisLabel;
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) NSLayoutConstraint *barViewTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *barViewBottomConstraint;
@property (nonatomic, assign) BOOL hasZeroHeight;

/// the width of the bar view relative to the bar cell's width
@property (nonatomic, assign) CGFloat barViewRelativeWidth;

@end

@implementation CHBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set default values
        _hasZeroHeight = NO;
        _valueLabelString = nil;
        _footerHeight = 30;
        _barViewRelativeWidth = 0.5;
        _primaryBarColor = [UIColor whiteColor];
        _secondaryBarColor = [UIColor grayColor];
        _xAxisLabelColor = [UIColor whiteColor];
        _valueLabelColor = [UIColor whiteColor];
        _xAxisLabelFont = [UIFont systemFontOfSize:14];
        _valueLabelFont = [UIFont systemFontOfSize:14];
        _value = 0;
        _minValue = 0;
        _maxValue = 1;

        // Initialize views
        _xAxisLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _xAxisLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _xAxisLabel.textColor = _xAxisLabelColor;
        _xAxisLabel.font = _xAxisLabelFont;
        _barView = [[UIView alloc] initWithFrame:CGRectZero];
        _barView.backgroundColor = _primaryBarColor;
        _barView.translatesAutoresizingMaskIntoConstraints = NO;
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _valueLabel.textColor = _valueLabelColor;
        _valueLabel.font = _valueLabelFont;
        _valueLabel.text = @"foo";
        [_valueLabel sizeToFit];

        // Add constraints for bar view and x-axis label
        [self addSubview:_xAxisLabel];
        [self addSubview:_barView];
        NSLayoutConstraint *xAxisLabelX = [NSLayoutConstraint constraintWithItem:_xAxisLabel
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1
                                                                        constant:0];
        NSLayoutConstraint *barViewX = [NSLayoutConstraint constraintWithItem:_barView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1
                                                                     constant:0];
        _barViewTopConstraint = [self barViewTopConstraintWithMultiplier:0];
        NSLayoutConstraint *barViewWidth = [NSLayoutConstraint constraintWithItem:_barView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:_barViewRelativeWidth
                                                                         constant:0];
        NSArray *xAxisLabelV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:@{@"label": _xAxisLabel}];
        _barViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_barView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:-_footerHeight];
        [self addConstraints:@[xAxisLabelX, barViewX, barViewWidth, _barViewTopConstraint, _barViewBottomConstraint]];
        [self addConstraints:xAxisLabelV];

        // Add constraints for value label
        [_barView addSubview:_valueLabel];
        NSLayoutConstraint *valueLabelX = [NSLayoutConstraint constraintWithItem:_valueLabel
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_barView
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1
                                                                        constant:0];
        NSLayoutConstraint *valueLabelY = [NSLayoutConstraint constraintWithItem:_valueLabel
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_barView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1
                                                                        constant:-4];
        [_barView addConstraints:@[valueLabelX, valueLabelY]];

    }
    return self;
}

- (NSLayoutConstraint *)barViewTopConstraintWithMultiplier:(CGFloat)multiplier
{
    return [NSLayoutConstraint constraintWithItem:_barView
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:multiplier
                                         constant:-self.footerHeight];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _barView.layer.cornerRadius = _barView.bounds.size.width / 2.0;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.value = 0;
    self.minValue = 0;
    self.maxValue = 1;
    self.footerHeight = 30;
    self.barViewBottomConstraint.constant = -self.footerHeight;
    self.barView.backgroundColor = self.primaryBarColor;
    [self.layer removeAllAnimations];
    [self updateBarAnimated:NO completion:nil];
}

/// Returns the bar's value relative to its min and max value
- (CGFloat)relativeValue
{
    return (self.value - self.minValue)/(self.maxValue - self.minValue);
}

- (void)updateBarAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    CGFloat relativeValue = [self relativeValue];

    void (^finalUpdateBlock)() = ^() {
        if (relativeValue == 0) {
            self.barView.backgroundColor = _secondaryBarColor;
            self.valueLabel.alpha = 0;
            self.hasZeroHeight = YES;
        }
        else {
            self.barView.backgroundColor = _primaryBarColor;
            self.valueLabel.alpha = 1;
            self.hasZeroHeight = NO;
        }
    };

    [self removeConstraint:self.barViewTopConstraint];
    // clamp the bar's min height to its width
    CGFloat desiredHeight = (self.bounds.size.height - self.footerHeight)*relativeValue;
    CGFloat barWidth = self.bounds.size.width * self.barViewRelativeWidth;
    if (desiredHeight < barWidth) {
        self.barViewTopConstraint = [NSLayoutConstraint constraintWithItem:_barView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_barView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1
                                                                  constant:0];
    }
    else {
        self.barViewTopConstraint = [self barViewTopConstraintWithMultiplier:(1 - relativeValue)];
    }
    [self addConstraint:self.barViewTopConstraint];
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
        [UIView animateWithDuration:kCHZeroValueAnimationDuration delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                finalUpdateBlock();
                            } completion:nil];
    }
    else {
        [self layoutIfNeeded];
        finalUpdateBlock();
        if (completion) {
            completion();
        }
    }
}

#pragma mark - Setters

- (void)setValue:(CGFloat)value animated:(BOOL)animated completion:(void (^)(void))completion;
{
    self.value = value;
    if (!self.valueLabelString) {
        self.valueLabel.text = [NSString stringWithFormat:@"%d", (int)round(value)];
    }
    [self updateBarAnimated:animated completion:completion];
}

- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue
           animated:(BOOL)animated completion:(void (^)(void))completion
{
    self.minValue = minValue;
    self.maxValue = maxValue;
    [self updateBarAnimated:animated completion:completion];
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
    self.barViewBottomConstraint.constant = -footerHeight;
    [self updateBarAnimated:NO completion:nil];
}

- (void)setValueLabelFont:(UIFont *)valueLabelFont
{
    _valueLabelFont = valueLabelFont;
    self.valueLabel.font = valueLabelFont;
    [self.valueLabel sizeToFit];
}

- (void)setValueLabelString:(NSString *)valueLabelString
{
    _valueLabelString = valueLabelString;
    self.valueLabel.text = valueLabelString;
    [self.valueLabel sizeToFit];
}

- (void)setXAxisLabelFont:(UIFont *)xAxisLabelFont
{
    _xAxisLabelFont = xAxisLabelFont;
    self.xAxisLabel.font = xAxisLabelFont;
    [self.xAxisLabel sizeToFit];
}

- (void)setXAxisLabelString:(NSString *)xAxisLabelString
{
    _xAxisLabelString = xAxisLabelString;
    self.xAxisLabel.text = xAxisLabelString;
    [self.xAxisLabel sizeToFit];
}

- (void)setPrimaryBarColor:(UIColor *)barColor
{
    _primaryBarColor = barColor;
    if (!self.hasZeroHeight) {
        self.barView.backgroundColor = barColor;
    }
}

- (void)setSecondaryBarColor:(UIColor *)barColor
{
    _secondaryBarColor = barColor;
    if (self.hasZeroHeight) {
        self.barView.backgroundColor = barColor;
    }
}

@end
