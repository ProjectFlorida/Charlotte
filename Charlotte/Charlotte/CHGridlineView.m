//
//  CHGridlineView.m
//  Charlotte
//
//  Created by Ben Guo on 10/14/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHGridlineView.h"

@interface CHGridlineView ()

@property (nonatomic, strong) UIView *labelView;
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
            [path addLineToPoint:CGPointMake(CGRectGetMinX(self.labelView.frame) - self.layoutMargins.right, midY)];
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

    _lineDashPattern = nil;
    _lineLayer = [CAShapeLayer layer];
    _lineColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    _lineLayer.strokeColor = _lineColor.CGColor;
    _lineLayer.lineWidth = 1;
    _lineLayer.lineDashPattern = _lineDashPattern;
    [self.layer addSublayer:_lineLayer];

    _labelView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_labelView];
}

#pragma mark - Setters

- (void)setLabelViewPosition:(CHViewPosition)labelPosition
{
    _labelViewPosition = labelPosition;
    [self layoutIfNeeded];
}

- (void)setLabelView:(UILabel *)label
{
    if (_labelView) {
        [_labelView removeFromSuperview];
    }
    _labelView = label;
    [self addSubview:_labelView];
    [self layoutIfNeeded];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.lineLayer.strokeColor = lineColor.CGColor;
}

@end
