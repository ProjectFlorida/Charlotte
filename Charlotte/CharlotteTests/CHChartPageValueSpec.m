//
//  CHChartPageValueSpec.m
//  Charlotte
//
//  Created by Ben Guo on 10/2/14.
//  Copyright 2014 Project Florida. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CHChartPageValue.h"


SPEC_BEGIN(CHChartPageValueSpec)

describe(@"CHChartPageValue", ^{
    describe(@"init", ^{
        it(@"should set correct initial values", ^{
            CHChartPageValue *sut = [[CHChartPageValue alloc] init];
            [[theValue(sut.value) should] equal:theValue(0)];
            [[theValue(sut.type) should] equal:theValue(CHChartPageValueTypeComplete)];
        });
    });
});

SPEC_END
