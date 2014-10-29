//
//  CHChartViewSubclass.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartView.h"

@class CHPagingChartFlowLayout;

@interface CHChartView (CHChartViewProtected) <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSString *cellReuseId;
@property (strong, nonatomic) Class cellClass;
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
- (void)initializeConstraints;
- (void)updateRangeInVisibleCellsAnimated:(BOOL)animated;
- (void)updateAlphaInVisibleCells;

+ (CGFloat)scaledValue:(CGFloat)value minValue:(CGFloat)min maxValue:(CGFloat)max;

@end
