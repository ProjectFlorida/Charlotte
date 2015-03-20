//
//  CHBarValueLabelView.h
//  Charlotte
//
//  Created by Ben Guo on 3/20/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHBarValueLabelView : UIView

/// The spacing between the upper and lower labels
@property (nonatomic, assign) CGFloat spacingBelowUpperLabel UI_APPEARANCE_SELECTOR;

/// The spacing below the lower label
@property (nonatomic, assign) CGFloat spacingBelowLowerLabel UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIFont *upperLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *upperLabelTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *lowerLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *lowerLabelTextColor UI_APPEARANCE_SELECTOR;

/// The upper label's text
@property (nonatomic, strong) NSString *upperLabelText;

/// The lower label's text
@property (nonatomic, strong) NSString *lowerLabelText;

@end
