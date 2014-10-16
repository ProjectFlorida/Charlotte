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
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineWidth = 1;
        _shapeLayer.fillColor = nil;
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _shapeLayer.opacity = 1;
        [self.layer addSublayer:_shapeLayer];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _shapeLayer.path = nil;
}

- (void)setPoints:(NSArray *)points
{
    NSInteger count = points.count;
    if (!count) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint firstPoint = [points[0] CGPointValue];
    [path moveToPoint:CGPointMake(firstPoint.x, firstPoint.y)];
    for (int i = 1; i < count; i++) {
        CGPoint point = [points[i] CGPointValue];
        [path addLineToPoint:CGPointMake(point.x, point.y)];
    }
    _shapeLayer.path = path.CGPath;
}

@end
