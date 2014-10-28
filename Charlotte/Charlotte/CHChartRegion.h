//
//  CHChartRegion.h
//  Charlotte
//
//  Created by Ben Guo on 10/22/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

@import UIKit;

@interface CHChartRegion : NSObject

@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) UIColor *color;

+ (instancetype)regionWithRange:(NSRange)range color:(UIColor *)color;

@end
