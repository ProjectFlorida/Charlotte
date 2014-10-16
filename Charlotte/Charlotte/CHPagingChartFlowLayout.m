//
//  CHPagingChartFlowLayout.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHPagingChartFlowLayout.h"
#import "CHChartView.h"

@implementation CHPagingChartFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.headerReferenceSize = CGSizeZero;
        self.footerReferenceSize = CGSizeZero;
        self.headerHeight = 30;
        self.pageInset = UIEdgeInsetsMake(0, 30, 0, 30);
    }
    return self;
}

- (void)setHeaderHeight:(CGFloat)headerHeight
{
    _headerHeight = headerHeight;
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

    // add missing attributes for header
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *headerAttributes =
            [self layoutAttributesForSupplementaryViewOfKind:CHSupplementaryElementKindHeader atIndexPath:indexPath];
        [attributesArray addObject:headerAttributes];

        for (int i = 0; i < [self.collectionView numberOfItemsInSection:idx]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:idx];
            UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [attributesArray addObject:itemAttributes];
        }
    }];

    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            CGPoint origin = attributes.frame.origin;
            CGSize size = attributes.frame.size;
            origin.x = origin.x + self.pageInset.left;
            origin.y = self.headerHeight;
            size.height -= self.headerHeight;
            attributes.frame = (CGRect){ .origin = origin, .size = size };
        }
    }

    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    if (!attributes) {
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    }
    if (elementKind == CHSupplementaryElementKindHeader) {
        NSInteger section = indexPath.section;
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
        CGPoint origin = attributes.frame.origin;
        CGSize size = attributes.frame.size;
        size.width = (firstCellAttrs.size.width*numberOfItemsInSection) + self.sectionInset.left + self.sectionInset.right;
        origin.x = firstCellAttrs.frame.origin.x - self.sectionInset.left + self.pageInset.left;
        origin.y = 0;
        size.height = self.headerHeight;
        attributes.frame = (CGRect){ .origin = origin, .size = size };
        attributes.zIndex = firstCellAttrs.zIndex + 1;
    }
    return attributes;
}


@end
