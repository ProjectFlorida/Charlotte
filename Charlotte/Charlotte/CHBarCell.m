//
//  CHBarCell.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHBarCell.h"
#import "CHChartView.h"
#import "CHPointCellSubclass.h"

NSString *const kCHBarCellReuseId = @"CHBarCell";
CGFloat const kCHZeroValueAnimationDuration = 0.2;

@interface CHBarCell ()

/// the width of the bar view relative to the bar cell's width
@property (nonatomic, assign) CGFloat relativeBarWidth;
@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation CHBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _relativeBarWidth = 0.5;
        _barColor = [UIColor whiteColor];
        _borderColor = [UIColor whiteColor];
        _tintColor = [UIColor whiteColor];
        _borderWidth = 2;
        _borderDashPattern = @[@2, @2];

        _borderLayer = [CAShapeLayer layer];
        _borderLayer.lineWidth = _borderWidth;
        _borderLayer.fillColor = nil;
        _borderLayer.strokeColor = _borderColor.CGColor;
        _borderLayer.lineDashPattern = _borderDashPattern;

        [self.pointView.layer addSublayer:_borderLayer];
        self.pointView.locations = @[@0, @1];
        self.pointView.startPoint = CGPointMake(0.5, 0);
        self.pointView.endPoint = CGPointMake(0.5, 1);
        self.pointView.colors = @[_barColor, _tintColor];
        self.pointView.backgroundColor = [UIColor clearColor];
        self.pointView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.borderLayer.frame, self.pointView.bounds)) {
        self.borderLayer.frame = self.pointView.bounds;
        self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.pointView.bounds
                                                           cornerRadius:self.pointView.bounds.size.width/2.0].CGPath;
    }
}

- (void)reload
{
    [super reload];
    self.borderLayer.frame = self.pointView.bounds;
    self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.pointView.bounds
                                                       cornerRadius:self.pointView.bounds.size.width/2.0].CGPath;
}

- (CGRect)pointViewFrame
{
    CGRect frame = [super pointViewFrame];
    CGFloat height = self.bounds.size.height;
    CGFloat barWidth = self.relativeBarWidth * self.bounds.size.width;
    // clamp out of range bars so that they're always displayed
    // TODO: add a switch for this behavior
    CGFloat maxY = height - self.footerHeight - barWidth;

    // top of bar should align with value (rather than center of point)
    frame.origin.y += barWidth/2.0;
    CGFloat barHeight = MAX(height - self.footerHeight - frame.origin.y, barWidth);

    frame.origin.y = MIN(maxY, frame.origin.y);
    frame.size.height = barHeight;
    return frame;
}

#pragma mark - Setters

- (void)setBarColor:(UIColor *)barColor
{
    _barColor = barColor;
    self.pointView.colors = @[_barColor, self.tintColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.borderLayer.strokeColor = borderColor.CGColor;
}

- (void)setTintColor:(UIColor *)tintColor
{
    if (!tintColor) {
        _tintColor = self.barColor;
        self.pointView.colors = @[self.barColor, _tintColor];
    }
    else {
        _tintColor = tintColor;
        self.pointView.colors = @[self.barColor, tintColor];
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.borderLayer.lineWidth = borderWidth;
}

- (void)setBorderDashPattern:(NSArray *)borderDashPattern
{
    _borderDashPattern = borderDashPattern;
    self.borderLayer.lineDashPattern = borderDashPattern;
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    [super setFooterHeight:footerHeight];
    [self setNeedsLayout];
}

@end
