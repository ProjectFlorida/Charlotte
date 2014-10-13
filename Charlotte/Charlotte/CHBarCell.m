//
//  CHBarCell.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHBarCell.h"

NSString *const kCHBarCellReuseId = @"BarCell";

@interface CHBarCell ()

@property (nonatomic, readwrite) CGFloat value;
@property (nonatomic, readwrite) CGFloat minValue;
@property (nonatomic, readwrite) CGFloat maxValue;
@property (nonatomic, strong) UILabel *xAxisLabel;
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) NSLayoutConstraint *barViewTopConstraint;

/// the width of the bar view relative to the bar cell's width
@property (nonatomic, assign) CGFloat barViewRelativeWidth;

@end

@implementation CHBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set default values
        _barViewRelativeWidth = 0.5;
        _barColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _darkBarColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        _xAxisLabelColor = [UIColor whiteColor];
        _valueLabelColor = [UIColor whiteColor];
        _value = 0;
        _minValue = 0;
        _maxValue = 1;

        // Initialize views
        _xAxisLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _xAxisLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _xAxisLabel.textColor = _xAxisLabelColor;
        _barView = [[UIView alloc] initWithFrame:CGRectZero];
        _barView.backgroundColor = _barColor;
        _barView.translatesAutoresizingMaskIntoConstraints = NO;
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _valueLabel.textColor = _valueLabelColor;
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
        NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_barView][_xAxisLabel]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(_barView, _xAxisLabel)];
        [self addConstraints:@[xAxisLabelX, barViewX, _barViewTopConstraint, barViewWidth]];
        [self addConstraints:constraintsV];

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
                                                                        constant:0];
        [_barView addConstraints:@[valueLabelX, valueLabelY]];

    }
    return self;
}

- (NSLayoutConstraint *)barViewTopConstraintWithMultiplier:(CGFloat)multiplier
{
    return [NSLayoutConstraint constraintWithItem:_barView
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:_xAxisLabel
                                        attribute:NSLayoutAttributeTop
                                       multiplier:multiplier
                                         constant:0];
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
}

- (void)updateConstraints
{
    [super updateConstraints];
}

/// Returns the bar's value relative to its min and max value
- (CGFloat)relativeValue
{
    return (self.value - self.minValue)/(self.maxValue - self.minValue);
}

// TODO: animation option
- (void)updateBar
{
    CGFloat relativeValue = [self relativeValue];
    if (relativeValue == 0) {
        self.barView.backgroundColor = _darkBarColor;
        self.valueLabel.hidden = YES;
    }
    else {
        self.barView.backgroundColor = _barColor;
        self.valueLabel.hidden = NO;
    }

    [self removeConstraint:self.barViewTopConstraint];
    // clamp the bar's min height to its width
    CGFloat desiredHeight = (self.bounds.size.height - self.xAxisLabel.bounds.size.height)*relativeValue;
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
        CGFloat multiplier = 1 - relativeValue;
        self.barViewTopConstraint = [self barViewTopConstraintWithMultiplier:multiplier];
    }
    [self addConstraint:self.barViewTopConstraint];
    [self setNeedsUpdateConstraints];
}

#pragma mark - Setters

- (void)setValue:(CGFloat)value animated:(BOOL)animated
{
    self.value = value;
    if (!self.valueLabelString) {
        self.valueLabel.text = [NSString stringWithFormat:@"%d", (int)round(value)];
    }
    [self updateBar];
}

- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue animated:(BOOL)animated
{
    self.minValue = minValue;
    self.maxValue = maxValue;
    [self updateBar];
}

- (void)setValueLabelString:(NSString *)valueLabelString
{
    _valueLabelString = valueLabelString;
    self.valueLabel.text = valueLabelString;
    [self.valueLabel sizeToFit];
}

- (void)setXAxisLabelString:(NSString *)xAxisLabelString
{
    _xAxisLabelString = xAxisLabelString;
    self.xAxisLabel.text = xAxisLabelString;
    [self.xAxisLabel sizeToFit];
}

- (void)setBarColor:(UIColor *)barColor
{
    _barColor = barColor;
    self.barView.backgroundColor = barColor;
}


@end
