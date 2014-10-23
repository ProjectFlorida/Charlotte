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
CGFloat const kCHPageTransitionAnimationDuration = 0.5;
CGFloat const kCHPageTransitionAnimationSpringDamping = 0.7;

@interface CHGridlineContainer : NSObject
@property (strong, nonatomic) CHGridlineView *view;
@property (assign, nonatomic) CGFloat value;
@property (strong, nonatomic) NSLayoutConstraint *centerYConstraint;
@end

@implementation CHGridlineContainer
@end

@interface CHChartView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) CHPagingChartFlowLayout *collectionViewLayout;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) NSString *cellReuseId;
@property (strong, nonatomic) Class cellClass;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) CGFloat footerHeight;
@property (assign, nonatomic) NSInteger numberOfAnimationsInProgress;

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

    _currentPage = 0;
    _footerHeight = 30;
    _xAxisLineHidden = NO;
    _numberOfAnimationsInProgress = 0;
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
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];

    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:_backgroundView atIndex:0];

    [self initializeConstraints];
}

- (void)initializeConstraints
{
    [self removeConstraints:self.constraints];

    NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView, _scrollView, _backgroundView);
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
    NSArray *backgroundViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSArray *backgroundViewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(h)-[_backgroundView]|"
                                                                       options:0
                                                                       metrics:@{@"h": @(_collectionViewLayout.headerHeight)}
                                                                         views:views];
    [self addConstraints:collectionViewH];
    [self addConstraints:collectionViewV];
    [self addConstraints:scrollViewH];
    [self addConstraints:scrollViewV];
    [self addConstraints:backgroundViewH];
    [self addConstraints:backgroundViewV];
}

+ (CGFloat)scaledValue:(CGFloat)value minValue:(CGFloat)min maxValue:(CGFloat)max
{
    return (value - min)/(max - min);
}

- (void)initializeGridlines
{
    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    NSInteger count = [self.dataSource numberOfHorizontalGridlinesInChartView:self];
    for (int i = 0; i < count; i++) {
        CHGridlineContainer *gridline = [[CHGridlineContainer alloc] init];
        gridline.view = [[CHGridlineView alloc] initWithFrame:CGRectZero];
        gridline.view.translatesAutoresizingMaskIntoConstraints = NO;
        gridline.value = [self.dataSource chartView:self valueForHorizontalGridlineAtIndex:i];
        if ([self.dataSource respondsToSelector:@selector(chartView:labelForHorizontalGridlineAtIndex:)]) {
            [gridline.view setLabel:[self.dataSource chartView:self labelForHorizontalGridlineAtIndex:i]];
        }
        if (!gridline.view.labelText) {
            gridline.view.labelText = [NSString stringWithFormat:@"%d", (int)roundf(gridline.value)];
        }
        [self.backgroundView addSubview:gridline.view];
        NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[g]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"g": gridline.view}];
        CGFloat scaledValue = [CHChartView scaledValue:gridline.value minValue:min maxValue:max];
        gridline.centerYConstraint = [NSLayoutConstraint constraintWithItem:gridline.view
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.backgroundView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1 - scaledValue
                                                                   constant:-self.footerHeight];
        [self.backgroundView addConstraint:gridline.centerYConstraint];
        [self.backgroundView addConstraints:constraintsH];
        [self.gridlines addObject:gridline];
    }
}

- (void)updateConstraints
{
    if (self.dataSource && !self.gridlines.count) {
        [self initializeGridlines];
    }
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [self.collectionViewLayout invalidateLayout];
    [super layoutSubviews];
    [self.scrollView setContentSize:self.collectionViewLayout.collectionViewContentSize];
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
    if (!animated) {
        [self updateGridlinesAnimated:NO];
        [self updateAlphaInVisibleCells];
        [self updateRangeInVisibleCells];
    }
}

- (void)updateRangeInVisibleCells {
    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    for (CHPointCell *cell in self.collectionView.visibleCells) {
        self.numberOfAnimationsInProgress++;
        [cell setMinValue:min maxValue:max animated:YES completion:^{
            self.numberOfAnimationsInProgress--;
        }];
    }
}

- (void)updateAlphaInVisibleCells {
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    NSInteger count = self.collectionView.visibleCells.count;
    CGFloat minAlpha = 0.3;
    CGFloat leftMargin = self.collectionViewLayout.pageInset.left;
    CGFloat rightMargin = self.collectionViewLayout.pageInset.right;
    for (int i = 0; i < count; i++) {
        CHPointCell *cell = self.collectionView.visibleCells[i];
        CGFloat distanceFromLeftEdge = cell.center.x - self.collectionView.contentOffset.x;
        CGFloat distanceFromRightEdge = collectionViewWidth - distanceFromLeftEdge;
        CGFloat alpha = 1;
        if (distanceFromLeftEdge < leftMargin) {
            alpha = MAX(distanceFromLeftEdge/leftMargin, minAlpha);
        }
        else if (distanceFromRightEdge < rightMargin) {
            alpha = MAX(distanceFromRightEdge/rightMargin, minAlpha);
        }
        cell.alpha = alpha;
    }
}

- (void)updateGridlinesAnimated:(BOOL)animated {
    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    NSInteger count = self.gridlines.count;
    for (int i = 0; i < count; i++) {
        CHGridlineContainer *gridline = self.gridlines[i];
        [self.backgroundView removeConstraint:gridline.centerYConstraint];
        CGFloat scaledValue = [CHChartView scaledValue:gridline.value minValue:min maxValue:max];
        gridline.centerYConstraint = [NSLayoutConstraint constraintWithItem:gridline.view
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.backgroundView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1 - scaledValue
                                                                   constant:-self.footerHeight];
        [self.backgroundView addConstraint:gridline.centerYConstraint];
        if (animated) {
            self.numberOfAnimationsInProgress++;
            [UIView animateWithDuration:kCHPageTransitionAnimationDuration delay:0
                 usingSpringWithDamping:kCHPageTransitionAnimationSpringDamping
                  initialSpringVelocity:0 options:0 animations:^{
                      [self layoutIfNeeded];
                  } completion:^(BOOL finished) {
                      self.numberOfAnimationsInProgress--;
                  }];
        }
        else {
            [self layoutIfNeeded];
        }
    }
}

#pragma mark - Custom setters

- (void)setCurrentPage:(NSInteger)currentPage
{
    CGFloat maxPage = [self.dataSource numberOfPagesInChartView:self] - 1;
    if (currentPage < 0) {
        currentPage = 0;
    }
    if (currentPage > maxPage) {
        currentPage = maxPage;
    }
    _currentPage = currentPage;
    [self.delegate chartView:self didTransitionToPage:currentPage];
}

- (void)setNumberOfAnimationsInProgress:(NSInteger)numberOfAnimationsInProgress {
    if (numberOfAnimationsInProgress < 0) {
        numberOfAnimationsInProgress = 0;
    }
    _numberOfAnimationsInProgress = numberOfAnimationsInProgress;
    self.scrollView.scrollEnabled = numberOfAnimationsInProgress == 0;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        self.collectionView.contentOffset = scrollView.contentOffset;
        [self updateAlphaInVisibleCells];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        self.currentPage = (int)floorf(scrollView.contentOffset.x / scrollView.bounds.size.width);
        [self updateRangeInVisibleCells];
        [self updateGridlinesAnimated:YES];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        self.currentPage = (int)floorf(scrollView.contentOffset.x / scrollView.bounds.size.width);
        [self updateRangeInVisibleCells];
        [self updateGridlinesAnimated:YES];
    }
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
    CHPointCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseId
                                                                  forIndexPath:indexPath];

    UILabel *xAxisLabel = [self.dataSource chartView:self xAxisLabelForPointInPage:indexPath.section
                                             atIndex:indexPath.row];
    if (xAxisLabel) {
        cell.xAxisLabelString = xAxisLabel.text;
        cell.xAxisLabelFont = xAxisLabel.font;
        cell.xAxisLabelColor = xAxisLabel.textColor;
    }

    CGFloat minValue = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat maxValue = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    CGFloat value = [self.dataSource chartView:self valueForPointInPage:indexPath.section atIndex:indexPath.row];
    cell.footerHeight = self.footerHeight;

    UILabel *valueLabel = [self.dataSource chartView:self labelForPointWithValue:value
                                              inPage:indexPath.section atIndex:indexPath.row];
    if (valueLabel) {
        cell.valueLabelString = valueLabel.text;
        cell.valueLabelFont = valueLabel.font;
        cell.valueLabelColor = valueLabel.textColor;
    }

    [cell setMinValue:minValue maxValue:maxValue animated:NO completion:nil];
    [cell setValue:value animated:NO completion:nil];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == CHSupplementaryElementKindHeader) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:CHSupplementaryElementKindHeader
                                                  withReuseIdentifier:kCHHeaderViewReuseId
                                                         forIndexPath:indexPath];
    }
    else if (kind == CHSupplementaryElementKindFooter) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:CHSupplementaryElementKindFooter
                                                  withReuseIdentifier:kCHFooterViewReuseId
                                                         forIndexPath:indexPath];
        if (self.isXAxisLineHidden) {
            view.hidden = YES;
        }
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
