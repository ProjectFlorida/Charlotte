//
//  CHLineView.m
//  Charlotte
//
//  Created by Ben Guo on 10/16/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHLineView.h"
#import "CHChartViewSubclass.h"
#import "UIBezierPath+Interpolation.h"

NSString *const kCHLineViewReuseId = @"CHLineView";

@interface CHLineView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) NSArray *values;

@end

@implementation CHLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _values = @[];
        _minValue = 0;
        _maxValue = 1;
        _footerHeight = 30;
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineWidth = 4;
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
    [self redrawWithValues:self.values];
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
    [self redrawWithValues:self.values];
}

- (void)redrawWithValues:(NSArray *)values
{
    _values = values;
    NSInteger count = values.count;
    if (!count) {
        return;
    }
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        CGFloat x = [self xPositionWithIndex:i inCount:count];
        CGFloat value = [values[i] floatValue];
        CGFloat scaledValue = [CHChartView scaledValue:value minValue:self.minValue maxValue:self.maxValue];
        CGFloat y = [self yPositionWithRelativeValue:scaledValue];
        NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [points addObject:pointValue];
    }
    UIBezierPath *path = [UIBezierPath interpolateCGPointsWithHermite:points closed:NO];
    [self.shapeLayer setPath:path.CGPath];
}

#pragma mark - Setters

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
}

@end
