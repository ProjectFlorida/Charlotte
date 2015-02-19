//
//  CHHorizontalBarCell.h
//  Charlotte
//
//  Created by Ben Guo on 2/2/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHHorizontalBarCell : UICollectionViewCell

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, strong) UIFont *leftLabelFont;
@property (nonatomic, strong) NSString *leftLabelText;
@property (nonatomic, strong) UIColor *leftLabelColor;

@property (nonatomic, strong) UIFont *rightLabelFont;
@property (nonatomic, strong) NSString *rightLabelText;
@property (nonatomic, strong) UIColor *rightLabelColor;

@property (nonatomic, strong) UIFont *barLabelFont;
@property (nonatomic, strong) NSString *barLabelText;
@property (nonatomic, strong) UIColor *barLabelColor;
@property (nonatomic, strong) UIColor *barLabelBackgroundColor;

@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) NSArray *lineDashPattern;
@property (nonatomic, assign) CGFloat barHeight;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat animationSpringDamping;

- (void)setBarWidth:(CGFloat)barWidth animated:(BOOL)animated;

@end
