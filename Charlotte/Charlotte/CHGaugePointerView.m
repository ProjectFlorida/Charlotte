//
//  CHGaugePointerView.m
//  Charlotte
//
//  Created by Ben Guo on 4/1/15.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHGaugePointerView.h"
#import "CHLabel.h"

@interface CHGaugePointerView ()

@property (nonatomic, strong) CHLabel *label;
@property (nonatomic, strong) UIView *needleView;
@property (nonatomic, strong) UIView *needleCircleView;

@end

@implementation CHGaugePointerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textColor = [UIColor whiteColor];
        _needleColor = [UIColor grayColor];
        _labelBackgroundColor = [UIColor blackColor];
        _font = [UIFont systemFontOfSize:12];
        _labelCornerRadius = 4;
        _needleWidth = 1;
        _spacingBelowLabel = 4;
        _labelEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);

        _label = [[CHLabel alloc] initWithFrame:CGRectZero];
        _label.clipsToBounds = YES;
        _label.backgroundColor = _labelBackgroundColor;
        _label.textColor = _textColor;
        _label.edgeInsets = _labelEdgeInsets;
        _label.font = _font;
        _needleView = [[UIView alloc] initWithFrame:CGRectZero];
        _needleView.backgroundColor = _needleColor;
        _needleCircleView = [[UIView alloc] initWithFrame:CGRectZero];
        _needleCircleView.backgroundColor = _needleColor;

        [self addSubview:_needleView];
        [self addSubview:_needleCircleView];
        [self addSubview:_label];
        self.needleCircleRadius = 2;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.label.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(self.label.bounds));
    self.label.layer.cornerRadius = self.labelCornerRadius;
    CGFloat needleViewY = CGRectGetMaxY(self.label.frame) + self.spacingBelowLabel;
    self.needleView.frame = CGRectMake(CGRectGetMidX(bounds) - (self.needleWidth/2.0), needleViewY,
                                       self.needleWidth, CGRectGetHeight(bounds) - needleViewY);
    self.needleCircleView.center = CGPointMake(CGRectGetMidX(bounds),
                                               CGRectGetMaxY(bounds) - CGRectGetMidY(self.needleCircleView.bounds));
}

#pragma mark - Setters

- (void)setNeedleCircleRadius:(CGFloat)needleCircleRadius
{
    if (_needleCircleRadius == needleCircleRadius) {
        return;
    }
    _needleCircleRadius = needleCircleRadius;
    self.needleCircleView.frame = CGRectMake(0, 0, needleCircleRadius*2, needleCircleRadius*2);
    self.needleCircleView.layer.cornerRadius = needleCircleRadius;
    [self setNeedsLayout];
}

- (void)setNeedleWidth:(CGFloat)needleWidth
{
    if (_needleWidth == needleWidth) {
        return;
    }
    _needleWidth = needleWidth;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text
{
    if ([_text isEqualToString:text]) {
        return;
    }
    _text = text;
    self.label.text = text;
    [self.label sizeToFit];
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font
{
    if (_font == font) {
        return;
    }
    _font = font;
    self.label.font = font;
    [self.label sizeToFit];
    [self setNeedsLayout];
}

- (void)setLabelEdgeInsets:(UIEdgeInsets)labelEdgeInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_labelEdgeInsets, labelEdgeInsets)) {
        return;
    }
    _labelEdgeInsets = labelEdgeInsets;
    self.label.edgeInsets = labelEdgeInsets;
    [self.label sizeToFit];
    [self setNeedsLayout];
}

- (void)setSpacingBelowLabel:(CGFloat)spacingBelowLabel
{
    if (_spacingBelowLabel == spacingBelowLabel) {
        return;
    }
    _spacingBelowLabel = spacingBelowLabel;
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.label.textColor = textColor;
}

- (void)setLabelCornerRadius:(CGFloat)labelCornerRadius
{
    _labelCornerRadius = labelCornerRadius;
    self.label.layer.cornerRadius = labelCornerRadius;
}

- (void)setLabelBackgroundColor:(UIColor *)labelBackgroundColor
{
    _labelBackgroundColor = labelBackgroundColor;
    self.label.backgroundColor = labelBackgroundColor;
}

@end
