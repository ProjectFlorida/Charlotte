//
//  CHGridlineView.m
//  Charlotte
//
//  Created by Ben Guo on 10/14/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHGridlineView.h"

@interface CHGridlineView ()
@property (nonatomic, strong) CAShapeLayer *lineLayer;

@end

@implementation CHGridlineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = 1;
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
