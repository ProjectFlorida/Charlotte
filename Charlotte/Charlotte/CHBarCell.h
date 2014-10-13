//
//  CHBarCell.h
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCHBarCellReuseId;

@interface CHBarCell : UICollectionViewCell

/// Default is 0.
@property (nonatomic, assign) CGFloat value;

/// Default is 0.
@property (nonatomic, assign) CGFloat minValue;

/// Default is 1.
@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, strong) UIColor *barColor;

/// The bar's color when its value is 0.
@property (nonatomic, strong) UIColor *darkBarColor;

@property (nonatomic, strong) UIColor *xAxisLabelColor;
@property (nonatomic, strong) UIColor *valueLabelColor;

/// Default is nil.
@property (nonatomic, strong) NSString *xAxisLabelString;

/// Default is nil.
@property (nonatomic, assign) NSString *valueLabelString;

@end
