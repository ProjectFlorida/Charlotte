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
