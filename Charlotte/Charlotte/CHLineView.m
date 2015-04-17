//
//  CHLineView.m
//  Charlotte
//
//  Created by Ben Guo on 10/16/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHLineView.h"
#import "CHBarChartViewProtected.h"
#import "UIBezierPath+Interpolation.h"
#import "CHGradientView.h"
#import "CHMathUtils.h"

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
        _gradientLocations = @[@0];
        _scatterPoints = @[];
        _scatterPointViews = [NSMutableArray array];
        _minValue = 0;
        _maxValue = 1;
        _footerHeight = 30;
        _lineDrawingAnimationDuration = 1.0;

        _lineColor = [UIColor whiteColor];
        _gradientColors = @[_lineColor];
        _lineWidth = 4;

        _lineMaskLayer = [CAShapeLayer layer];
        _lineMaskLayer.lineCap = kCALineCapRound;
        _lineMaskLayer.lineWidth = _lineWidth;
        _lineMaskLayer.fillColor = nil;
        _lineMaskLayer.strokeColor = [UIColor whiteColor].CGColor;

        _lineView = [[CHGradientView alloc] initWithFrame:CGRectZero];
        _lineView.colors = _gradientColors;
        _lineView.locations = _gradientLocations;
        _lineView.startPoint = CGPointMake(0.5, 1);
        _lineView.endPoint = CGPointMake(0.5, 0);
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
    CGRect bounds = self.bounds;
    self.lineView.frame = bounds;
    self.lineMaskLayer.frame = bounds;
    self.scatterPointContainerView.frame = bounds;
    [self drawLineWithValues:self.lineValues animated:NO];
    [self drawScatterPoints:self.scatterPoints animated:NO];
    [self drawInteractivePoint:self.interactivePoint animated:NO];
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
    CGFloat trueMinValue = [CHMathUtils trueMinValueWithMin:self.minValue max:self.maxValue
                                                     height:CGRectGetHeight(self.bounds)
                                               footerHeight:self.footerHeight];

    NSUInteger i = 0;
    while (i < count) {
        id value = values[i];
        BOOL valueIsNull = [value isKindOfClass:[NSNull class]];
        if (!valueIsNull) {
            CGFloat x = [self xPositionWithIndex:i inCount:count];
            CGFloat floatValue = [value floatValue];
            CGFloat y = [CHMathUtils yPositionWithValue:floatValue min:trueMinValue
                                                    max:self.maxValue height:CGRectGetHeight(self.bounds)];
            NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
            [points addObject:pointValue];
        }
        if ((valueIsNull || i == count - 1) && [points count] > 0) {
            UIBezierPath *path = [UIBezierPath interpolateCGPointsWithHermite:points closed:NO];
            if (path) {
                [paths addObject:path];
            }
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
    CGFloat trueMinValue = [CHMathUtils trueMinValueWithMin:self.minValue max:self.maxValue
                                                     height:CGRectGetHeight(self.bounds)
                                               footerHeight:self.footerHeight];
    for (CHScatterPoint *point in points) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, point.radius, point.radius)];
        view.layer.cornerRadius = point.radius/2.0;
        view.backgroundColor = point.color;
        CGFloat x = self.bounds.size.width * point.relativeXPosition;
        CGFloat y = [CHMathUtils yPositionWithValue:point.value min:trueMinValue
                                                max:self.maxValue height:CGRectGetHeight(self.bounds)];
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
    CGFloat trueMinValue = [CHMathUtils trueMinValueWithMin:self.minValue max:self.maxValue
                                                     height:CGRectGetHeight(self.bounds)
                                               footerHeight:self.footerHeight];
    CGFloat x = self.bounds.size.width * point.relativeXPosition;
    CGFloat y = [CHMathUtils yPositionWithValue:point.value min:trueMinValue
                                            max:self.maxValue height:CGRectGetHeight(self.bounds)];
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
    self.lineView.colors = @[lineColor];
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
    [self setNeedsLayout];
}

- (void)setGradientLocations:(NSArray *)gradientLocations
{
    _gradientLocations = gradientLocations;
    [self setScaledGradientLocations];
}

- (void)setMinValue:(CGFloat)minValue
{
    _minValue = minValue;
    [self setScaledGradientLocations];
}

- (void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    [self setScaledGradientLocations];
}

- (void)setScaledGradientLocations
{
    if ([self.gradientLocations count] == 0) {
        return;
    }
    NSMutableArray *scaledLocations = [NSMutableArray array];
    CGFloat trueMinValue = [CHMathUtils trueMinValueWithMin:self.minValue max:self.maxValue
                                                     height:CGRectGetHeight(self.bounds)
                                               footerHeight:self.footerHeight];
    for (NSNumber *location in self.gradientLocations) {
        CGFloat scaledValue = [CHMathUtils relativeValue:[location floatValue]
                                                     min:trueMinValue
                                                     max:self.maxValue];
        // Clamp between 0 and 1
        scaledValue = MIN(MAX(scaledValue, 0), 1);
        [scaledLocations addObject:@(scaledValue)];
    }
    self.lineView.locations = scaledLocations;
}

- (void)setGradientColors:(NSArray *)gradientColors
{
    if ([gradientColors count] == 0) {
        return;
    }
    _gradientColors = gradientColors;
    self.lineView.colors = gradientColors;
}


@end
