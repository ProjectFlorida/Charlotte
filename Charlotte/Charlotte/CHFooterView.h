//
//  CHFooterView.h
//  Charlotte
//
//  Created by Ben Guo on 10/22/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHFooterView : UIView

/**
 *  Displays the given x-axis label view at the given relative position. 
 *  If there is already a view at the given position, it will be replaced with the new view.
 *
 *  @param view     A UIView
 *  @param position The relative position on the x-axis at which the view should be displayed
 */
- (void)setXAxisLabelView:(UIView *)view atRelativeXPosition:(CGFloat)position;

@end
