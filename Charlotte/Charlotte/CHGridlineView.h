//
//  CHGridlineView.h
//  Charlotte
//
//  Created by Ben Guo on 10/14/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CHViewPosition) {
    CHViewPositionBottomLeft,
    CHViewPositionCenterRight
};

@interface CHGridlineView : UIView

@property (nonatomic, assign) CHViewPosition labelViewPosition;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, readonly) UIView *labelView;

/**
 *  The gridline will fade in from the left over this width. Set this to a value in the range [0, 1.0].
 *  Default is 0.
 */
@property (nonatomic, assign) CGFloat leftFadeWidth;

/**
 *  The dash pattern applied to the line’s path when stroked.
 *  The dash pattern is specified as an array of NSNumber objects that specify the lengths of the painted segments 
 *  and unpainted segments, respectively, of the dash pattern.
 *
 *  Default is nil, a solid line.
 */
@property (nonatomic, assign) NSArray *lineDashPattern;

- (void)setLabelView:(UIView *)view;

@end
