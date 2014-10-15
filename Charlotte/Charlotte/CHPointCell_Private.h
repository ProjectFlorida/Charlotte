//
//  CHPointCell_Private.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHPointCell.h"

@interface CHPointCell (Private)

@property (nonatomic, readwrite) CGFloat value;
@property (nonatomic, readwrite) CGFloat minValue;
@property (nonatomic, readwrite) CGFloat maxValue;
@property (nonatomic, strong) UILabel *xAxisLabel;
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) NSLayoutConstraint *barViewTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *barViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *barViewHeightConstraint;

/// Returns the cell's value relative to its min and max value
- (CGFloat)relativeValue;

/// TODO: abstract out the multiplier
- (NSLayoutConstraint *)barViewTopConstraintWithMultiplier:(CGFloat)multiplier;

- (void)updateBarAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
