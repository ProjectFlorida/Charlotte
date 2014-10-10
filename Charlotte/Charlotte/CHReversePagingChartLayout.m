//
//  CHReversePagingChartLayout.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHReversePagingChartLayout.h"

@implementation CHReversePagingChartLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
    }
    return self;
}

//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    return @[];
//}

@end
