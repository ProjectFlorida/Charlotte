//
//  CHTouchGestureRecognizer.m
//  Charlotte
//
//  Created by Ben Guo on 10/20/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHTouchGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation CHTouchGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

@end
