//
//  CHLineView.m
//  Charlotte
//
//  Created by Ben Guo on 10/16/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHLineView.h"

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

}

- (void)setPoints:(NSArray *)points
{
    NSInteger count = points.count;
    if (!count) {
        return;
    }
    CGFloat pointWidth = self.bounds.size.width / count;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 100)];
    for (NSValue *pointValue in points) {
        CGPoint point = [pointValue CGPointValue];
        CGFloat x = point.x * pointWidth;
        [path addLineToPoint:CGPointMake(x, 100)];
        NSLog(@"%f", x);
    }
    [path closePath];
    _shapeLayer.path = path.CGPath;
}

@end
