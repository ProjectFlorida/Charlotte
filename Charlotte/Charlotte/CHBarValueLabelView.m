//
//  CHBarValueLabelView.m
//  Charlotte
//
//  Created by Ben Guo on 3/20/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import "CHBarValueLabelView.h"

@interface CHBarValueLabelView ()

@property (nonatomic, strong) UILabel *upperLabel;
@property (nonatomic, strong) UILabel *lowerLabel;

@end

@implementation CHBarValueLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _spacingAboveUpperLabel = 2;
        _spacingBelowUpperLabel = 5;
        _spacingBelowLowerLabel = 0;
        _upperLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _upperLabel.textAlignment = NSTextAlignmentCenter;
        _lowerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _lowerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_upperLabel];
        [self addSubview:_lowerLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat maxWidth = MAX(CGRectGetWidth(self.upperLabel.frame), CGRectGetWidth(self.lowerLabel.frame));
    self.upperLabel.frame = CGRectMake(0, self.spacingAboveUpperLabel,
                                       maxWidth,
                                       CGRectGetHeight(self.upperLabel.frame));
    self.lowerLabel.center = CGPointMake(CGRectGetMidX(self.upperLabel.frame),
                                         CGRectGetMaxY(self.upperLabel.frame) + self.spacingBelowUpperLabel);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [self layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.lowerLabel.frame) + self.spacingBelowLowerLabel;
    CGFloat maxWidth = MAX(CGRectGetWidth(self.upperLabel.frame), CGRectGetWidth(self.lowerLabel.frame));
    return CGSizeMake(maxWidth, height);
}

#pragma mark - Setters

- (void)setSpacingAboveUpperLabel:(CGFloat)spacingAboveUpperLabel
{
    _spacingAboveUpperLabel = spacingAboveUpperLabel;
    [self setNeedsLayout];
}

- (void)setSpacingBelowLowerLabel:(CGFloat)spacingBelowLowerLabel
{
    _spacingBelowLowerLabel = spacingBelowLowerLabel;
    [self setNeedsLayout];
}

- (void)setSpacingBelowUpperLabel:(CGFloat)spacingBelowUpperLabel
{
    _spacingBelowUpperLabel = spacingBelowUpperLabel;
    [self setNeedsLayout];
}

- (void)setUpperLabelText:(NSString *)text
{
    _upperLabelText = text;
    if (![self.upperLabel.text isEqualToString:text]) {
        self.upperLabel.text = text;
        [self.upperLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setUpperLabelFont:(UIFont *)font
{
    _upperLabelFont = font;
    if (self.upperLabel.font != font) {
        self.upperLabel.font = font;
        [self.upperLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setUpperLabelTextColor:(UIColor *)color
{
    _upperLabelTextColor = color;
    self.upperLabel.textColor = color;
}

- (void)setLowerLabelText:(NSString *)text
{
    _lowerLabelText = text;
    if (![self.lowerLabel.text isEqualToString:text]) {
        self.lowerLabel.text = text;
        [self.lowerLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setLowerLabelFont:(UIFont *)font
{
    _lowerLabelFont = font;
    if (self.lowerLabel.font != font) {
        self.lowerLabel.font = font;
        [self.lowerLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setLowerLabelTextColor:(UIColor *)color
{
    _lowerLabelTextColor = color;
    self.lowerLabel.textColor = color;
}

@end
