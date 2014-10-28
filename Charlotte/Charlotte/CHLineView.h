//
//  CHLineView.h
//  Charlotte
//
//  Created by Ben Guo on 10/16/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCHLineViewReuseId;

@interface CHLineView : UICollectionReusableView

@property (nonatomic, readonly) CGFloat minValue;
@property (nonatomic, readonly) CGFloat maxValue;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, strong) UIColor *chartBackgroundColor;

/// The line's primary color (drawn on the right).
@property (nonatomic, strong) UIColor *lineColor;

/// The line's tint color (drawn on the left). Set this to nil for no tint.
@property (nonatomic, strong) UIColor *lineTintColor;

/**
 *  Draws a line between the given array of values.
 *
 *  @param values An array of boxed CGFloats.
 */
- (void)drawLineWithValues:(NSArray *)values;

/**
 *  Draws a line between the given values, with colored regions below the line specified by the given array.
 *
 *  @param regions An array of CHChartRegion objects.
 */
- (void)drawLineWithValues:(NSArray *)values regions:(NSArray *)regions;

- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue animated:(BOOL)animated completion:(void (^)(void))completion;

@end
