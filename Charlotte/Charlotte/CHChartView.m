//
//  CHChartView.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartView.h"
#import "CHBarCell.h"
#import "CHChartHeaderView.h"
#import "CHPagingChartFlowLayout.h"
#import "CHGridlineView.h"

NSString *const CHChartViewElementKindHeader = @"ChartViewElementKindHeader";

@interface CHGridlineContainer : NSObject
@property (strong, nonatomic) CHGridlineView *view;
@property (assign, nonatomic) CGFloat value;
@property (strong, nonatomic) NSLayoutConstraint *centerYConstraint;
@end

@implementation CHGridlineContainer
@end

@interface CHChartView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) CHPagingChartFlowLayout *collectionViewLayout;
@property (assign, nonatomic) NSInteger currentPage;

// An array of CHGridlineContainer objects
@property (strong, nonatomic) NSMutableArray *gridlines;

@property (assign, nonatomic) CGFloat footerHeight;

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
    self.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];

    _currentPage = 0;
    _footerHeight = 30;
    _gridlines = [NSMutableArray array];
    _collectionViewLayout = [[CHPagingChartFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[CHBarCell class] forCellWithReuseIdentifier:kCHBarCellReuseId];
    [_collectionView registerClass:[CHChartHeaderView class]
        forSupplementaryViewOfKind:CHChartViewElementKindHeader
               withReuseIdentifier:kCHChartHeaderViewReuseId];
    [self addSubview:_collectionView];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];

    NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView, _scrollView);
    NSArray *collectionViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSArray *collectionViewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSDictionary *metrics = @{@"left": @(_collectionViewLayout.pageInset.left),
                              @"right": @(_collectionViewLayout.pageInset.right)};
    NSArray *scrollViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[_scrollView]-(right)-|"
                                                                   options:0
                                                                   metrics:metrics
                                                                     views:views];
    NSArray *scrollViewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    [self addConstraints:collectionViewH];
    [self addConstraints:collectionViewV];
    [self addConstraints:scrollViewH];
    [self addConstraints:scrollViewV];
}

- (CGFloat)multiplierForValue:(CGFloat)value minValue:(CGFloat)min maxValue:(CGFloat)max
{
    CGFloat relativeValue = (value - min)/(max - min);
    CGFloat viewHeight = self.bounds.size.height;
    CGFloat barHeight = viewHeight - self.footerHeight - self.collectionViewLayout.headerHeight;
    CGFloat relativeBarHeight = barHeight / viewHeight;
    return (1 - relativeValue*relativeBarHeight);
}

- (void)updateConstraints
{
    if (self.dataSource && !self.gridlines.count) {
        CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
        CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
        NSInteger count = [self.dataSource numberOfHorizontalGridlinesInChartView:self];
        for (int i = 0; i < count; i++) {
            CHGridlineContainer *gridline = [[CHGridlineContainer alloc] init];
            gridline.view = [[CHGridlineView alloc] initWithFrame:CGRectZero];
            gridline.view.translatesAutoresizingMaskIntoConstraints = NO;
            gridline.value = [self.dataSource chartView:self valueForHorizontalGridlineAtIndex:i];
            CGFloat multiplier = [self multiplierForValue:gridline.value minValue:min maxValue:max];
            [self insertSubview:gridline.view atIndex:0];
            NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[g]|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"g": gridline.view}];
            gridline.centerYConstraint = [NSLayoutConstraint constraintWithItem:gridline.view
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:multiplier
                                                                       constant:-self.footerHeight];
            [self addConstraint:gridline.centerYConstraint];
            [self addConstraints:constraintsH];
            [self.gridlines addObject:gridline];
        }
    }
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [self.collectionViewLayout invalidateLayout];
    [super layoutSubviews];
    [self.scrollView setContentSize:self.collectionView.contentSize];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return self.scrollView;
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated
{
    CGRect visible = self.scrollView.bounds;
    visible.origin.x = self.scrollView.bounds.size.width*page;
    [self.scrollView scrollRectToVisible:visible animated:animated];
    self.currentPage = (int)floorf(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width);
}

- (void)updateVisibleCells {
    CGFloat minValue = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat maxValue = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    for (CHBarCell *cell in self.collectionView.visibleCells) {
        [cell setMinValue:minValue maxValue:maxValue animated:YES];
    }
}

- (void)updateGridlines {
    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    NSInteger count = self.gridlines.count;
    for (int i = 0; i < count; i++) {
        CHGridlineContainer *gridline = self.gridlines[i];
        [self removeConstraint:gridline.centerYConstraint];
        CGFloat multiplier = [self multiplierForValue:gridline.value minValue:min maxValue:max];
        gridline.centerYConstraint = [NSLayoutConstraint constraintWithItem:gridline.view
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:multiplier
                                                                   constant:-self.footerHeight];
        [self addConstraint:gridline.centerYConstraint];
        [self setNeedsUpdateConstraints];
        [self layoutIfNeeded];
    }
}

#pragma mark - Custom setters
- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    [self.delegate chartView:self didTransitionToPage:currentPage];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.collectionView.contentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentPage = (int)floorf(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width);
    [self updateVisibleCells];
    [self updateGridlines];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.currentPage = (int)floorf(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width);
    [self updateVisibleCells];
    [self updateGridlines];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCHBarCellReuseId
                                                                forIndexPath:indexPath];
    cell.xAxisLabelString = [self.dataSource chartView:self
                              xAxisLabelForPointInPage:indexPath.section
                                               atIndex:indexPath.row];
    CGFloat minValue = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat maxValue = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    CGFloat value = [self.dataSource chartView:self valueForPointInPage:indexPath.section atIndex:indexPath.row];
    cell.footerHeight = self.footerHeight;
    [cell setMinValue:minValue maxValue:maxValue animated:NO];
    [cell setValue:value animated:NO];
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
        view = header;
    }
    return view;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHPagingChartFlowLayout *layout = (CHPagingChartFlowLayout *)collectionViewLayout;
    CGFloat itemHeight = self.collectionView.bounds.size.height;
    NSInteger itemCount = [self.dataSource chartView:self numberOfPointsInPage:indexPath.section];
    CGFloat sectionInsetWidth = layout.sectionInset.left + layout.sectionInset.right;
    CGFloat pageInsetWidth = layout.pageInset.left + layout.pageInset.right;
    CGFloat itemWidth = (collectionView.bounds.size.width - sectionInsetWidth - pageInsetWidth) / itemCount;
    return CGSizeMake(itemWidth, itemHeight);
}

@end
