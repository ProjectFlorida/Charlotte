//
//  CHPointCell.m
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHPointCell.h"

@interface CHPointCell ()

@property (nonatomic, readwrite) CGFloat value;
@property (nonatomic, readwrite) CGFloat minValue;
@property (nonatomic, readwrite) CGFloat maxValue;
@property (nonatomic, strong) UILabel *xAxisLabel;
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) NSLayoutConstraint *barViewTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *barViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *barViewHeightConstraint;

@end

@implementation CHPointCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set default values
        _valueLabelString = nil;
        _footerHeight = 30;
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
        _barView.backgroundColor = [UIColor greenColor];
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
        NSLayoutConstraint *xAxisLabelCenterX = [NSLayoutConstraint constraintWithItem:_xAxisLabel
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1
                                                                        constant:0];
        NSLayoutConstraint *barViewCenterX = [NSLayoutConstraint constraintWithItem:_barView
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

        _barViewTopConstraint = [self barViewTopConstraintWithMultiplier:0];
        _barViewWidthConstraint = [NSLayoutConstraint constraintWithItem:_barView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1
                                                                constant:2];
        _barViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_barView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_barView
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1
                                                                 constant:0];
        [self addConstraints:@[xAxisLabelCenterX, barViewCenterX]];
        [self addConstraints:xAxisLabelV];
        [self addConstraints:@[_barViewWidthConstraint, _barViewHeightConstraint, _barViewTopConstraint]];

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.barView.layer.cornerRadius = self.barView.bounds.size.width / 2.0;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.value = 0;
    self.minValue = 0;
    self.maxValue = 1;
    self.footerHeight = 30;
    [self.layer removeAllAnimations];
    [self updateBarAnimated:NO completion:nil];
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

- (CGFloat)relativeValue
{
    return (self.value - self.minValue)/(self.maxValue - self.minValue);
}

- (void)updateBarAnimated:(BOOL)animated completion:(void (^)(void))completion
{

}

#pragma mark - Setters

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
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

@end
