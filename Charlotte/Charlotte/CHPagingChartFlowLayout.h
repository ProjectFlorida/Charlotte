//
//  CHPagingChartFlowLayout.h
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHPagingChartFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) UIEdgeInsets pageInset;

@end
