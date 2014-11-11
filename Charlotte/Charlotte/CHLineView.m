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

@property (nonatomic, strong) NSArray *lineValues;
@property (nonatomic, strong) NSArray *scatterPoints;
@property (nonatomic, strong) NSMutableArray *scatterPointViews;
@property (nonatomic, strong) CAShapeLayer *lineMaskLayer;
@property (nonatomic, strong) CAShapeLayer *regionMaskLayer;
@property (nonatomic, strong) CAShapeLayer *lineShadowLayer;
@property (nonatomic, strong) CHGradientView *lineView;
@property (nonatomic, strong) NSArray *regions;
@property (nonatomic, strong) UIView *regionsView;

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

        _lineColor = [UIColor whiteColor];
        _lineTintColor = nil;
        _lineWidth = 4;

        _lineMaskLayer = [CAShapeLayer layer];
        _lineMaskLayer.lineCap = kCALineCapRound;
        _lineMaskLayer.lineWidth = _lineWidth;
        _lineMaskLayer.fillColor = nil;
        _lineMaskLayer.strokeColor = [UIColor whiteColor].CGColor;

        _lineShadowLayer = [CAShapeLayer layer];
        _lineShadowLayer.shadowOpacity = 0;
        _lineShadowLayer.shadowRadius = 1;
        _lineShadowLayer.shadowOffset = CGSizeMake(0, 1);
        _lineShadowLayer.lineCap = _lineMaskLayer.lineCap;
        _lineShadowLayer.lineWidth = _lineMaskLayer.lineWidth;
        _lineShadowLayer.fillColor = nil;
        _lineShadowLayer.strokeColor = [UIColor whiteColor].CGColor;

        _regionMaskLayer = [CAShapeLayer layer];
        _regionMaskLayer.frame = self.bounds;

        _lineView = [[CHGradientView alloc] initWithFrame:CGRectZero];
        _lineView.colors = @[_lineColor, _lineColor];
        _lineView.startPoint = CGPointMake(0, 0.5);
        _lineView.endPoint = CGPointMake(1, 0.5);
        _lineView.layer.mask = _lineMaskLayer;

        _regionsView = [[UIView alloc] initWithFrame:CGRectZero];
        _regionsView.layer.mask = _regionMaskLayer;

        [self addSubview:_regionsView];
        [self.layer addSublayer:_lineShadowLayer];
        [self addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize currentSize = self.bounds.size;
    self.lineView.frame = self.bounds;
    self.lineShadowLayer.frame = self.bounds;
    self.lineMaskLayer.frame = self.bounds;
    self.regionMaskLayer.frame = self.bounds;
    self.regionsView.frame = CGRectMake(0, 0,
                                        currentSize.width,
                                        currentSize.height - self.footerHeight - 2);
    [self drawLineWithValues:self.lineValues regions:self.regions];
    [self drawScatterPoints:self.scatterPoints];
    [self drawInteractivePoint:self.interactivePoint];
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
    // TODO: animate range change
    [self drawLineWithValues:self.lineValues regions:self.regions];
    [self drawScatterPoints:self.scatterPoints];
    [self drawInteractivePoint:self.interactivePoint];
    if (completion) {
        completion();
    }
}

- (void)drawLineWithValues:(NSArray *)values regions:(NSArray *)regions
{
    _lineValues = values;
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
    UIBezierPath *path = [UIBezierPath interpolateCGPointsWithHermite:points closed:NO];
    [self.lineMaskLayer setPath:path.CGPath];
    [self.lineShadowLayer setPath:path.CGPath];

    // update mask layer
    CGPoint firstPoint = [points[0] CGPointValue];
    CGPoint lastPoint = [[points lastObject] CGPointValue];
    [path addLineToPoint:CGPointMake(lastPoint.x, self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(firstPoint.x, self.bounds.size.height)];
    [path closePath];
    [self.regionMaskLayer setPath:path.CGPath];

    if (!regions) {
        return;
    }
    else {
        // reset region view
        self.regions = regions;
        for (UIView *subview in self.regionsView.subviews) {
            [subview removeFromSuperview];
        }

        for (CHChartRegion *region in self.regions) {
            CGPoint firstPoint = [points[region.range.location] CGPointValue];
            CGPoint lastPoint = [points[region.range.location + region.range.length] CGPointValue];
            CGRect regionFrame = CGRectMake(firstPoint.x, 0,
                                            lastPoint.x - firstPoint.x,
                                            self.regionsView.bounds.size.height);
            CHGradientView *regionView = [[CHGradientView alloc] initWithFrame:regionFrame];
            regionView.locations = @[@0.8, @1.0];
            regionView.colors = @[region.color,
                                  region.tintColor];
            [self.regionsView addSubview:regionView];
        }
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

- (void)drawScatterPoints:(NSArray *)points
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
        [self insertSubview:view atIndex:0];
        [self.scatterPointViews addObject:view];
    }
}

- (void)resetInteractivePoint
{
    if (self.interactivePoint) {
        [self.interactivePoint.view removeFromSuperview];
    }
    self.interactivePoint = nil;
}

- (void)drawInteractivePoint:(CHInteractivePoint *)point
{
    [self resetInteractivePoint];
    self.interactivePoint = point;
    CGFloat scaledValue = [CHChartView scaledValue:point.value minValue:self.minValue maxValue:self.maxValue];
    CGFloat x = self.bounds.size.width * point.relativeXPosition;
    CGFloat y = [self yPositionWithRelativeValue:scaledValue];
    self.interactivePoint.view.center = CGPointMake(x, y);
    [self addSubview:self.interactivePoint.view];
}

#pragma mark - Setters

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.lineMaskLayer.lineWidth = _lineWidth;
    self.lineShadowLayer.lineWidth = _lineWidth;
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

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
    [self setNeedsLayout];
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


@end
