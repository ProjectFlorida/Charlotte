//
//  CHGridlineView.m
//  Charlotte
//
//  Created by Ben Guo on 10/14/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHGridlineView.h"

@interface CHGridlineView ()
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *lowerLeftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) CAShapeLayer *lineLayer;

@end

@implementation CHGridlineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _leftLabelInset = 5;
        _rightLabelInset = 5;
        _spacingBelowLeftLabel = 0;

        _lineDashPattern = nil;
        _lineLayer = [CAShapeLayer layer];
        _lineColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _lineLayer.strokeColor = _lineColor.CGColor;
        _lineLayer.lineCap = kCALineCapRound;
        _lineLayer.lineWidth = 1;
        _lineLayer.lineDashPattern = _lineDashPattern;
        [self.layer addSublayer:_lineLayer];

        _leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _lowerLeftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_leftLabel];
        [self addSubview:_lowerLeftLabel];
        [self addSubview:_rightLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat midY = CGRectGetMidY(self.bounds);

    if (!CGRectEqualToRect(self.lineLayer.frame, self.bounds)) {
        self.lineLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.lineInset.left, midY)];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds) - self.lineInset.right, midY)];
        self.lineLayer.path = path.CGPath;
    }

    [self.leftLabel setCenter:CGPointMake(self.leftLabelInset + CGRectGetMidX(self.leftLabel.bounds), midY)];

    CGFloat leftLabelMaxY = CGRectGetMaxY(self.leftLabel.frame);
    [self.lowerLeftLabel setCenter:CGPointMake(self.leftLabelInset + CGRectGetMidX(self.lowerLeftLabel.bounds),
                                               leftLabelMaxY + CGRectGetMidY(self.lowerLeftLabel.bounds))];

    [self.rightLabel setCenter:CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetMidX(self.rightLabel.bounds) - self.rightLabelInset,
                                           midY)];

}

#pragma mark - Setters

- (void)setLineInset:(UIEdgeInsets)lineInset
{
    _lineInset = lineInset;
    [self setNeedsLayout];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.lineLayer.strokeColor = lineColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.lineLayer.lineWidth = lineWidth;
}

- (void)setLineDashPattern:(NSArray *)lineDashPattern
{
    _lineDashPattern = lineDashPattern;
    self.lineLayer.lineDashPattern = lineDashPattern;
}

- (void)setLeftLabelFont:(UIFont *)font
{
    _leftLabelFont = font;
    if (self.leftLabel.font != font) {
        self.leftLabel.font = font;
        [self.leftLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setLowerLeftLabelFont:(UIFont *)font
{
    _lowerLeftLabelFont = font;
    if (self.lowerLeftLabel.font != font) {
        self.lowerLeftLabel.font = font;
        [self.lowerLeftLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setRightLabelFont:(UIFont *)font
{
    _rightLabelFont = font;
    if (self.rightLabel.font != font) {
        self.rightLabel.font = font;
        [self.rightLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setLeftLabelText:(NSString *)text
{
    _leftLabelText = text;
    if (![self.leftLabel.text isEqualToString:text]) {
        self.leftLabel.text = text;
        [self.leftLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setLowerLeftLabelText:(NSString *)text
{
    _lowerLeftLabelText = text;
    if (![self.lowerLeftLabel.text isEqualToString:text]) {
        self.lowerLeftLabel.text = text;
        [self.lowerLeftLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setRightLabelText:(NSString *)text
{
    _rightLabelText = text;
    if (![self.rightLabel.text isEqualToString:text]) {
        self.rightLabel.text = text;
        [self.rightLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setLeftLabelColor:(UIColor *)leftLabelColor
{
    _leftLabelColor = leftLabelColor;
    self.leftLabel.textColor = leftLabelColor;
}

- (void)setLowerLeftLabelColor:(UIColor *)lowerLeftLabelColor
{
    _lowerLeftLabelColor = lowerLeftLabelColor;
    self.lowerLeftLabel.textColor = lowerLeftLabelColor;
}

- (void)setRightLabelColor:(UIColor *)rightLabelColor
{
    _rightLabelColor = rightLabelColor;
    self.rightLabel.textColor = rightLabelColor;
}

- (void)setLeftLabelInset:(CGFloat)leftLabelInset
{
    if (_leftLabelInset == leftLabelInset) {
        return;
    }
    _leftLabelInset = leftLabelInset;
    [self setNeedsLayout];
}

- (void)setRightLabelInset:(CGFloat)rightLabelInset
{
    if (_rightLabelInset == rightLabelInset) {
        return;
    }
    _rightLabelInset = rightLabelInset;
    [self setNeedsLayout];
}

- (void)setSpacingBelowLeftLabel:(CGFloat)spacingBelowLeftLabel
{
    if (_spacingBelowLeftLabel == spacingBelowLeftLabel) {
        return;
    }
    _spacingBelowLeftLabel = spacingBelowLeftLabel;
    [self setNeedsLayout];
}

@end
