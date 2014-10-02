//
//  CHChartPageSpec.m
//  Charlotte
//
//  Created by Ben Guo on 10/2/14.
//  Copyright 2014 Project Florida. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CHChartPage.h"

SPEC_BEGIN(CHChartPageSpec)

describe(@"CHChartPage", ^{
    describe(@"init", ^{
        it(@"should set correct initial values", ^{
            CHChartPage *sut = [[CHChartPage alloc] init];
            [[theValue(sut.minValue) should] equal:theValue(0)];
            [[theValue(sut.maxValue) should] equal:theValue(0)];
            [[sut.values should] equal:@[]];
        });
    });
});

SPEC_END
