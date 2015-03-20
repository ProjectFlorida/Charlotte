//
//  CHPointCell.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHBarValueLabelView.h"

extern NSString *const CHPointCellReuseId;

@interface CHBarChartCell : UICollectionViewCell

/// The cell's page
@property (nonatomic, readwrite) NSInteger page;

/// The cell's value
@property (nonatomic, readonly) NSNumber *value;

/// The cell's x-axis label view
@property (nonatomic, strong) UIView *xAxisLabelView;

/// The class used to create the cell's x-axis label
/// TODO: do the same for the value label view
@property (nonatomic, strong) Class xAxisLabelViewClass;

/// The cell's value label view
@property (nonatomic, strong) CHBarValueLabelView *valueLabelView;

/// The cell's footer height
@property (nonatomic, assign) CGFloat footerHeight;

/// The bar's fill color
@property (nonatomic, strong) UIColor *barColor;

/// The bar's border color
@property (nonatomic, strong) UIColor *borderColor;

/// The bar's border width
@property (nonatomic, assign) CGFloat borderWidth;

/// The bar's border dash pattern
@property (nonatomic, strong) NSArray *borderDashPattern;

/// The width of the bar view relative to the cell's width
@property (nonatomic, assign) CGFloat relativeBarWidth;

/// The duration of cell animations
@property (nonatomic, assign) CGFloat animationDuration;

/// The spring damping of cell animations
@property (nonatomic, assign) CGFloat animationSpringDamping;

/// Sets the cell's value
- (void)setValue:(NSNumber *)value animated:(BOOL)animated completion:(void (^)(void))completion;

/// Sets the cell's range
- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue animated:(BOOL)animated completion:(void (^)(void))completion;

@end
