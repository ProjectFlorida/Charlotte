//
//  CHInteractivePoint.h
//  Charlotte
//
//  Created by Ben Guo on 10/29/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

@import UIKit;

@interface CHInteractivePoint : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign) CGFloat relativeXPosition;
@property (nonatomic, assign) CGFloat value;

@end
