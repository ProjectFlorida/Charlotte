//
//  CHBarValueLabelView.h
//  Charlotte
//
//  Created by Ben Guo on 3/20/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHLabel;
@interface CHBarValueLabelView : UIView

@property (nonatomic, strong) CHLabel *upperLabel;
@property (nonatomic, strong) CHLabel *lowerLabel;

@end
