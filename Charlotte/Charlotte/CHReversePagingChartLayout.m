//
//  CHReversePagingChartLayout.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHReversePagingChartLayout.h"
#import "CHChartView.h"

@implementation CHReversePagingChartLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.headerReferenceSize = CGSizeZero;
        self.footerReferenceSize = CGSizeZero;
        self.headerHeight = 30;
        self.footerHeight = 30;
    }
    return self;
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

    // add missing attributes for header and footer
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *headerAttributes =
            [self layoutAttributesForSupplementaryViewOfKind:CHChartViewElementKindHeader atIndexPath:indexPath];
        UICollectionViewLayoutAttributes *footerAttributes =
            [self layoutAttributesForSupplementaryViewOfKind:CHChartViewElementKindFooter atIndexPath:indexPath];
        [attributesArray addObject:headerAttributes];
        [attributesArray addObject:footerAttributes];
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
    if (elementKind == CHChartViewElementKindHeader || elementKind == CHChartViewElementKindFooter) {
        NSInteger section = indexPath.section;
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1))
                                                             inSection:section];
        UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
        UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];
        CGPoint origin = attributes.frame.origin;
        CGSize size = attributes.frame.size;
        size.width = (firstCellAttrs.size.width*numberOfItemsInSection) + self.sectionInset.left + self.sectionInset.right;
        origin.x = firstCellAttrs.frame.origin.x - self.sectionInset.left;
        if (attributes.representedElementKind == CHChartViewElementKindHeader) {
            origin.y = 0;
            size.height = self.headerHeight;
        }
        else if (attributes.representedElementKind == CHChartViewElementKindFooter) {
            origin.y = self.collectionView.bounds.size.height - self.footerHeight;
            size.height = self.footerHeight;
        }
        attributes.frame = (CGRect){ .origin = origin, .size = size };
        attributes.zIndex = firstCellAttrs.zIndex + 1;
    }
    return attributes;
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
//
//    if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
//        CGPoint origin = attributes.frame.origin;
//        origin.x = origin.x - self.headerReferenceSize.width;
//        attributes.frame = (CGRect){ .origin = origin, .size = attributes.frame.size };
//    }
//
//    return attributes;
//}

@end
