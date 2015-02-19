//
//  CHHorizontalBarChartView.m
//  Charlotte
//
//  Created by Ben Guo on 2/2/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import "CHHorizontalBarChartView.h"
#import "CHHorizontalBarCell.h"

NSString *const CHHorizontalBarCellReuseId = @"CHHorizontalBarCell";

@interface CHHorizontalBarChartView () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;

@end

@implementation CHHorizontalBarChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cellHeight = 35;
        _lineSpacing = 20;
        _leftLabelFont = [UIFont systemFontOfSize:13];
        _rightLabelFont = [UIFont systemFontOfSize:13];
        _lineDashPattern = @[@0.5, @3];
        _lineColor = [UIColor darkGrayColor];
        _animationDuration = 0.5;
        _animationSpringDamping = 0.7;

        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewLayout.sectionInset = UIEdgeInsetsZero;
        _collectionViewLayout.minimumLineSpacing = _lineSpacing;
        _collectionViewLayout.minimumInteritemSpacing = 0;
        _collectionViewLayout.headerReferenceSize = CGSizeZero;
        _collectionViewLayout.footerReferenceSize = CGSizeZero;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:_collectionViewLayout];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;

        [_collectionView registerClass:[CHHorizontalBarCell class]
            forCellWithReuseIdentifier:CHHorizontalBarCellReuseId];

        [self addSubview:_collectionView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    if (!CGRectEqualToRect(self.collectionView.frame, bounds)) {
        self.collectionView.frame = bounds;
        self.collectionViewLayout.itemSize = CGSizeMake(CGRectGetWidth(self.bounds), self.cellHeight);
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    self.collectionView.contentOffset = CGPointZero;
    self.collectionView.contentInset = UIEdgeInsetsZero;
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)reloadValues
{
    for (CHHorizontalBarCell *cell in self.collectionView.visibleCells) {
        NSUInteger index = cell.index;
        CGFloat max = [self.dataSource maxValueInHorizontalBarChartView:self];
        CGFloat value = [self.dataSource horizontalBarChartView:self valueOfBarAtIndex:index];

        CGFloat barWidth = max == 0 ? 0 : value/max;
        [cell setBarWidth:barWidth animated:YES];

        if ([self.dataSource respondsToSelector:@selector(horizontalBarChartView:configureBar:withValue:atIndex:)]) {
            [self.dataSource horizontalBarChartView:self configureBar:cell withValue:value atIndex:index];
        }
    }
}

#pragma mark - Setters

- (void)setCellHeight:(CGFloat)cellHeight
{
    _cellHeight = cellHeight;
    [self.collectionViewLayout invalidateLayout];
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    _lineSpacing = lineSpacing;
    self.collectionViewLayout.minimumLineSpacing = lineSpacing;
}

- (void)setLeftLabelFont:(UIFont *)leftLabelFont
{
    if (_leftLabelFont == leftLabelFont) {
        return;
    }
    _leftLabelFont = leftLabelFont;
    [self.collectionView reloadData];
}

- (void)setRightLabelFont:(UIFont *)rightLabelFont
{
    if (_rightLabelFont == rightLabelFont) {
        return;
    }
    _rightLabelFont = rightLabelFont;
    [self.collectionView reloadData];
}

- (void)setLineDashPattern:(NSArray *)lineDashPattern
{
    if (_lineDashPattern == lineDashPattern) {
        return;
    }
    _lineDashPattern = lineDashPattern;
    [self.collectionView reloadData];
}

- (void)setLineColor:(UIColor *)lineColor
{
    if (_lineColor == lineColor) {
        return;
    }
    _lineColor = lineColor;
    [self.collectionView reloadData];
}

- (void)setBarHeight:(CGFloat)barHeight
{
    if (_barHeight == barHeight) {
        return;
    }
    _barHeight = barHeight;
    [self.collectionView reloadData];
}

- (void)setAnimationDuration:(CGFloat)reloadAnimationDuration
{
    if (_animationDuration == reloadAnimationDuration) {
        return;
    }
    _animationDuration = reloadAnimationDuration;
    [self.collectionView reloadData];
}

- (void)setAnimationSpringDamping:(CGFloat)reloadAnimationSpringDamping
{
    if (_animationSpringDamping == reloadAnimationSpringDamping) {
        return;
    }
    _animationSpringDamping = reloadAnimationSpringDamping;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfBarsInHorizontalBarChartView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHHorizontalBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CHHorizontalBarCellReuseId
                                                                          forIndexPath:indexPath];
    cell.leftLabelFont = self.leftLabelFont;
    cell.rightLabelFont = self.rightLabelFont;
    cell.lineDashPattern = self.lineDashPattern;
    cell.lineColor = self.lineColor;
    cell.index = indexPath.row;
    cell.animationDuration = self.animationSpringDamping;
    cell.animationSpringDamping = self.animationDuration;

    CGFloat max = [self.dataSource maxValueInHorizontalBarChartView:self];
    CGFloat value = [self.dataSource horizontalBarChartView:self valueOfBarAtIndex:indexPath.row];

    CGFloat barWidth = max == 0 ? 0 : value/max;
    [cell setBarWidth:barWidth animated:NO];

    if ([self.dataSource respondsToSelector:@selector(horizontalBarChartView:configureBar:withValue:atIndex:)]) {
        [self.dataSource horizontalBarChartView:self configureBar:cell withValue:value atIndex:indexPath.row];
    }

    return cell;
}

@end
