//
//  CHGridlineView.h
//  Charlotte
//
//  Created by Ben Guo on 10/14/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHLabel;

@interface CHGridlineView : UIView

/// The width of the gridline
@property (nonatomic, assign) CGFloat lineWidth UI_APPEARANCE_SELECTOR;

/// The color of the gridline
@property (nonatomic, strong) UIColor *lineColor UI_APPEARANCE_SELECTOR;

/// The gridline's line inset. Only left and right insets are honored.
@property (nonatomic, assign) UIEdgeInsets lineInset UI_APPEARANCE_SELECTOR;

/**
 *  The dash pattern applied to the line’s path when stroked.
 *  The dash pattern is specified as an array of NSNumber objects that specify the lengths of the painted segments 
 *  and unpainted segments, respectively, of the dash pattern.
 *
 *  Default is nil, a solid line.
 */
@property (nonatomic, assign) NSArray *lineDashPattern UI_APPEARANCE_SELECTOR;

/// Left label
@property (nonatomic, strong) CHLabel *leftLabel;

/// Lower left label
@property (nonatomic, strong) CHLabel *lowerLeftLabel;

/// Upper left label
@property (nonatomic, strong) CHLabel *upperLeftLabel;

/// Right label
@property (nonatomic, strong) CHLabel *rightLabel;

@end
