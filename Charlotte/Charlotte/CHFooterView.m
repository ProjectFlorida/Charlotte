//
//  CHFooterView.m
//  Charlotte
//
//  Created by Ben Guo on 10/22/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHFooterView.h"

NSString *const kCHFooterViewReuseId = @"CHFooterView";

@interface CHFooterView ()

@property (nonatomic, strong) CAShapeLayer *lineLayer;

@end

@implementation CHFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.lineWidth = 1;
        _lineLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
        [self.layer addSublayer:_lineLayer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    self.lineLayer.path = path.CGPath;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.lineLayer.lineWidth = lineWidth;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.lineLayer.strokeColor = lineColor.CGColor;
}

@end
