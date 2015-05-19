//
//  CHGridlineView.m
//  Charlotte
//
//  Created by Ben Guo on 10/14/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHGridlineView.h"
#import "CHLabel.h"

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

        _lineDashPattern = nil;
        _lineLayer = [CAShapeLayer layer];
        _lineColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _lineLayer.strokeColor = _lineColor.CGColor;
        _lineLayer.lineCap = kCALineCapRound;
        _lineLayer.lineWidth = 1;
        _lineLayer.lineDashPattern = _lineDashPattern;
        [self.layer addSublayer:_lineLayer];

        _leftLabel = [[CHLabel alloc] initWithFrame:CGRectZero];
        _leftLabel.edgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _lowerLeftLabel = [[CHLabel alloc] initWithFrame:CGRectZero];
        _lowerLeftLabel.edgeInsets = UIEdgeInsetsMake(3, 5, 0, 0);
        _upperLeftLabel = [[CHLabel alloc] initWithFrame:CGRectZero];
        _upperLeftLabel.edgeInsets = UIEdgeInsetsMake(0, 5, 3, 0);
        _rightLabel = [[CHLabel alloc] initWithFrame:CGRectZero];
        _rightLabel.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        [self addSubview:_leftLabel];
        [self addSubview:_lowerLeftLabel];
        [self addSubview:_upperLeftLabel];
        [self addSubview:_rightLabel];
        self.clipsToBounds = NO;
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

    [self.leftLabel setCenter:CGPointMake(CGRectGetMidX(self.leftLabel.bounds), midY)];

    CGFloat leftLabelMaxY = CGRectGetMaxY(self.leftLabel.frame);
    [self.lowerLeftLabel setCenter:CGPointMake(CGRectGetMidX(self.lowerLeftLabel.bounds),
                                               leftLabelMaxY + CGRectGetMidY(self.lowerLeftLabel.bounds))];

    CGFloat leftLabelMinY = CGRectGetMinY(self.leftLabel.frame);
    [self.upperLeftLabel setCenter:CGPointMake(CGRectGetMidX(self.upperLeftLabel.bounds),
                                               leftLabelMinY - CGRectGetMinY(self.upperLeftLabel.bounds))];

    [self.rightLabel setCenter:CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetMidX(self.rightLabel.bounds),
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

@end
