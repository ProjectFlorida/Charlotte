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

    CGFloat midY = CGRectGetMidY(self.bounds);

    if (!CGRectEqualToRect(self.lineLayer.frame, self.bounds)) {
        self.lineLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.lineInset.left, midY)];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds) - self.lineInset.right, midY)];
        self.lineLayer.path = path.CGPath;
    }

    if (self.leftLabelView) {
        CGSize size = self.leftLabelView.bounds.size;
        [self.leftLabelView setCenter:CGPointMake(size.width/2.0, midY)];
    }

    if (self.lowerLeftLabelView) {
        CGFloat leftLabelMaxY = CGRectGetMaxY(self.leftLabelView.frame);
        CGSize size = self.lowerLeftLabelView.bounds.size;
        [self.lowerLeftLabelView setCenter:CGPointMake(size.width/2.0, leftLabelMaxY + size.height/2.0)];
    }

    if (self.rightLabelView) {
        CGSize rightLabelSize = self.rightLabelView.bounds.size;
        [self.rightLabelView setCenter:CGPointMake(CGRectGetWidth(self.bounds) - (rightLabelSize.width/2.0),
                                                   midY)];
    }

}

- (void)initialize
{
    _lineInset = UIEdgeInsetsMake(0, 30, 0, 0);

    _lineDashPattern = nil;
    _lineLayer = [CAShapeLayer layer];
    _lineColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    _lineLayer.strokeColor = _lineColor.CGColor;
    _lineLayer.lineCap = kCALineCapRound;
    _lineLayer.lineWidth = 1;
    _lineLayer.lineDashPattern = _lineDashPattern;
    [self.layer addSublayer:_lineLayer];

    _leftLabelView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_leftLabelView];
}

#pragma mark - Setters

- (void)setLineInset:(UIEdgeInsets)lineInset
{
    _lineInset = lineInset;
    [self setNeedsLayout];
}

- (void)setLeftLabelView:(UIView *)view
{
    if (_leftLabelView) {
        [_leftLabelView removeFromSuperview];
    }
    _leftLabelView = view;
    [self addSubview:_leftLabelView];
    [self setNeedsLayout];
}

- (void)setLowerLeftLabelView:(UIView *)view
{
    if (_lowerLeftLabelView) {
        [_lowerLeftLabelView removeFromSuperview];
    }
    _lowerLeftLabelView = view;
    [self addSubview:_lowerLeftLabelView];
    [self setNeedsLayout];
}

- (void)setRightLabelView:(UIView *)view
{
    if (_rightLabelView) {
        [_rightLabelView removeFromSuperview];
    }
    _rightLabelView = view;
    [self addSubview:_rightLabelView];
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

@end
