//
//  CHPagingChartFlowLayout.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHPagingChartFlowLayout.h"
#import "CHChartView.h"
#import "CHPointCell.h"

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
        self.headerHeight = 30;
        self.footerHeight = 30;
        self.pageInset = UIEdgeInsetsMake(0, 40, 0, 40);
    }
    return self;
}

- (void)setHeaderHeight:(CGFloat)headerHeight
{
    _headerHeight = headerHeight;
    [self invalidateLayout];
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

    // add missing attributes for header and footer views
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *headerAttributes =
            [self layoutAttributesForSupplementaryViewOfKind:CHSupplementaryElementKindHeader atIndexPath:indexPath];
        UICollectionViewLayoutAttributes *footerAttributes =
            [self layoutAttributesForSupplementaryViewOfKind:CHSupplementaryElementKindFooter atIndexPath:indexPath];
        [attributesArray addObject:footerAttributes];
        [attributesArray addObject:headerAttributes];       
    }];

    // shift cells to the right by the layout's left edge page inset
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
    if (elementKind == CHSupplementaryElementKindHeader ||
        elementKind == CHSupplementaryElementKindFooter) {

        NSInteger section = indexPath.section;
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
        CGPoint origin = attributes.frame.origin;
        CGSize size = attributes.frame.size;
        origin.x = firstCellAttrs.frame.origin.x - self.sectionInset.left + self.pageInset.left;
        size.width = (firstCellAttrs.size.width*numberOfItemsInSection) + self.sectionInset.left + self.sectionInset.right;

        if (elementKind == CHSupplementaryElementKindHeader) {
            origin.y = 0;
            size.height = self.headerHeight;
        }
        else if (elementKind == CHSupplementaryElementKindFooter) {
            origin.y = self.collectionViewContentSize.height - self.footerHeight;
            size.height = self.footerHeight;
        }

        attributes.frame = (CGRect){ .origin = origin, .size = size };
        attributes.zIndex = firstCellAttrs.zIndex + 1;
    }
    return attributes;
}


@end
