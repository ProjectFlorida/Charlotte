//
//  CHHorizontalBarCell.m
//  Charlotte
//
//  Created by Ben Guo on 2/2/15.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHHorizontalBarCell.h"

@interface CHHorizontalBarCell ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *barLabel;
@property (nonatomic, strong) UIView *barLabelContainerView;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) UIView *barView;

/// The width of the bar (relative to the cell's width)
@property (nonatomic, assign) CGFloat barWidth;

@end

@implementation CHHorizontalBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineColor = [UIColor darkGrayColor];
        _barColor = [UIColor darkGrayColor];
        _barLabelBackgroundColor = [UIColor whiteColor];
        _leftLabelFont = [UIFont systemFontOfSize:13];
        _rightLabelFont = _leftLabelFont;
        _barLabelFont = _leftLabelFont;
        _lineDashPattern = @[@0.5, @3];
        _barHeight = 9;
        _barWidth = 0.5;
        _animationDuration = 0.4;
        _animationSpringDamping = 0.7;

        _leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftLabel.font = _leftLabelFont;
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.font = _rightLabelFont;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _barLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _barLabel.font = _barLabelFont;
        _barLabel.textAlignment = NSTextAlignmentCenter;
        _barLabelContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _barLabelContainerView.backgroundColor = _barLabelBackgroundColor;
        [_barLabelContainerView addSubview:_barLabel];
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.strokeColor = _lineColor.CGColor;
        _lineLayer.lineWidth = 1;
        _lineLayer.lineCap = kCALineCapRound;
        _lineLayer.lineDashPattern = _lineDashPattern;
        _barView = [[UIView alloc] initWithFrame:CGRectZero];
        _barView.backgroundColor = _barColor;

        [self.layer addSublayer:_lineLayer];
        [self addSubview:_barView];
        [self addSubview:_leftLabel];
        [self addSubview:_rightLabel];
        [self addSubview:_barLabelContainerView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.leftLabel.center = CGPointMake(CGRectGetMidX(self.leftLabel.bounds), CGRectGetMidY(self.leftLabel.bounds));
    self.rightLabel.center = CGPointMake(CGRectGetWidth(bounds) - CGRectGetMidX(self.rightLabel.bounds),
                                         CGRectGetMidY(self.rightLabel.bounds));

    CGFloat actualBarWidth = MIN(self.barWidth*CGRectGetWidth(bounds), CGRectGetWidth(bounds));
    self.barView.frame = CGRectMake(0, CGRectGetHeight(bounds) - self.barHeight,
                                    actualBarWidth, self.barHeight);
    self.barView.layer.cornerRadius = CGRectGetHeight(self.barView.frame)/2.0;
    self.barLabelContainerView.frame = CGRectInset(self.barLabel.bounds, -2, 0);
    self.barLabel.center = CGPointMake(CGRectGetMidX(self.barLabelContainerView.bounds),
                                       CGRectGetMidY(self.barLabelContainerView.bounds));
    self.barLabelContainerView.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(self.barView.frame));

    CGRect expectedLineLayerFrame = CGRectMake(CGRectGetMinX(self.barView.frame),
                                               CGRectGetMinY(self.barView.frame),
                                               CGRectGetWidth(self.bounds), CGRectGetHeight(self.barView.frame));
    if (!CGRectEqualToRect(self.lineLayer.frame, expectedLineLayerFrame)) {
        self.lineLayer.frame = expectedLineLayerFrame;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, CGRectGetMidY(self.barView.bounds))];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(bounds), CGRectGetMidY(self.barView.bounds))];
        self.lineLayer.path = path.CGPath;
    }
}

#pragma mark - Setters

- (void)setBarWidth:(CGFloat)barWidth animated:(BOOL)animated
{
    _barWidth = barWidth;
    CGFloat duration = animated ? self.animationDuration : 0;
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:self.animationSpringDamping
          initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
              [self layoutSubviews];
          } completion:nil];
}

- (void)setLeftLabelFont:(UIFont *)leftLabelFont
{
    _leftLabelFont = leftLabelFont;
    if (self.leftLabel.font != leftLabelFont) {
        self.leftLabel.font = leftLabelFont;
        [self.leftLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setRightLabelFont:(UIFont *)rightLabelFont
{
    _rightLabelFont = rightLabelFont;
    if (self.rightLabel.font != rightLabelFont) {
        self.rightLabel.font = rightLabelFont;
        [self.rightLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setBarLabelFont:(UIFont *)barLabelFont
{
    _barLabelFont = barLabelFont;
    if (self.barLabel.font != barLabelFont) {
        self.barLabel.font = barLabelFont;
        [self.barLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setLeftLabelText:(NSString *)leftLabelText
{
    _leftLabelText = leftLabelText;
    if (![self.leftLabel.text isEqualToString:leftLabelText]) {
        self.leftLabel.text = leftLabelText;
        [self.leftLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setRightLabelText:(NSString *)rightLabelText
{
    _rightLabelText = rightLabelText;
    if (![self.rightLabel.text isEqualToString:rightLabelText]) {
        self.rightLabel.text = rightLabelText;
        [self.rightLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setBarLabelText:(NSString *)barLabelText
{
    _barLabelText = barLabelText;
    if (![self.barLabel.text isEqualToString:barLabelText]) {
        self.barLabel.text = barLabelText;
        [self.barLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setBarColor:(UIColor *)barColor
{
    _barColor = barColor;
    self.barView.backgroundColor = barColor;
}

- (void)setLeftLabelColor:(UIColor *)leftLabelColor
{
    _leftLabelColor = leftLabelColor;
    self.leftLabel.textColor = leftLabelColor;
}

- (void)setRightLabelColor:(UIColor *)rightLabelColor
{
    _rightLabelColor = rightLabelColor;
    self.rightLabel.textColor = rightLabelColor;
}

- (void)setBarLabelColor:(UIColor *)barLabelColor
{
    _barLabelColor = barLabelColor;
    self.barLabel.textColor = barLabelColor;
}

- (void)setBarLabelBackgroundColor:(UIColor *)color
{
    _barLabelBackgroundColor = color;
    self.barLabelContainerView.backgroundColor = color;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.lineLayer.lineWidth = lineWidth;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.lineLayer.strokeColor = lineColor.CGColor;
}

- (void)setLineDashPattern:(NSArray *)lineDashPattern
{
    _lineDashPattern = lineDashPattern;
    self.lineLayer.lineDashPattern = lineDashPattern;
}

- (void)setBarHeight:(CGFloat)barHeight
{
    _barHeight = barHeight;
    [self setNeedsLayout];
}

@end
