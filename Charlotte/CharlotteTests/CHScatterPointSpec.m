//
//  CHScatterPointSpec.m
//  Charlotte
//
//  Created by Ben Guo on 10/28/14.
//  Copyright 2014 Sum Labs. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CHScatterPoint.h"

SPEC_BEGIN(CHScatterPointSpec)

describe(@"CHScatterPoint", ^{

    describe(@"pointWithValue:relativeXPosition...", ^{
        it(@"should return a correctly configured point", ^{
            CGFloat value = 1337;
            CGFloat relativeX = 0.3;
            UIColor *color = [UIColor magentaColor];
            CGFloat radius = 3;
            CHScatterPoint *sut = [CHScatterPoint pointWithValue:value relativeXPosition:relativeX
                                                           color:color radius:radius];
            [[theValue(sut.value) should] equal:theValue(value)];
            [[theValue(sut.relativeXPosition) should] equal:theValue(relativeX)];
            [[sut.color should] equal:color];
            [[theValue(sut.radius) should] equal:theValue(radius)];
        });
    });

});

SPEC_END
