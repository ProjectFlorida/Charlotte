//
//  CHPagingLineChartFlowLayout.m
//  Charlotte
//
//  Created by Ben Guo on 10/16/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHPagingLineChartFlowLayout.h"
#import "CHLineChartView.h"

@implementation CHPagingLineChartFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsZero;
        self.pageInset = UIEdgeInsetsZero;
    }
    return self;
}

- (NSInteger)nearestIndexAtLocation:(CGPoint)location inPage:(NSInteger)page
{
    NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:page];
    UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
    CGFloat cellWidth = firstCellAttrs.size.width;
    NSInteger index = (location.x - self.pageInset.left) / cellWidth;
    return index;
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

    // add missing attributes for line views
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *lineAttributes =
        [self layoutAttributesForSupplementaryViewOfKind:CHSupplementaryElementKindLine atIndexPath:indexPath];
        [attributesArray addObject:lineAttributes];
    }];

    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    if (!attributes) {
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    }
    if (elementKind == CHSupplementaryElementKindLine) {
        NSInteger section = indexPath.section;
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
        CGPoint origin = attributes.frame.origin;
        CGSize size = attributes.frame.size;
        origin.x = firstCellAttrs.frame.origin.x + self.pageInset.left;
        origin.y = self.headerHeight;
        size.height = firstCellAttrs.bounds.size.height;
        size.width = (firstCellAttrs.size.width*numberOfItemsInSection);
        attributes.frame = (CGRect){ .origin = origin, .size = size };
        attributes.zIndex = firstCellAttrs.zIndex + 1;
    }
    return attributes;
}

@end
