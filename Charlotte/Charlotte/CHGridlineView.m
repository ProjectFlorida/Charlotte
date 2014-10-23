//
//  CHGridlineView.m
//  Charlotte
//
//  Created by Ben Guo on 10/14/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHGridlineView.h"

@interface CHGridlineView ()

@property (nonatomic, strong) UILabel *label;
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
    CGSize labelSize = self.label.bounds.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (self.labelPosition) {
        case CHGridlineLabelPositionBottomLeft:
            [self.label setCenter:CGPointMake((labelSize.width/2.0) + self.layoutMargins.left,
                                              midY + (labelSize.height/2.0) + self.layoutMargins.top)];
            [path moveToPoint:CGPointMake(0, midY)];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), midY)];
            break;

        case CHGridlineLabelPositionCenterRight:
            [self.label setCenter:CGPointMake(self.bounds.size.width - (labelSize.width/2.0) - self.layoutMargins.right,
                                              midY)];
            [path moveToPoint:CGPointMake(0, midY)];
            [path addLineToPoint:CGPointMake(CGRectGetMinX(self.label.frame) - self.layoutMargins.right, midY)];
            break;

        default:
            break;
    }
    self.lineLayer.path = path.CGPath;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, CGRectGetMaxY(self.label.frame));
}

- (void)initialize
{
    _labelColor = [UIColor whiteColor];
    _labelFont = [UIFont systemFontOfSize:13];
    _labelPosition = CHGridlineLabelPositionCenterRight;

    _lineDashPattern = nil;
    _lineLayer = [CAShapeLayer layer];
    _lineLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    _lineLayer.lineWidth = 1;
    _lineLayer.lineDashPattern = _lineDashPattern;
    [self.layer addSublayer:_lineLayer];

    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.font = _labelFont;
    _label.textColor = _labelColor;
    [self addSubview:_label];
}

#pragma mark - Setters

- (void)setLabelColor:(UIColor *)labelColor
{
    _labelColor = labelColor;
    self.label.textColor = labelColor;
}

- (void)setLabelFont:(UIFont *)labelFont
{
    _labelFont = labelFont;
    self.label.font = labelFont;
    [self.label sizeToFit];
    [self invalidateIntrinsicContentSize];
}

- (void)setLabelText:(NSString *)labelText
{
    _labelText = labelText;
    self.label.text = labelText;
    [self.label sizeToFit];
    [self invalidateIntrinsicContentSize];
}

@end
