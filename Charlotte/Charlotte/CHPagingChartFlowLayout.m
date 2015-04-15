//
//  CHPagingChartFlowLayout.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHPagingChartFlowLayout.h"
#import "CHBarChartView.h"
#import "CHBarChartCell.h"

@implementation CHPagingChartFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.headerReferenceSize = CGSizeZero;
        self.footerReferenceSize = CGSizeZero;
        self.footerHeight = 30;
        self.pageInset = UIEdgeInsetsMake(0, 40, 0, 40);
    }
    return self;
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
    [self invalidateLayout];
}

- (void)setPageInset:(UIEdgeInsets)pageInset
{
    _pageInset = pageInset;
    [self invalidateLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];

    NSMutableIndexSet *sections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            [sections addIndex:attributes.indexPath.section];
        }
    }

    // shift cells to the right by the layout's left edge page inset
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            CGPoint origin = attributes.frame.origin;
            CGSize size = attributes.frame.size;
            origin.x = origin.x + self.pageInset.left;
            origin.y = 0;
            attributes.frame = (CGRect){ .origin = origin, .size = size };
        }
    }

    return attributesArray;
}

@end
