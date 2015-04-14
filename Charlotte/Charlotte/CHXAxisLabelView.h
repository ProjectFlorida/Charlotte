//
//  CHXAxisLabelView.h
//  Charlotte
//
//  Created by Ben Guo on 2/3/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, CHRelativeTickPosition) {
    CHRelativeTickPositionAbove,
    CHRelativeTickPositionBelow,
};

@class CHLabel;

@interface CHXAxisLabelView : UIView

@property (nonatomic, strong) CHLabel *titleLabel;
@property (nonatomic, strong) CHLabel *subtitleLabel;
@property (nonatomic, assign) CGFloat value;

@property (nonatomic, strong) UIColor *tickColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat tickWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat tickHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CHRelativeTickPosition tickPosition UI_APPEARANCE_SELECTOR;

@end
