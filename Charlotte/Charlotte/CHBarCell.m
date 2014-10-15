//
//  CHBarCell.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHBarCell.h"
#import "CHChartView.h"
#import "CHPointCell_Private.h"

NSString *const kCHBarCellReuseId = @"BarCell";
CGFloat const kCHZeroValueAnimationDuration = 0.2;

@interface CHBarCell ()

@property (nonatomic, assign) BOOL hasZeroHeight;

/// the width of the bar view relative to the bar cell's width
@property (nonatomic, assign) CGFloat barViewRelativeWidth;

@property (nonatomic, strong) NSLayoutConstraint *barViewBottomConstraint;

@end

@implementation CHBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set default values
        _hasZeroHeight = NO;
        _barViewRelativeWidth = 0.5;
        _primaryBarColor = [UIColor whiteColor];
        _secondaryBarColor = [UIColor grayColor];

        // Change constraints for point view
        [self removeConstraint:self.barViewWidthConstraint];
        [self removeConstraint:self.barViewHeightConstraint];
        self.barViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.barView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:_barViewRelativeWidth
                                                                         constant:0];
        _barViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.barView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:-self.footerHeight];
        [self addConstraints:@[self.barViewWidthConstraint, _barViewBottomConstraint]];

    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.barViewBottomConstraint.constant = -self.footerHeight;
    self.barView.backgroundColor = self.primaryBarColor;
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
        self.barViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.barView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.barView
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

- (void)setFooterHeight:(CGFloat)footerHeight
{
    [super setFooterHeight:footerHeight];
    self.barViewBottomConstraint.constant = -footerHeight;
}


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
