//
//  CHGridlineView.h
//  Charlotte
//
//  Created by Ben Guo on 10/14/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CHGridlineLabelPosition) {
    CHGridlineLabelPositionBottomLeft,
    CHGridlineLabelPositionCenterRight
};

@interface CHGridlineView : UIView

@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) NSString *labelText;
@property (nonatomic, assign) CHGridlineLabelPosition labelPosition;

/**
 *  The dash pattern applied to the line’s path when stroked.
 *  The dash pattern is specified as an array of NSNumber objects that specify the lengths of the painted segments 
 *  and unpainted segments, respectively, of the dash pattern.
 *
 *  Default is nil, a solid line.
 */
@property (nonatomic, assign) NSArray *lineDashPattern;

@end
