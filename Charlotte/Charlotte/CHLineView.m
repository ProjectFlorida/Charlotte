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

@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) UIView *regionsView;

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
        _regionsView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_regionsView];

        _lineLayer = [CAShapeLayer layer];
        _lineLayer.lineCap = kCALineCapRound;
        _lineLayer.lineWidth = 4;
        _lineLayer.fillColor = nil;
        _lineLayer.strokeColor = [UIColor whiteColor].CGColor;
        _lineLayer.opacity = 1;
        _lineLayer.frame = self.bounds;
        [self.layer addSublayer:_lineLayer];

        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillColor = [UIColor greenColor].CGColor;
        _maskLayer.opacity = 0.5;
        _maskLayer.frame = self.bounds;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _regionsView.frame = self.bounds;
    [self drawLineWithValues:self.values];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [_lineLayer setPath:nil];
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
    [self drawLineWithValues:self.values];
}

- (void)drawLineWithValues:(NSArray *)values regions:(NSDictionary *)regions
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
    [self.lineLayer setPath:path.CGPath];

    CGPoint firstPoint = [points[0] CGPointValue];
    CGPoint lastPoint = [[points lastObject] CGPointValue];
    [path addLineToPoint:CGPointMake(lastPoint.x, self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(firstPoint.x, self.bounds.size.height)];
    [path closePath];
    [self.maskLayer setPath:path.CGPath];
    self.regionsView.layer.mask = self.maskLayer;

    if (!regions) {
        return;
    }
    else {
        NSArray *rangeValues =
        [regions.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSValue *v1, NSValue *v2) {
            if (v1.rangeValue.location < v2.rangeValue.location) {
                return NSOrderedAscending;
            }
            else if (v1.rangeValue.location > v2.rangeValue.location) {
                return NSOrderedDescending;
            }
            else {
                return NSOrderedSame;
            }
        }];
        for (NSValue *rangeValue in rangeValues) {
            NSRange range = rangeValue.rangeValue;
            UIColor *color = regions[rangeValue];
            CGPoint firstPoint = [points[range.location] CGPointValue];
            CGPoint lastPoint = [points[range.location + range.length] CGPointValue];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(firstPoint.x, 0,
                                                                    lastPoint.x - firstPoint.x,
                                                                    self.bounds.size.height)];
            view.backgroundColor = color;
            [self.regionsView addSubview:view];
        }
    }
}

- (void)drawLineWithValues:(NSArray *)values
{
    [self drawLineWithValues:values regions:nil];
}


#pragma mark - Setters

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
}

@end
