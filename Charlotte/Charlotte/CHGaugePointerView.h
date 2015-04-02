//
//  CHGaugePointerView.h
//  Charlotte
//
//  Created by Ben Guo on 4/1/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHGaugePointerView : UIView

@property (nonatomic, assign) CGFloat needleCircleRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat needleWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *needleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSString *text UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat spacingBelowLabel UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets labelEdgeInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat labelCornerRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;

/// The background color of the pointer label. The default color is the color underneath needle circle.
@property (nonatomic, strong) UIColor *labelBackgroundColor UI_APPEARANCE_SELECTOR;

@end
