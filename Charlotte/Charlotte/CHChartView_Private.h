//
//  CHChartView_Private.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartView.h"

@class CHPagingChartFlowLayout;

@interface CHChartView (Private) <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSString *cellReuseId;
@property (strong, nonatomic) Class cellClass;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) CHPagingChartFlowLayout *collectionViewLayout;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) CGFloat footerHeight;

/**
 *  Subclasses of CHChartView may override this method. You must call super at the end of your implementation.
 *  If your CHChartView subclass uses a custom cell type, you must set the chart view's cellReuseId and cellClass
 *  before calling super.
 */
- (void)initialize;
- (void)updateRangeInVisibleCells;
- (void)updateAlphaInVisibleCells;

+ (CGFloat)relativeValue:(CGFloat)value minValue:(CGFloat)min maxValue:(CGFloat)max;

@end
