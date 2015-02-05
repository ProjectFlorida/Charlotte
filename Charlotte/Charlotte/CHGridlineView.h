//
//  CHGridlineView.h
//  Charlotte
//
//  Created by Ben Guo on 10/14/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

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
@property (nonatomic, strong) UILabel *leftLabel;

/// Lower left label
@property (nonatomic, strong) UILabel *lowerLeftLabel;

/// Right label
@property (nonatomic, strong) UILabel *rightLabel;

/// The distance from the left label (and lower left label) from the left edge
@property (nonatomic, assign) CGFloat leftLabelInset UI_APPEARANCE_SELECTOR;

/// The distance from the right label to the right edge
@property (nonatomic, assign) CGFloat rightLabelInset UI_APPEARANCE_SELECTOR;

/// The spacing between the left label and the lower left label. Default is 0.
@property (nonatomic, assign) CGFloat spacingBelowLeftLabel UI_APPEARANCE_SELECTOR;


@end
