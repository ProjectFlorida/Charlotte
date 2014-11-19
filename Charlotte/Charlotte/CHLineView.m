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
#import "CHChartRegion.h"

NSString *const kCHLineViewReuseId = @"CHLineView";

@interface CHLineView ()

@property (nonatomic, assign) NSInteger leftInset;
@property (nonatomic, assign) NSInteger rightInset;
@property (nonatomic, strong) NSArray *lineValues;
@property (nonatomic, strong) NSArray *scatterPoints;
@property (nonatomic, strong) NSMutableArray *scatterPointViews;
@property (nonatomic, strong) CAShapeLayer *lineMaskLayer;
@property (nonatomic, strong) CAShapeLayer *regionMaskLayer;
@property (nonatomic, strong) CAShapeLayer *lineBackgroundLayer;
@property (nonatomic, strong) CHGradientView *lineView;
@property (nonatomic, strong) NSArray *regions;
@property (nonatomic, strong) UIView *regionContainerView;
@property (nonatomic, strong) UIView *scatterPointContainerView;
@property (nonatomic, assign) BOOL isAnimating;

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
        _regionEntranceAnimationDuration = 0.4;
        _isAnimating = NO;

        _lineColor = [UIColor whiteColor];
        _lineTintColor = nil;
        _lineWidth = 4;
        _lineInsetAlpha = 0.1;

        _lineMaskLayer = [CAShapeLayer layer];
        _lineMaskLayer.lineCap = kCALineCapRound;
        _lineMaskLayer.lineWidth = _lineWidth;
        _lineMaskLayer.fillColor = nil;
        _lineMaskLayer.strokeColor = [UIColor whiteColor].CGColor;

        _lineBackgroundLayer = [CAShapeLayer layer];
        _lineBackgroundLayer.shadowOpacity = 0;
        _lineBackgroundLayer.shadowRadius = 1;
        _lineBackgroundLayer.shadowOffset = CGSizeMake(0, 1);
        _lineBackgroundLayer.lineCap = _lineMaskLayer.lineCap;
        _lineBackgroundLayer.lineWidth = _lineMaskLayer.lineWidth;
        _lineBackgroundLayer.fillColor = nil;
        _lineBackgroundLayer.strokeColor = [_lineColor colorWithAlphaComponent:_lineInsetAlpha].CGColor;

        _regionMaskLayer = [CAShapeLayer layer];
        _regionMaskLayer.frame = self.bounds;

        _lineView = [[CHGradientView alloc] initWithFrame:CGRectZero];
        _lineView.colors = @[_lineColor, _lineColor];
        _lineView.startPoint = CGPointMake(0, 0.5);
        _lineView.endPoint = CGPointMake(1, 0.5);
        _lineView.layer.mask = _lineMaskLayer;

        _regionContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _regionContainerView.layer.mask = _regionMaskLayer;
        _scatterPointContainerView = [[UIView alloc] initWithFrame:CGRectZero];

        [self addSubview:_scatterPointContainerView];
        [self addSubview:_regionContainerView];
        [self.layer addSublayer:_lineBackgroundLayer];
        [self addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize currentSize = self.bounds.size;
    self.lineView.frame = self.bounds;
    self.lineBackgroundLayer.frame = self.bounds;
    self.lineMaskLayer.frame = self.bounds;
    self.regionMaskLayer.frame = self.bounds;
    self.regionContainerView.frame = CGRectMake(0, 0,
                                                currentSize.width,
                                                currentSize.height - self.footerHeight - 2);
    self.scatterPointContainerView.frame = self.bounds;
    [self drawLineWithValues:self.lineValues regions:self.regions
                   leftInset:self.leftInset rightInset:self.rightInset animated:NO];
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
    [self drawLineWithValues:self.lineValues regions:self.regions leftInset:self.leftInset rightInset:self.rightInset
                    animated:animated];
    [self drawScatterPoints:self.scatterPoints animated:animated];
    [self drawInteractivePoint:self.interactivePoint animated:animated];
    if (completion) {
        completion();
    }
}

- (void)drawLineWithValues:(NSArray *)values regions:(NSArray *)regions
                 leftInset:(NSInteger)leftInset rightInset:(NSInteger)rightInset animated:(BOOL)animated;
{
    self.lineValues = values;
    self.regions = regions;
    self.leftInset = leftInset;
    self.rightInset = rightInset;

    NSInteger count = values.count;
    if (!count) {
        return;
    }
    // draw line
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        CGFloat x = [self xPositionWithIndex:i inCount:count];
        CGFloat value = [values[i] floatValue];
        CGFloat scaledValue = [CHChartView scaledValue:value minValue:self.minValue maxValue:self.maxValue];
        CGFloat y = [self yPositionWithRelativeValue:scaledValue];
        NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [points addObject:pointValue];
    }
    UIBezierPath *fullPath = [UIBezierPath interpolateCGPointsWithHermite:points closed:NO];
    NSArray *insetPoints = [points subarrayWithRange:NSMakeRange(self.leftInset,
                                                                 count - self.leftInset - self.rightInset)];
    UIBezierPath *insetPath = [UIBezierPath interpolateCGPointsWithHermite:insetPoints closed:NO];
    [self.lineMaskLayer setPath:insetPath.CGPath];
    [self.lineBackgroundLayer setPath:fullPath.CGPath];

    self.regionContainerView.alpha = 0;
    if (animated) {
        [CATransaction begin];
        self.isAnimating = YES;
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.lineDrawingAnimationDuration;
        pathAnimation.fromValue = @0;
        pathAnimation.toValue = @1;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        NSString *strokeEndAnimationKey = @"strokeEndAnimation";
        [CATransaction setCompletionBlock:^{
            [UIView animateWithDuration:self.regionEntranceAnimationDuration delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.regionContainerView.alpha = 1;
                             } completion:^(BOOL finished) {
                                 self.isAnimating = NO;
                             }];
        }];
        [self.lineMaskLayer addAnimation:pathAnimation forKey:strokeEndAnimationKey];
        [self.lineBackgroundLayer addAnimation:pathAnimation forKey:strokeEndAnimationKey];
        [CATransaction commit];
    }
    else if (!self.isAnimating) {
        self.regionContainerView.alpha = 1;
    }

    // update mask layer
    CGPoint firstPoint = [points[0] CGPointValue];
    CGPoint lastPoint = [[points lastObject] CGPointValue];
    [fullPath addLineToPoint:CGPointMake(lastPoint.x, self.bounds.size.height)];
    [fullPath addLineToPoint:CGPointMake(firstPoint.x, self.bounds.size.height)];
    [fullPath closePath];
    [self.regionMaskLayer setPath:fullPath.CGPath];

    // draw regions
    if (!regions) {
        return;
    }
    else {
        // reset region view
        self.regions = regions;
        for (UIView *subview in self.regionContainerView.subviews) {
            [subview removeFromSuperview];
        }

        for (CHChartRegion *region in self.regions) {
            CGPoint firstPoint = [points[region.range.location] CGPointValue];
            CGPoint lastPoint = [points[region.range.location + region.range.length] CGPointValue];
            CGRect regionFrame = CGRectMake(firstPoint.x, 0,
                                            lastPoint.x - firstPoint.x,
                                            self.regionContainerView.bounds.size.height);
            CHGradientView *regionView = [[CHGradientView alloc] initWithFrame:regionFrame];
            regionView.locations = @[@0.8, @1.0];
            regionView.colors = @[region.color,
                                  region.tintColor];
            [self.regionContainerView addSubview:regionView];
        }
    }

    self.regionContainerView.alpha = 0;
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
    self.lineBackgroundLayer.lineWidth = _lineWidth;
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
    self.lineBackgroundLayer.strokeColor = [_lineColor colorWithAlphaComponent:_lineInsetAlpha].CGColor;
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

- (void)setLineInsetAlpha:(CGFloat)lineInsetAlpha
{
    _lineInsetAlpha = lineInsetAlpha;
    self.lineBackgroundLayer.strokeColor = [self.lineColor colorWithAlphaComponent:_lineInsetAlpha].CGColor;
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
    [self setNeedsLayout];
}




@end
