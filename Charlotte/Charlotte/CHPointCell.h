//
//  CHPointCell.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCHPointCellReuseId;

@interface CHPointCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, readonly) NSNumber *value;
@property (nonatomic, readonly) CGFloat minValue;
@property (nonatomic, readonly) CGFloat maxValue;
@property (nonatomic, strong) UILabel *xAxisLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat animationSpringDamping;

- (void)setValue:(NSNumber *)value animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue animated:(BOOL)animated completion:(void (^)(void))completion;

@end
