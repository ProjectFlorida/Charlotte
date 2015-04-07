//
//  CHMathUtilsSpec.m
//  Charlotte
//
//  Created by Ben Guo on 4/7/15.
//  Copyright 2015 Project Florida. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CHMathUtils.h"

SPEC_BEGIN(CHMathUtilsSpec)

describe(@"CHMathUtils", ^{
    describe(@"relativeValue:min:max", ^{
        it(@"should return 0 when the value is at the min", ^{
            CGFloat result = [CHMathUtils relativeValue:2 min:2 max:4];
            [[theValue(result) should] equal:theValue(0)];
        });

        it(@"should return 1 when the value is at the max", ^{
            CGFloat result = [CHMathUtils relativeValue:4 min:2 max:4];
            [[theValue(result) should] equal:theValue(1)];
        });

        it(@"should return 0 when the min and max are equal", ^{
            CGFloat result = [CHMathUtils relativeValue:4 min:2 max:2];
            [[theValue(result) should] equal:theValue(0)];
        });

        it(@"should return 0.5 when the value is between the min and max", ^{
            CGFloat result = [CHMathUtils relativeValue:1 min:0 max:2];
            [[theValue(result) should] equal:theValue(0.5)];
        });
    });

    describe(@"yPositionWithValue:min:max:height", ^{
        it(@"should return 0 when min and max are equal", ^{
            CGFloat result = [CHMathUtils yPositionWithValue:0 min:0 max:0 height:0];
            [[theValue(result) should] equal:theValue(0)];
        });

        it(@"should return correct y positions", ^{
            CGFloat result = [CHMathUtils yPositionWithValue:-10 min:-10 max:10 height:20];
            [[theValue(result) should] equal:theValue(20)];

            result = [CHMathUtils yPositionWithValue:0 min:-10 max:10 height:20];
            [[theValue(result) should] equal:theValue(10)];

            result = [CHMathUtils yPositionWithValue:10 min:-10 max:10 height:20];
            [[theValue(result) should] equal:theValue(0)];
        });
    });
});

SPEC_END
