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

@property (nonatomic, readonly) CGFloat value;
@property (nonatomic, readonly) CGFloat minValue;
@property (nonatomic, readonly) CGFloat maxValue;

@property (nonatomic, strong) UIColor *primaryBarColor;

/// The bar's color when its value is 0.
@property (nonatomic, strong) UIColor *secondaryBarColor;


/// Default is nil.
@property (nonatomic, strong) NSString *xAxisLabelString;
@property (nonatomic, strong) UIColor *xAxisLabelColor;
@property (nonatomic, strong) UIFont *xAxisLabelFont;

/// Default is nil.
@property (nonatomic, assign) NSString *valueLabelString;
@property (nonatomic, strong) UIColor *valueLabelColor;
@property (nonatomic, strong) UIFont *valueLabelFont;

@property (nonatomic, assign) CGFloat footerHeight;

- (void)setValue:(CGFloat)value animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue animated:(BOOL)animated completion:(void (^)(void))completion;

@end
