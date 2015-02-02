//
//  CHInterval.h
//  Charlotte
//
//  Created by Ben Guo on 1/30/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHInterval : NSObject <NSCopying>

@property (nonatomic, readonly) NSRange range;
@property (nonatomic, strong, readonly) UIColor *color;

+ (CHInterval *)intervalWithRange:(NSRange)range color:(UIColor *)color;

@end
