//
//  CHBarCell.h
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCHBarCellReuseId;

@interface CHBarCell : UICollectionViewCell

/// defaults to nil
@property (nonatomic, strong) NSString *xAxisLabelString;

@end
