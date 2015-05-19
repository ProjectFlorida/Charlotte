//
//  UIView+Charlotte.m
//  Charlotte
//
//  Created by Ben Guo on 4/2/15.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "UIView+Charlotte.h"

@implementation UIView (Charlotte)

- (UIColor *)ch_colorAtPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo info = (CGBitmapInfo)kCGImageAlphaPremultipliedLast;
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, info);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [self.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0
                                     green:pixel[1]/255.0
                                      blue:pixel[2]/255.0
                                     alpha:pixel[3]/255.0];
    return color;
}

@end
