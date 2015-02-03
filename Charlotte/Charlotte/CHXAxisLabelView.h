//
//  CHXAxisLabelView.h
//  Charlotte
//
//  Created by Ben Guo on 2/3/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

@import UIKit;

@interface CHXAxisLabelView : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *tickColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat tickWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat tickHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat spacingBelowTick UI_APPEARANCE_SELECTOR;

@end
