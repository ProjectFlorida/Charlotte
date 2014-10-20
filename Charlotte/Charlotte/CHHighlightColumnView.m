//
//  CHHighlightColumnView.m
//  Charlotte
//
//  Created by Ben Guo on 10/20/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHHighlightColumnView.h"

@interface CHHighlightColumnView ()

@end

@implementation CHHighlightColumnView

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

- (void)drawRect:(CGRect)rect
{
    // TODO: add parameters.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    CGGradientRef gradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 4;
    CGFloat locations[4] = { 0.0, 0.35, 0.65, 1.0 };
    CGFloat components[16] = {
        1.0, 1.0, 1.0, 0.4,
        1.0, 1.0, 1.0, 0.15,
        1.0, 1.0, 1.0, 0.15,
        1.0, 1.0, 1.0, 0.4
    };

    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);

    CGRect currentBounds = self.bounds;
    CGPoint leftCenter = CGPointMake(0, CGRectGetMidY(currentBounds));
    CGPoint rightCenter = CGPointMake(CGRectGetMaxX(currentBounds), CGRectGetMidY(currentBounds));
    CGContextDrawLinearGradient(currentContext, gradient, leftCenter, rightCenter, 0);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(rgbColorspace);
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
}

@end
