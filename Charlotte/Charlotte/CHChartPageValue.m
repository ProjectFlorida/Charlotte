//
//  CHChartPageValue.m
//  Pods
//
//  Created by Ben Guo on 10/2/14.
//
//

#import "CHChartPageValue.h"

@implementation CHChartPageValue

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = CHChartPageValueTypeComplete;
        self.value = 0;
    }
    return self;
}

@end
