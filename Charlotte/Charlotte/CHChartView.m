//
//  CHChartView.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartView.h"
#import "CHChartPointCell.h"
#import "CHChartHeaderView.h"
#import "CHChartFooterView.h"
#import "CHReversePagingChartLayout.h"

NSString *const kCHChartPointCellReuseId = @"ChartPointCell";
NSString *const kCHChartHeaderViewReuseId = @"ChartHeaderView";
NSString *const kCHChartFooterViewReuseId = @"ChartFooterView";
NSString *const CHChartViewElementKindHeader = @"ChartViewElementKindHeader";
NSString *const CHChartViewElementKindFooter = @"ChartViewElementKindFooter";

@interface CHChartView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) CHReversePagingChartLayout *collectionViewLayout;

@end

@implementation CHChartView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _collectionViewLayout = [[CHReversePagingChartLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor magentaColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[CHChartPointCell class] forCellWithReuseIdentifier:kCHChartPointCellReuseId];
    [_collectionView registerClass:[CHChartHeaderView class]
        forSupplementaryViewOfKind:CHChartViewElementKindHeader
               withReuseIdentifier:kCHChartHeaderViewReuseId];
    [_collectionView registerClass:[CHChartFooterView class]
        forSupplementaryViewOfKind:CHChartViewElementKindFooter
               withReuseIdentifier:kCHChartFooterViewReuseId];

    [self addSubview:_collectionView];
    NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    [self addConstraints:constraintsH];
    [self addConstraints:constraintsV];
}

- (void)layoutSubviews
{
    [self.collectionViewLayout invalidateLayout];
    [super layoutSubviews];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.dataSource numberOfPagesInChartView:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource chartView:self numberOfPointsInPage:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCHChartPointCellReuseId
                                                                           forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == CHChartViewElementKindHeader) {
        CHChartHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:CHChartViewElementKindHeader
                                                                       withReuseIdentifier:kCHChartHeaderViewReuseId
                                                                              forIndexPath:indexPath];
        header.backgroundColor = [UIColor blueColor];
        view = header;
    }
    else if (kind == CHChartViewElementKindFooter) {
        CHChartFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:CHChartViewElementKindFooter
                                                                       withReuseIdentifier:kCHChartFooterViewReuseId
                                                                              forIndexPath:indexPath];
        footer.backgroundColor = [UIColor blueColor];
        view = footer;
    }
    return view;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat height = self.collectionView.bounds.size.height;
    NSInteger pageCount = [self.dataSource chartView:self numberOfPointsInPage:indexPath.section];
    CGFloat sectionInsetWidth = layout.sectionInset.left + layout.sectionInset.right;
    CGFloat width = (collectionView.bounds.size.width - sectionInsetWidth) / pageCount;
    return CGSizeMake(width, height);
}



@end
