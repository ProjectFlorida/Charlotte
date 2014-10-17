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

/**
 *  Sets the line view's points.
 *
 *  @param points An array of CGPoints (as NSValue objects)
 */
- (void)setPoints:(NSArray *)points;

- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)setFooterHeight:(CGFloat)footerHeight;

@end
