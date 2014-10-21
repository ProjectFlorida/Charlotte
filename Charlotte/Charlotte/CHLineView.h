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

/**
 *  Draws a line between the given array of values.
 *
 *  @param values An array of boxed CGFloats.
 */
- (void)drawLineWithValues:(NSArray *)values;

/**
 *  Draws a line between the given values, with colored regions below the line specified by the given dictionary.
 *
 *  @param regions A dictionary mapping boxed NSRange keys to UIColor values.
 */
- (void)drawLineWithValues:(NSArray *)values regions:(NSDictionary *)regions;

- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue animated:(BOOL)animated completion:(void (^)(void))completion;

@end
