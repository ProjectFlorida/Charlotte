//
//  UIView+Charlotte.h
//  Charlotte
//
//  Created by Ben Guo on 4/2/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Charlotte)

/// Returns the color at the given point in the view
- (UIColor *)ch_colorAtPoint:(CGPoint)point;

@end
