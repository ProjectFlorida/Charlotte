//
//  CHChartView.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartView.h"
#import "CHHeaderView.h"
#import "CHFooterView.h"
#import "CHPagingChartFlowLayout.h"
#import "CHGridlineView.h"
#import "CHPointCell.h"

NSString *const CHSupplementaryElementKindHeader = @"CHSupplementaryElementKindHeader";
NSString *const CHSupplementaryElementKindFooter = @"CHSupplementaryElementKindFooter";

@interface CHGridlineContainer : NSObject
/// The line view containing the gridline's label
@property (strong, nonatomic) CHGridlineView *labelGridlineView;
/// The line view containing the gridline's line
@property (strong, nonatomic) CHGridlineView *lineGridlineView;
@property (assign, nonatomic) CGFloat value;
@property (strong, nonatomic) NSLayoutConstraint *labelViewCenterYConstraint;
@property (strong, nonatomic) NSLayoutConstraint *lineViewCenterYConstraint;
@end

@implementation CHGridlineContainer
@end

@interface CHChartView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) CHPagingChartFlowLayout *collectionViewLayout;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) NSString *cellReuseId;
@property (strong, nonatomic) Class cellClass;

// An array of CHGridlineContainer objects
@property (strong, nonatomic) NSMutableArray *gridlines;

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
    self.clipsToBounds = YES;

    _currentPage = 0;
    _footerHeight = 30;
    _headerHeight = 30;

    _pageTransitionAnimationDuration = 0.5;
    _pageTransitionAnimationSpringDamping = 0.7;

    _pagingAlpha = 0.3;
    _pageInset = UIEdgeInsetsMake(0, 40, 0, 40);
    _sectionInset = UIEdgeInsetsZero;
    _hidesValueLabelsOnNonCurrentPages = YES;
    _gridlines = [NSMutableArray array];

    _collectionViewLayout = [[CHPagingChartFlowLayout alloc] init];
    _collectionViewLayout.pageInset = _pageInset;
    _collectionViewLayout.sectionInset = UIEdgeInsetsZero;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:_collectionViewLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    _collectionView.scrollEnabled = NO;

    // When overriding initialize, subclasses may set cellClass and cellReuseId before calling super.
    if (!_cellClass) {
        _cellClass = [CHPointCell class];
    }
    if (!_cellReuseId) {
        _cellReuseId = kCHPointCellReuseId;
    }
    [_collectionView registerClass:_cellClass forCellWithReuseIdentifier:_cellReuseId];
    [_collectionView registerClass:[CHHeaderView class]
        forSupplementaryViewOfKind:CHSupplementaryElementKindHeader
               withReuseIdentifier:kCHHeaderViewReuseId];
    [_collectionView registerClass:[CHFooterView class]
        forSupplementaryViewOfKind:CHSupplementaryElementKindFooter
               withReuseIdentifier:kCHFooterViewReuseId];
    [self addSubview:_collectionView];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];

    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _backgroundView.clipsToBounds = NO;
    _backgroundView.backgroundColor = [UIColor clearColor];
    [self insertSubview:_backgroundView atIndex:0];

    _overlayView = [[UIView alloc] initWithFrame:CGRectZero];
    _overlayView.clipsToBounds = NO;
    _overlayView.backgroundColor = [UIColor clearColor];
    [self addSubview:_overlayView];
}

+ (CGFloat)scaledValue:(CGFloat)value minValue:(CGFloat)min maxValue:(CGFloat)max
{
    return (value - min)/(max - min);
}

- (void)initializeGridlines
{
    NSInteger count = [self.dataSource numberOfHorizontalGridlinesInChartView:self];

    if (self.gridlines.count) {
        for (CHGridlineContainer *gridline in self.gridlines) {
            [gridline.lineGridlineView removeFromSuperview];
            [gridline.labelGridlineView removeFromSuperview];
        }
        [self.gridlines removeAllObjects];
    }

    for (int i = 0; i < count; i++) {
        CHGridlineContainer *gridline = [[CHGridlineContainer alloc] init];
        gridline.labelGridlineView.clipsToBounds = NO;
        gridline.lineGridlineView = [[CHGridlineView alloc] initWithFrame:CGRectZero];
        gridline.labelGridlineView = [[CHGridlineView alloc] initWithFrame:CGRectZero];
        gridline.labelGridlineView.lineColor = [UIColor clearColor];
        gridline.value = [self.dataSource chartView:self valueForHorizontalGridlineAtIndex:i];
        if ([self.dataSource respondsToSelector:@selector(chartView:leftLabelViewForHorizontalGridlineWithValue:atIndex:)]) {
            UIView *labelView = [self.dataSource chartView:self
               leftLabelViewForHorizontalGridlineWithValue:gridline.value atIndex:i];
            gridline.labelGridlineView.leftLabelView = labelView;
        }
        if ([self.dataSource respondsToSelector:@selector(chartView:lowerLeftLabelViewForHorizontalGridlineWithValue:atIndex:)]) {
            UIView *labelView = [self.dataSource chartView:self
               lowerLeftLabelViewForHorizontalGridlineWithValue:gridline.value atIndex:i];
            gridline.labelGridlineView.lowerLeftLabelView = labelView;
        }
        if ([self.dataSource respondsToSelector:@selector(chartView:rightLabelViewForHorizontalGridlineWithValue:atIndex:)]) {
            UIView *labelView = [self.dataSource chartView:self
              rightLabelViewForHorizontalGridlineWithValue:gridline.value atIndex:i];
            gridline.labelGridlineView.rightLabelView = labelView;
        }
        if ([self.dataSource respondsToSelector:@selector(chartView:lineColorForHorizontalGridlineAtIndex:)]) {
            gridline.lineGridlineView.lineColor = [self.dataSource chartView:self
                                       lineColorForHorizontalGridlineAtIndex:i];
        }
        if ([self.dataSource respondsToSelector:@selector(chartView:lineWidthForHorizontalGridlineAtIndex:)]) {
            gridline.lineGridlineView.lineWidth = [self.dataSource chartView:self
                                       lineWidthForHorizontalGridlineAtIndex:i];
        }
        if ([self.dataSource respondsToSelector:@selector(chartView:lineDashPatternForHorizontalGridlineAtIndex:)]) {
            gridline.lineGridlineView.lineDashPattern = [self.dataSource chartView:self
                                       lineDashPatternForHorizontalGridlineAtIndex:i];
        }
        if ([self.dataSource respondsToSelector:@selector(chartView:lineInsetForHorizontalGridlineAtIndex:)]) {
            gridline.lineGridlineView.lineInset = [self.dataSource chartView:self
                                       lineInsetForHorizontalGridlineAtIndex:i];
        }

        [self.backgroundView addSubview:gridline.lineGridlineView];
        [self.overlayView addSubview:gridline.labelGridlineView];
        [self.gridlines addObject:gridline];
    }
}

- (void)layoutSubviews
{
    if (self.dataSource && !self.gridlines.count) {
        [self initializeGridlines];
    }
    [self.collectionViewLayout invalidateLayout];
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.collectionView.frame = self.bounds;
    self.scrollView.frame = UIEdgeInsetsInsetRect(bounds,
                                                  UIEdgeInsetsMake(0, self.collectionViewLayout.pageInset.left,
                                                                   0, self.collectionViewLayout.pageInset.right));
    self.backgroundView.frame = UIEdgeInsetsInsetRect(bounds,
                                                      UIEdgeInsetsMake(self.collectionViewLayout.headerHeight, 0,
                                                                       self.collectionViewLayout.footerHeight, 0));
    self.overlayView.frame = UIEdgeInsetsInsetRect(bounds,
                                                   UIEdgeInsetsMake(self.collectionViewLayout.headerHeight, 0,
                                                                    self.collectionViewLayout.footerHeight, 0));
    [self.scrollView setContentSize:self.collectionViewLayout.collectionViewContentSize];
    [self updateAlphaInVisibleCellsAnimated:NO];
    self.scrollView.contentOffset = CGPointMake(self.currentPage*self.scrollView.bounds.size.width, 0);
    self.collectionView.contentOffset = self.scrollView.contentOffset;
    self.yAxisLabelView.center = CGPointMake(CGRectGetMidX(self.yAxisLabelView.frame),
                                             CGRectGetMidY(self.yAxisLabelView.frame));
    [self updateGridlinesAnimated:NO];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    self.collectionView.contentOffset = self.scrollView.contentOffset;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return self.scrollView;
}

- (void)reloadData
{
    [self.collectionView reloadData];
    NSUInteger numberOfGridlines = [self.dataSource numberOfHorizontalGridlinesInChartView:self];
    if ([self.gridlines count] != numberOfGridlines) {
        [self initializeGridlines];
    }
    [self updateGridlinesAnimated:NO];
    [self setNeedsLayout];
}

- (void)scrollToPage:(NSInteger)page animateScrolling:(BOOL)animateScrolling animateRangeTransition:(BOOL)animateRange;
{
    CGRect visible = self.scrollView.bounds;
    visible.origin.x = self.scrollView.bounds.size.width*page;
    [self.scrollView scrollRectToVisible:visible animated:animateScrolling];
    self.currentPage = page;
    [self updateVisibleValueLabels];
    [self updateAlphaInVisibleCellsAnimated:animateRange];
    [self updateGridlinesAnimated:animateRange];
    [self updateRangeInVisibleCellsAnimated:animateRange];
}

- (void)updateRangeInVisibleCellsAnimated:(BOOL)animated {
    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    for (CHPointCell *cell in self.collectionView.visibleCells) {
        [cell setMinValue:min maxValue:max animated:animated completion:nil];
    }
}

- (void)updateVisibleValueLabels {
    if (!self.hidesValueLabelsOnNonCurrentPages) {
        return;
    }

    NSInteger count = self.collectionView.visibleCells.count;
    for (int i = 0; i < count; i++) {
        CHPointCell *cell = self.collectionView.visibleCells[i];
        if (cell.page == self.currentPage) {
            [UIView animateWithDuration:self.pageTransitionAnimationDuration delay:0
                 usingSpringWithDamping:self.pageTransitionAnimationSpringDamping initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn animations:^{
                                    cell.valueLabel.transform = CGAffineTransformIdentity;
                                } completion:nil];
        }
        else {
            [UIView animateWithDuration:self.pageTransitionAnimationDuration delay:0
                 usingSpringWithDamping:self.pageTransitionAnimationSpringDamping initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseOut animations:^{
                                    cell.valueLabel.transform = CGAffineTransformMakeScale(0.0, 0.0);
                                } completion:nil];
        }
    }
}

- (void)updateAlphaInVisibleCellsAnimated:(BOOL)animated {
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    UIEdgeInsets pageInset = self.collectionViewLayout.pageInset;
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat pageWidth = collectionViewWidth - pageInset.left - pageInset.right;
    CGFloat distanceFromLeftEdge = ABS((contentOffsetX - (pageWidth*self.currentPage))/pageWidth);
    NSInteger count = self.collectionView.visibleCells.count;
    for (int i = 0; i < count; i++) {
        CHPointCell *cell = self.collectionView.visibleCells[i];
        CGFloat alpha;
        if (cell.page != self.currentPage) {
            if ((cell.page > self.currentPage + 1) || (cell.page < self.currentPage - 1)) {
                alpha = self.pagingAlpha;
            }
            else {
                alpha = self.pagingAlpha + ((1 - self.pagingAlpha)*distanceFromLeftEdge);
            }
        }
        else {
            alpha = 1 - ((1 - self.pagingAlpha)*distanceFromLeftEdge);
        }
        if (animated) {
            UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseIn;
            if (alpha < cell.alpha) {
                options = UIViewAnimationOptionCurveEaseOut;
            }
            [UIView animateWithDuration:self.pageTransitionAnimationDuration delay:0
                                options:options animations:^{
                                    cell.alpha = alpha;
                                } completion:nil];
        }
        else {
            cell.alpha = alpha;
        }
    }
}

- (void)updateGridlinesAnimated:(BOOL)animated {
    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    NSInteger count = self.gridlines.count;
    CGRect backgroundViewBounds = self.backgroundView.bounds;
    for (int i = 0; i < count; i++) {
        CHGridlineContainer *gridline = self.gridlines[i];
        gridline.value = [self.dataSource chartView:self valueForHorizontalGridlineAtIndex:i];
        CGFloat scaledValue = [CHChartView scaledValue:gridline.value minValue:min maxValue:max];
        void(^layoutBlock)() = ^() {
            gridline.labelGridlineView.frame = CGRectMake(0, 0, CGRectGetWidth(backgroundViewBounds), 40);
            gridline.labelGridlineView.center = CGPointMake(CGRectGetMidX(backgroundViewBounds),
                                                            (1 - scaledValue)*CGRectGetMaxY(backgroundViewBounds));
            gridline.lineGridlineView.frame = gridline.labelGridlineView.frame;
            [self updateVisibilityOfGridline:gridline];
        };

        if (animated) {
            [UIView animateWithDuration:self.pageTransitionAnimationDuration delay:0
                 usingSpringWithDamping:self.pageTransitionAnimationSpringDamping
                  initialSpringVelocity:0 options:0 animations:^{
                      layoutBlock();
                  } completion:nil];
        }
        else {
            layoutBlock();
        }
    }
}

/// Hide the given gridline if it's partially obscured
- (void)updateVisibilityOfGridline:(CHGridlineContainer *)gridline
{
    CGRect labelViewFrame = [gridline.labelGridlineView convertRect:gridline.labelGridlineView.bounds
                                                             toView:self];
    BOOL fullyVisible = CGRectContainsRect(self.bounds, labelViewFrame);
    if (fullyVisible) {
        gridline.labelGridlineView.alpha = 1;
        gridline.lineGridlineView.alpha = 1;
    }
    else {
        gridline.labelGridlineView.alpha = 0;
        gridline.lineGridlineView.alpha = 0;
    }
}

#pragma mark - Custom setters

- (void)setPageInset:(UIEdgeInsets)pageInset
{
    _pageInset = pageInset;
    self.collectionViewLayout.pageInset = pageInset;
    [self.collectionViewLayout invalidateLayout];
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    _sectionInset = sectionInset;
    self.collectionViewLayout.sectionInset = sectionInset;
    [self.collectionViewLayout invalidateLayout];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    CGFloat maxPage = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInChartView:)]) {
        maxPage = [self.dataSource numberOfPagesInChartView:self] - 1;
    }
    if (currentPage < 0) {
        currentPage = 0;
    }
    if (currentPage > maxPage) {
        currentPage = maxPage;
    }
    _currentPage = currentPage;
    [self.delegate chartView:self didTransitionToPage:currentPage];
}

- (void)setHeaderHeight:(CGFloat)headerHeight
{
    _headerHeight = headerHeight;
    self.collectionViewLayout.headerHeight = headerHeight;
    [self updateGridlinesAnimated:NO];
    [self updateRangeInVisibleCellsAnimated:NO];
    [self setNeedsLayout];
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    _footerHeight = footerHeight;
    self.collectionViewLayout.footerHeight = footerHeight;
    [self updateGridlinesAnimated:NO];
    [self updateRangeInVisibleCellsAnimated:NO];
    [self setNeedsLayout];
}

- (void)setYAxisLabelView:(UIView *)yAxisLabelView
{
    _yAxisLabelView = yAxisLabelView;
    [self addSubview:_yAxisLabelView];
    [self setNeedsLayout];
}

- (void)setPageTransitionAnimationDuration:(CGFloat)pageTransitionAnimationDuration
{
    _pageTransitionAnimationDuration = pageTransitionAnimationDuration;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        self.collectionView.contentOffset = scrollView.contentOffset;
        [self updateAlphaInVisibleCellsAnimated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidStopMoving:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidStopMoving:scrollView];
}

- (void)scrollViewDidStopMoving:(UIScrollView *)scrollView
{
    CGFloat scrollViewWidth = roundf(scrollView.bounds.size.width);
    if (scrollView == self.scrollView && scrollViewWidth != 0) {
        NSInteger newCurrentPage = (int)floorf(roundf(scrollView.contentOffset.x) / scrollViewWidth);
        if (newCurrentPage != self.currentPage) {
            self.currentPage = newCurrentPage;
            [self updateRangeInVisibleCellsAnimated:YES];
            [self updateVisibleValueLabels];
            [self updateAlphaInVisibleCellsAnimated:YES];
            [self updateGridlinesAnimated:YES];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInChartView:)]) {
        return [self.dataSource numberOfPagesInChartView:self];
    }
    else {
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource chartView:self numberOfPointsInPage:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHPointCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseId
                                                                  forIndexPath:indexPath];
    cell.animationDuration = self.pageTransitionAnimationDuration;
    cell.animationSpringDamping = self.pageTransitionAnimationSpringDamping;

    if ([self.dataSource respondsToSelector:@selector(configureXAxisLabel:forPointInPage:atIndex:inChartView:)]) {
        [self.dataSource configureXAxisLabel:cell.xAxisLabel forPointInPage:indexPath.section atIndex:indexPath.row
                                 inChartView:self];
        [cell setNeedsLayout];
    }

    CGFloat minValue = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat maxValue = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    CGFloat value = [self.dataSource chartView:self valueForPointInPage:indexPath.section atIndex:indexPath.row];
    cell.footerHeight = self.footerHeight;

    if ([self.dataSource respondsToSelector:@selector(configureLabel:forPointWithValue:inPage:atIndex:inChartView:)]) {
        [self.dataSource configureLabel:cell.valueLabel forPointWithValue:value inPage:indexPath.section
                                atIndex:indexPath.row inChartView:self];
        [cell setNeedsLayout];
    }

    [cell setMinValue:minValue maxValue:maxValue animated:NO completion:nil];
    [cell setValue:value animated:NO completion:nil];
    cell.page = indexPath.section;
    cell.alpha = (cell.page == self.currentPage) ? 1 : self.pagingAlpha;
    if (self.hidesValueLabelsOnNonCurrentPages) {
        if (cell.page == self.currentPage) {
            cell.valueLabel.transform = CGAffineTransformIdentity;
        }
        else {
            cell.valueLabel.transform = CGAffineTransformMakeScale(0, 0);
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == CHSupplementaryElementKindHeader) {
        CHHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:CHSupplementaryElementKindHeader
                                                                      withReuseIdentifier:kCHHeaderViewReuseId
                                                                             forIndexPath:indexPath];
        view = headerView;
    }
    else if (kind == CHSupplementaryElementKindFooter) {
        CHFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:CHSupplementaryElementKindFooter
                                                                      withReuseIdentifier:kCHFooterViewReuseId
                                                                             forIndexPath:indexPath];
        view = footerView;
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
