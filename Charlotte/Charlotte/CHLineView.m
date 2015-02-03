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
#import "CHGradientView.h"

NSString *const kCHLineViewReuseId = @"CHLineView";

@interface CHLineView ()

@property (nonatomic, strong) NSArray *lineValues;
@property (nonatomic, strong) NSArray *scatterPoints;
@property (nonatomic, strong) NSMutableArray *scatterPointViews;
@property (nonatomic, strong) CAShapeLayer *lineMaskLayer;
@property (nonatomic, strong) CHGradientView *lineView;
@property (nonatomic, strong) UIView *scatterPointContainerView;

@end

@implementation CHLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineValues = @[];
        _scatterPoints = @[];
        _scatterPointViews = [NSMutableArray array];
        _minValue = 0;
        _maxValue = 1;
        _footerHeight = 30;
        _lineDrawingAnimationDuration = 1.0;

        _lineColor = [UIColor whiteColor];
        _lineTintColor = nil;
        _lineWidth = 4;

        _lineMaskLayer = [CAShapeLayer layer];
        _lineMaskLayer.lineCap = kCALineCapRound;
        _lineMaskLayer.lineWidth = _lineWidth;
        _lineMaskLayer.fillColor = nil;
        _lineMaskLayer.strokeColor = [UIColor whiteColor].CGColor;

        _lineView = [[CHGradientView alloc] initWithFrame:CGRectZero];
        _lineView.colors = @[_lineColor, _lineColor];
        _lineView.startPoint = CGPointMake(0, 0.5);
        _lineView.endPoint = CGPointMake(1, 0.5);
        _lineView.layer.mask = _lineMaskLayer;

        _scatterPointContainerView = [[UIView alloc] initWithFrame:CGRectZero];

        [self addSubview:_scatterPointContainerView];
        [self addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.lineView.frame = self.bounds;
    self.lineMaskLayer.frame = self.bounds;
    self.scatterPointContainerView.frame = self.bounds;
    [self drawLineWithValues:self.lineValues animated:NO];
    [self drawScatterPoints:self.scatterPoints animated:NO];
    [self drawInteractivePoint:self.interactivePoint animated:NO];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self resetScatterPoints];
    [self resetInteractivePoint];
    [self.lineMaskLayer setPath:nil];
}

- (CGFloat)yPositionWithRelativeValue:(CGFloat)value
{
    CGFloat displayHeight = self.bounds.size.height - self.footerHeight;
    return ((1 - value) * displayHeight);
}

- (CGFloat)xPositionWithIndex:(NSInteger)index inCount:(NSInteger)count
{
    CGFloat cellWidth = self.bounds.size.width / count;
    CGFloat leftMargin = cellWidth / 2.0;
    return leftMargin + cellWidth*index;
}

- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue
           animated:(BOOL)animated completion:(void (^)(void))completion
{
    _minValue = minValue;
    _maxValue = maxValue;
    [self drawLineWithValues:self.lineValues animated:animated];
    [self drawScatterPoints:self.scatterPoints animated:animated];
    [self drawInteractivePoint:self.interactivePoint animated:animated];
    if (completion) {
        completion();
    }
}

- (void)drawLineWithValues:(NSArray *)values animated:(BOOL)animated
{
    self.lineValues = values;
    NSInteger count = values.count;
    if (!count) {
        return;
    }

    // transform the values array (which may contain nulls) into an array of bezier paths
    NSMutableArray *paths = [NSMutableArray array];
    NSMutableArray *points = [NSMutableArray array];
    NSUInteger i = 0;
    while (i < count) {
        id value = values[i];
        BOOL valueIsNull = [value isKindOfClass:[NSNull class]];
        if (!valueIsNull) {
            CGFloat x = [self xPositionWithIndex:i inCount:count];
            CGFloat floatValue = [value floatValue];
            CGFloat scaledValue = [CHChartView scaledValue:floatValue minValue:self.minValue maxValue:self.maxValue];
            CGFloat y = [self yPositionWithRelativeValue:scaledValue];
            NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
            [points addObject:pointValue];
        }
        if ((valueIsNull || i == count - 1) && [points count] > 0) {
            UIBezierPath *path = [UIBezierPath interpolateCGPointsWithHermite:points closed:NO];
            [paths addObject:path];
            [points removeAllObjects];
        }
        i++;
    }

    // concatenate the paths
    UIBezierPath *fullPath = [UIBezierPath bezierPath];
    for (UIBezierPath *path in paths) {
        [fullPath appendPath:path];
    }

    [self.lineMaskLayer setPath:fullPath.CGPath];
    if (animated) {
        [CATransaction begin];
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.lineDrawingAnimationDuration;
        pathAnimation.fromValue = @0;
        pathAnimation.toValue = @1;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        NSString *strokeEndAnimationKey = @"strokeEndAnimation";
        [self.lineMaskLayer addAnimation:pathAnimation forKey:strokeEndAnimationKey];
        [CATransaction commit];
    }
}

- (void)resetScatterPoints
{
    self.scatterPoints = @[];
    for (UIView *view in self.scatterPointViews) {
        [view removeFromSuperview];
    }
    [self.scatterPointViews removeAllObjects];
}

- (void)drawScatterPoints:(NSArray *)points animated:(BOOL)animated
{
    [self resetScatterPoints];
    self.scatterPoints = points;
    for (CHScatterPoint *point in points) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, point.radius, point.radius)];
        view.layer.cornerRadius = point.radius/2.0;
        view.backgroundColor = point.color;
        CGFloat scaledValue = [CHChartView scaledValue:point.value minValue:self.minValue maxValue:self.maxValue];
        CGFloat x = self.bounds.size.width * point.relativeXPosition;
        CGFloat y = [self yPositionWithRelativeValue:scaledValue];
        view.center = CGPointMake(x, y);
        [self.scatterPointContainerView addSubview:view];
        [self.scatterPointViews addObject:view];
    }
    self.scatterPointContainerView.alpha = 0;
    if (animated) {
        [UIView animateWithDuration:self.lineDrawingAnimationDuration delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.scatterPointContainerView.alpha = 1;
                         } completion:nil];
    }
    else {
        self.scatterPointContainerView.alpha = 1;
    }
}

- (void)resetInteractivePoint
{
    if (self.interactivePoint) {
        [self.interactivePoint.view removeFromSuperview];
    }
    self.interactivePoint = nil;
}

- (void)drawInteractivePoint:(CHInteractivePoint *)point animated:(BOOL)animated
{
    [self resetInteractivePoint];
    self.interactivePoint = point;
    CGFloat scaledValue = [CHChartView scaledValue:point.value minValue:self.minValue maxValue:self.maxValue];
    CGFloat x = self.bounds.size.width * point.relativeXPosition;
    CGFloat y = [self yPositionWithRelativeValue:scaledValue];
    self.interactivePoint.view.center = CGPointMake(x, y);
    self.interactivePoint.view.alpha = 0;
    [self addSubview:self.interactivePoint.view];
    if (animated) {
        [UIView animateWithDuration:self.lineDrawingAnimationDuration delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.interactivePoint.view.alpha = 1;
                         } completion:nil];
    }
    else {
        self.interactivePoint.view.alpha = 1;
    }
}

#pragma mark - Setters

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.lineMaskLayer.lineWidth = _lineWidth;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    if (self.lineTintColor) {
        self.lineView.colors = @[self.lineTintColor, _lineColor];
    }
    else {
        self.lineView.colors = @[_lineColor, _lineColor];
    }
}

- (void)setLineTintColor:(UIColor *)lineTintColor
{
    _lineTintColor = lineTintColor;
    if (_lineTintColor) {
        self.lineView.colors = @[_lineTintColor, self.lineColor];
    }
    else {
        self.lineView.colors = @[self.lineColor, self.lineColor];
    }
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
    [self setNeedsLayout];
}

@end
