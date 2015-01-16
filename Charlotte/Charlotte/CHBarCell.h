//
//  CHBarCell.h
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHPointCell.h"

extern NSString *const kCHBarCellReuseId;

@interface CHBarCell : CHPointCell

@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) NSArray *borderDashPattern;

/// the width of the bar view relative to the cell's width
@property (nonatomic, assign) CGFloat relativeBarWidth;

@end
