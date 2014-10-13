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

@property (nonatomic, strong) UILabel *xAxisLabel;
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) NSLayoutConstraint *barViewTopConstraint;

@end

@implementation CHBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set default values
        _barColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
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
                                                                       multiplier:0.5
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
                                                                        constant:1];
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
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [super updateConstraints];
    CGFloat relativeValue = (self.value - self.minValue)/(self.maxValue - self.minValue);
    CGFloat multiplier = 1 - relativeValue;
    [self removeConstraint:self.barViewTopConstraint];
    self.barViewTopConstraint = [self barViewTopConstraintWithMultiplier:multiplier];
    [self addConstraint:self.barViewTopConstraint];
    [self layoutIfNeeded];
}

#pragma mark - Custom setters

- (void)setValue:(CGFloat)value
{
    _value = value;
    [self setNeedsUpdateConstraints];
}

- (void)setMinValue:(CGFloat)minValue
{
    _minValue = minValue;
    [self setNeedsUpdateConstraints];
}

- (void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    [self setNeedsUpdateConstraints];
}

- (void)setXAxisLabelString:(NSString *)text
{
    self.xAxisLabel.text = text;
    [self.xAxisLabel sizeToFit];
}

- (void)setBarColor:(UIColor *)barColor
{
    _barColor = barColor;
    self.barView.backgroundColor = barColor;
}


@end
