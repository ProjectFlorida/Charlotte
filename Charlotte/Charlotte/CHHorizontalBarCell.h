//
//  CHHorizontalBarCell.h
//  Charlotte
//
//  Created by Ben Guo on 2/2/15.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHHorizontalBarCell : UICollectionViewCell

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, strong) UIFont *leftLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSString *leftLabelText;
@property (nonatomic, strong) UIColor *leftLabelColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIFont *rightLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSString *rightLabelText;
@property (nonatomic, strong) UIColor *rightLabelColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIFont *barLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSString *barLabelText;
@property (nonatomic, strong) UIColor *barLabelColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *barLabelBackgroundColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *barColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *lineColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) NSArray *lineDashPattern UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat barHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) CGFloat animationDuration UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat animationSpringDamping UI_APPEARANCE_SELECTOR;

- (void)setBarWidth:(CGFloat)barWidth animated:(BOOL)animated;

@end
