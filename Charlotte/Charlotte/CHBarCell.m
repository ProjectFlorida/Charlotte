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

/// the width of the bar view relative to the bar cell's width
@property (nonatomic, assign) CGFloat barViewRelativeWidth;
@property (nonatomic, strong) CAShapeLayer *borderLayer;

@property (nonatomic, strong) NSLayoutConstraint *barViewBottomConstraint;

@end

@implementation CHBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set default values
        _barViewRelativeWidth = 0.5;
        _barColor = [UIColor whiteColor];
        _borderColor = [UIColor whiteColor];
        _tintColor = [UIColor whiteColor];
        _borderWidth = 2;
        _borderDashPattern = @[@2, @2];
        _shadowOpacity = 1;
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.lineWidth = _borderWidth;
        _borderLayer.fillColor = nil;
        _borderLayer.strokeColor = _borderColor.CGColor;
        _borderLayer.lineDashPattern = _borderDashPattern;
        [self.pointView.layer addSublayer:_borderLayer];
        self.pointView.locations = @[@0, @1];
        self.pointView.startPoint = CGPointMake(0.5, 0);
        self.pointView.endPoint = CGPointMake(0.5, 1);
        self.pointView.colors = @[_barColor, _tintColor];
        self.pointView.backgroundColor = [UIColor clearColor];
        self.pointView.layer.shadowRadius = 5;

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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.borderLayer.frame = self.pointView.bounds;
    self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.pointView.bounds
                                                       cornerRadius:self.pointView.bounds.size.width/2.0].CGPath;

}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.barViewBottomConstraint.constant = -self.footerHeight;
}

- (void)updateAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    CGFloat scaledValue = [self scaledValue];

    [self removeConstraint:self.pointViewPositionConstraint];
    // clamp the bar's min height to its width
    CGFloat desiredHeight = (self.bounds.size.height - self.footerHeight)*scaledValue;
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
                                                                               multiplier:(1 - scaledValue)];
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
    }
    else {
        [self layoutIfNeeded];
        if (completion) {
            completion();
        }
    }
}

#pragma mark - Setters

- (void)setBarColor:(UIColor *)barColor
{
    _barColor = barColor;
    self.pointView.colors = @[self.barColor, self.tintColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.borderLayer.strokeColor = borderColor.CGColor;
}

- (void)setTintColor:(UIColor *)tintColor
{
    if (!tintColor) {
        _tintColor = self.barColor;
        self.pointView.colors = @[self.barColor, self.barColor];
    }
    else {
        _tintColor = tintColor;
        self.pointView.colors = @[self.barColor, tintColor];
    }
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

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    _shadowOpacity = shadowOpacity;
    self.pointView.layer.shadowOpacity = shadowOpacity;
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    [super setFooterHeight:footerHeight];
    self.barViewBottomConstraint.constant = -footerHeight;
}

@end
