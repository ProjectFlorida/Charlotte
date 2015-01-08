//
//  CHGridlineView.m
//  Charlotte
//
//  Created by Ben Guo on 10/14/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHGridlineView.h"

@interface CHGridlineView ()

@property (nonatomic, strong, readwrite) UIView *labelView;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation CHGridlineView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lineLayer.frame = self.bounds;
    self.gradientLayer.frame = self.bounds;
    CGFloat midY = CGRectGetMidY(self.bounds);
    CGSize labelSize = self.labelView.bounds.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (self.labelViewPosition) {
        case CHViewPositionBottomLeft:
            [self.labelView setCenter:CGPointMake((labelSize.width/2.0) + self.layoutMargins.left,
                                                  midY + (labelSize.height/2.0) + self.layoutMargins.top)];
            [path moveToPoint:CGPointMake(0, midY)];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), midY)];
            break;

        case CHViewPositionCenterRight:
            [self.labelView setCenter:CGPointMake(self.bounds.size.width - (labelSize.width/2.0) - self.layoutMargins.right,
                                                  midY)];
            [path moveToPoint:CGPointMake(0, midY)];
            [path addLineToPoint:CGPointMake(CGRectGetMinX(self.labelView.frame),
                                             midY)];
            break;

        default:
            break;
    }
    self.lineLayer.path = path.CGPath;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, CGRectGetMaxY(self.labelView.frame));
}

- (void)initialize
{
    _labelViewPosition = CHViewPositionBottomLeft;
    _leftFadeWidth = 0;

    _lineDashPattern = nil;
    _lineLayer = [CAShapeLayer layer];
    _lineColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    _lineLayer.strokeColor = _lineColor.CGColor;
    _lineLayer.lineCap = kCALineCapRound;
    _lineLayer.lineWidth = 1;
    _lineLayer.lineDashPattern = _lineDashPattern;
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.startPoint = CGPointMake(0, 0.5);
    _gradientLayer.endPoint = CGPointMake(1, 0.5);
    _gradientLayer.locations = @[@0, @(_leftFadeWidth)];
    _gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)_lineColor.CGColor];
    _gradientLayer.mask = _lineLayer;
    [self.layer addSublayer:_gradientLayer];

    _labelView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_labelView];
}

#pragma mark - Setters

- (void)setLabelViewPosition:(CHViewPosition)labelPosition
{
    _labelViewPosition = labelPosition;
    [self setNeedsLayout];
}

- (void)setLabelView:(UIView *)view
{
    if (_labelView) {
        [_labelView removeFromSuperview];
    }
    _labelView = view;
    [self addSubview:_labelView];
    [self setNeedsLayout];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.lineLayer.strokeColor = lineColor.CGColor;
    self.gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)lineColor.CGColor];
}

- (void)setLeftFadeWidth:(CGFloat)leftFadeWidth
{
    _leftFadeWidth = leftFadeWidth;
    self.gradientLayer.locations = @[@0, @(leftFadeWidth)];
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

@end
