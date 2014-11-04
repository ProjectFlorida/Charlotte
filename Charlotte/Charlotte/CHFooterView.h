//
//  CHFooterView.h
//  Charlotte
//
//  Created by Ben Guo on 10/22/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCHFooterViewReuseId;

@interface CHFooterView : UICollectionReusableView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  Displays the given x axis label at the given relative position. If there is already a label at the given position,
 *  it will be replaced with the new label.
 *
 *  @param label A UILabel object
 *  @param position The relative position on the x-axis at which the label should be displayed
 */
- (void)setXAxisLabel:(UILabel *)label atRelativeXPosition:(CGFloat)position;

@end
