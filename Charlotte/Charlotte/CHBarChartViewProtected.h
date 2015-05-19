//
//  CHChartViewSubclass.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHBarChartView.h"

@class CHPagingChartFlowLayout;

@interface CHBarChartView (CHBarChartViewProtected) <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSString *cellReuseId;
@property (strong, nonatomic) Class cellClass;
@property (strong, nonatomic) Class xAxisLabelViewClass;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) CHPagingChartFlowLayout *collectionViewLayout;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) CGFloat footerHeight;

/**
 *  If you override this method, you must call super in your implementation.
 *  If your CHChartView subclass uses a custom cell type, you must set the chart view's cellReuseId and cellClass
 *  before calling super.
 */
- (void)initialize;
- (void)initializeGridlines;
- (void)updateRangeInVisibleCellsAnimated:(BOOL)animated;
- (void)updateAlphaInVisibleCells;

@end
