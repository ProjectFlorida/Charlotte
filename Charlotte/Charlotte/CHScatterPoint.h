//
//  CHScatterPoint.h
//  Charlotte
//
//  Created by Ben Guo on 10/28/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

@import UIKit;

@interface CHScatterPoint : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat relativeXPosition;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat radius;

+ (instancetype)pointWithValue:(CGFloat)val relativeXPosition:(CGFloat)x color:(UIColor *)color radius:(CGFloat)radius;

@end
