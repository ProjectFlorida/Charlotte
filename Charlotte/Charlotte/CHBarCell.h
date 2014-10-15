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

@property (nonatomic, strong) UIColor *primaryBarColor;

/// The color of the bar when its height is zero.
@property (nonatomic, strong) UIColor *secondaryBarColor;

@end
