//
//  CHChartRegionSpec.m
//  Charlotte
//
//  Created by Ben Guo on 10/28/14.
//  Copyright 2014 Project Florida. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CHChartRegion.h"

SPEC_BEGIN(CHChartRegionSpec)

describe(@"CHChartRegion", ^{

    describe(@"regionWithRange:color:", ^{
        it(@"should return a region with the correct range and color", ^{
            NSRange range = NSMakeRange(3, 1337);
            UIColor *color = [UIColor blueColor];
            CHChartRegion *sut = [CHChartRegion regionWithRange:range color:color];
            [[theValue(sut.range) should] equal:theValue(range)];
            [[sut.color should] equal:color];
        });
    });

});

SPEC_END
