//
//  CHLineView.m
//  Charlotte
//
//  Created by Ben Guo on 10/16/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHLineView.h"
#import "CHChartView_Private.h"

NSString *const kCHLineViewReuseId = @"CHLineView";

@interface CHLineView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, strong) NSArray *points;

@end

@implementation CHLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _minValue = 0;
        _maxValue = 1;
        _footerHeight = 30;
        self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.1];
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineWidth = 1;
        _shapeLayer.fillColor = nil;
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _shapeLayer.opacity = 1;
        _shapeLayer.frame = self.bounds;
        [self.layer addSublayer:_shapeLayer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setPoints:self.points];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [_shapeLayer setPath:nil];
}

- (CGFloat)yPositionWithRelativeValue:(CGFloat)value
{
    CGFloat displayHeight = self.bounds.size.height - self.footerHeight;
    return (1 - value) * displayHeight - self.footerHeight;
}

- (CGFloat)xPositionWithIndex:(NSInteger)index inCount:(NSInteger)count
{
    CGFloat cellWidth = self.bounds.size.width / count;
    CGFloat leftMargin = cellWidth / 2.0;
    return leftMargin + cellWidth*index;
}

- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue animated:(BOOL)animated completion:(void (^)(void))completion
{
    _minValue = minValue;
    _maxValue = maxValue;
    [self setPoints:self.points];
}

- (void)setPoints:(NSArray *)points
{
    _points = points;
    NSInteger count = points.count;
    if (!count) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint firstPoint = [points[0] CGPointValue];
    CGFloat firstX = [self xPositionWithIndex:0 inCount:count];
    CGFloat relativeFirstValue = [CHChartView relativeValue:firstPoint.y minValue:self.minValue maxValue:self.maxValue];
    CGFloat firstY = [self yPositionWithRelativeValue:relativeFirstValue];
    [path moveToPoint:CGPointMake(firstX, firstY)];
    for (int i = 1; i < count; i++) {
        CGPoint point = [points[i] CGPointValue];
        CGFloat x = [self xPositionWithIndex:i inCount:count];
        CGFloat relativeValue = [CHChartView relativeValue:point.y minValue:self.minValue maxValue:self.maxValue];
        CGFloat y = [self yPositionWithRelativeValue:relativeValue];
        [path addLineToPoint:CGPointMake(x, y)];
    }
    [_shapeLayer setPath:path.CGPath];
}

#pragma mark - Setters

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
}

@end
