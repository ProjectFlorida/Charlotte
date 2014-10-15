//
//  CHChartView_Private.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

@interface CHChartView (Private)

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSString *cellReuseId;
@property (assign, nonatomic) NSInteger currentPage;

- (void)initialize;

@end
