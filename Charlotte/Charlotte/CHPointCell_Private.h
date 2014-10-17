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
@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) NSLayoutConstraint *pointViewPositionConstraint;
@property (nonatomic, strong) NSLayoutConstraint *pointViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *pointViewHeightConstraint;

/// Returns the cell's value relative to its display range.
- (CGFloat)relativeValue;

- (NSLayoutConstraint *)pointViewPositionConstraintWithAttribute:(NSLayoutAttribute)attribute
                                                      multiplier:(CGFloat)multiplier;

- (void)updateAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
