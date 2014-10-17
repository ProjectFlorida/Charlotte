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

@end

@implementation CHLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.1];
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.backgroundColor = [[UIColor magentaColor] colorWithAlphaComponent:0.2].CGColor;
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
    _shapeLayer.frame = self.bounds;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [_shapeLayer setPath:nil];
}

- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)setPoints:(NSArray *)points {
    [self setPoints:points log:NO];
}

- (void)setPoints:(NSArray *)points log:(BOOL)log
{
    NSInteger count = points.count;
    if (!count) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint firstPoint = [points[0] CGPointValue];
    [path moveToPoint:CGPointMake(firstPoint.x, firstPoint.y)];
    if (log) { NSLog(@"--o--"); }
    for (int i = 1; i < count; i++) {
        CGPoint point = [points[i] CGPointValue];
        [path addLineToPoint:CGPointMake(point.x, point.y)];
        if (log) { NSLog(@"%f", point.y);}
    }
    [_shapeLayer setPath:path.CGPath];
}

@end
