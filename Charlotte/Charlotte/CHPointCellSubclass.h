//
//  CHPointCellSubclass.h
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHPointCell.h"

@interface CHPointCell (CHPointCellProtected)

@property (nonatomic, readwrite) CGFloat value;
@property (nonatomic, readwrite) CGFloat minValue;
@property (nonatomic, readwrite) CGFloat maxValue;
@property (nonatomic, strong) UIView *pointView;

/// Returns the cell's value relative to its display range.
- (CGFloat)scaledValue;

- (CGRect)pointViewFrame;
- (CGPoint)valueLabelCenter;

- (void)reload;
- (void)updateAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
