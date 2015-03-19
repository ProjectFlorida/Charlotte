//
//  CHPointCell.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const CHPointCellReuseId;

@interface CHBarChartCell : UICollectionViewCell

/// The cell's page
@property (nonatomic, readwrite) NSInteger page;

/// The cell's value
@property (nonatomic, readonly) NSNumber *value;

/// The cell's x-axis label view
@property (nonatomic, strong) UIView *xAxisLabelView;

/// The class used to create the cell's x-axis label
@property (nonatomic, strong) Class xAxisLabelViewClass;

/// The cell's upper value label
@property (nonatomic, strong) UILabel *upperValueLabel;

/// The cell's lower value label
@property (nonatomic, strong) UILabel *lowerValueLabel;

/// The cell's footer height
@property (nonatomic, assign) CGFloat footerHeight;

/// The duration of cell animations
@property (nonatomic, assign) CGFloat animationDuration;

/// The spring damping of cell animations
@property (nonatomic, assign) CGFloat animationSpringDamping;

@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) NSArray *borderDashPattern;

/// the width of the bar view relative to the cell's width
@property (nonatomic, assign) CGFloat relativeBarWidth;

/// Sets the cell's value
- (void)setValue:(NSNumber *)value animated:(BOOL)animated completion:(void (^)(void))completion;

/// Sets the cell's range
- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue animated:(BOOL)animated completion:(void (^)(void))completion;

@end
