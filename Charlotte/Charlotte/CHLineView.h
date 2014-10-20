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

/**
 *  Sets the line view's values
 *
 *  @param points An array of boxed CGFloats.
 */
- (void)redrawWithValues:(NSArray *)points;

- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue animated:(BOOL)animated completion:(void (^)(void))completion;

@end
