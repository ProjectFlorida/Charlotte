//
//  CHChartView_Private.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

@interface CHChartView (Private) <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSString *cellReuseId;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) Class cellClass;

/**
 *  Subclasses of CHChartView may override this method. You must call super at the end of your implementation.
 *  If your CHChartView subclass uses a custom cell type, you must set the chart view's cellReuseId and cellClass
 *  before calling super.
 */
- (void)initialize;

@end
