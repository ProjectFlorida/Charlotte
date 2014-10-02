//
//  CHChartPage.m
//  Charlotte
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartPage.h"

@implementation CHChartPage

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minValue = 0;
        self.maxValue = 0;
        self.values = @[];
    }
    return self;
}

@end
