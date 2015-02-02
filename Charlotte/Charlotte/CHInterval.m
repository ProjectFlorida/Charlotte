//
//  CHInterval.m
//  Charlotte
//
//  Created by Ben Guo on 1/30/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import "CHInterval.h"

@interface CHInterval ()

@property (nonatomic, readwrite) NSRange range;
@property (nonatomic, strong, readwrite) UIColor *color;

@end

@implementation CHInterval

+ (CHInterval *)intervalWithRange:(NSRange)range color:(UIColor *)color
{
    CHInterval *interval = [[CHInterval alloc] init];
    interval.range = range;
    interval.color = color;
    return interval;
}

- (id)copyWithZone:(NSZone *)zone
{
    CHInterval *copy = [[[self class] alloc] init];
    if (copy) {
        copy.range = self.range;
        copy.color = [self.color copyWithZone:zone];
    }
    return copy;
}

@end
