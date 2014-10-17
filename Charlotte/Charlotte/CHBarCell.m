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

NSString *const kCHBarCellReuseId = @"CHBarCell";
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
        [self removeConstraint:self.pointViewWidthConstraint];
        [self removeConstraint:self.pointViewHeightConstraint];
        self.pointViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.pointView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:_barViewRelativeWidth
                                                                      constant:0];
        _barViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.pointView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:-self.footerHeight];
        [self addConstraints:@[self.pointViewWidthConstraint, _barViewBottomConstraint]];

    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.barViewBottomConstraint.constant = -self.footerHeight;
    self.pointView.backgroundColor = self.primaryBarColor;
}

- (void)updateAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    CGFloat relativeValue = [self relativeValue];

    void (^finalUpdateBlock)() = ^() {
        if (relativeValue == 0) {
            self.pointView.backgroundColor = _secondaryBarColor;
            self.valueLabel.alpha = 0;
            self.hasZeroHeight = YES;
        }
        else {
            self.pointView.backgroundColor = _primaryBarColor;
            self.valueLabel.alpha = 1;
            self.hasZeroHeight = NO;
        }
    };

    [self removeConstraint:self.pointViewPositionConstraint];
    // clamp the bar's min height to its width
    CGFloat desiredHeight = (self.bounds.size.height - self.footerHeight)*relativeValue;
    CGFloat barWidth = self.bounds.size.width * self.barViewRelativeWidth;
    if (desiredHeight < barWidth) {
        self.pointViewPositionConstraint = [NSLayoutConstraint constraintWithItem:self.pointView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.pointView
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1
                                                                         constant:0];
    }
    else {
        self.pointViewPositionConstraint = [self pointViewPositionConstraintWithAttribute:NSLayoutAttributeTop
                                                                               multiplier:(1 - relativeValue)];
    }
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

- (void)setPrimaryBarColor:(UIColor *)barColor
{
    _primaryBarColor = barColor;
    if (!self.hasZeroHeight) {
        self.pointView.backgroundColor = barColor;
    }
}

- (void)setSecondaryBarColor:(UIColor *)barColor
{
    _secondaryBarColor = barColor;
    if (self.hasZeroHeight) {
        self.pointView.backgroundColor = barColor;
    }
}

@end
