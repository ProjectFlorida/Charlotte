//
//  CHGradientView.m
//  Charlotte
//
//  Created by Ben Guo on 10/21/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHGradientView.h"

@implementation CHGradientView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    self.opaque = NO;
    _colors = nil;
    _locations = nil;
    _startPoint = CGPointMake(0.5, 0.0);
    _endPoint = CGPointMake(0.5, 1.0);
}

- (void)drawRect:(CGRect)rect {
    NSInteger count = self.colors.count;
    if (!count) {
        return;
    }
    if (self.locations.count != count) {
        self.locations = @[];
        CGFloat width = 1.0 / (count - 1);
        for (int i = 0; i < count; i++) {
            self.locations = [self.locations arrayByAddingObject:@(width * i)];
        }
    }

    CGFloat locations[count];
    for (int i = 0; i < count; i++) {
        locations[i] = [self.locations[i] floatValue];
    }
    CGFloat components[count*4];
    for (int i = 0; i < count; i++) {
        UIColor *color = self.colors[i];
        CGFloat red, green, blue, alpha;
        BOOL converted = [color getRed:&red green:&green blue:&blue alpha:&alpha];
        if (!converted) {
            return;
        }
        NSArray *rgba = @[@(red), @(green), @(blue), @(alpha)];
        for (int j = 0; j < 4; j++) {
            components[(i*4)+j] = [rgba[j] floatValue];
        }
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient;
    CGColorSpaceRef rgbColorspace;

    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, count);

    CGSize currentSize = self.bounds.size;
    CGPoint startPoint = CGPointMake(self.startPoint.x * currentSize.width,
                                     self.startPoint.y * currentSize.height);
    CGPoint endPoint = CGPointMake(self.endPoint.x * currentSize.width,
                                   self.endPoint.y * currentSize.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);

    CGGradientRelease(gradient);

    CGColorSpaceRelease(rgbColorspace);
}

#pragma mark - Setters

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
    [self setNeedsDisplay];
}

- (void)setLocations:(NSArray *)locations
{
    _locations = locations;
    [self setNeedsDisplay];
}

- (void)setStartPoint:(CGPoint)startPoint
{
    _startPoint = startPoint;
    [self setNeedsDisplay];
}

- (void)setEndPoint:(CGPoint)endPoint
{
    _endPoint = endPoint;
    [self setNeedsDisplay];
}

@end
