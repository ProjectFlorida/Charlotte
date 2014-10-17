//
//  CHLineView.h
//  Charlotte
//
//  Created by Ben Guo on 10/16/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCHLineViewReuseId;

@interface CHLineView : UICollectionReusableView

/**
 *  Sets the line view's points. Points should be provided as relative values.
 *
 *  @param points An array of CGPoints (as NSValue objects)
 */
- (void)setPoints:(NSArray *)points;
- (void)setPoints:(NSArray *)points log:(BOOL)log;

@end
