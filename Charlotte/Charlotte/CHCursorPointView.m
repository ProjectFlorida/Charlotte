//
//  CHCursorPointView.m
//  Charlotte
//
//  Created by Ben Guo on 10/20/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHCursorPointView.h"

@interface CHCursorPointView ()

@property (nonatomic, strong) UIView *innerView;

@end

@implementation CHCursorPointView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    _innerView = [[UIView alloc] initWithFrame:CGRectZero];
    _innerView.translatesAutoresizingMaskIntoConstraints = NO;
    _innerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_innerView];

    NSLayoutConstraint *innerViewWidth = [NSLayoutConstraint constraintWithItem:_innerView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:0.7
                                                                       constant:0];
    NSLayoutConstraint *innerViewHeight = [NSLayoutConstraint constraintWithItem:_innerView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_innerView
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1
                                                                        constant:0];
    NSLayoutConstraint *innerViewCenterX = [NSLayoutConstraint constraintWithItem:_innerView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1
                                                                         constant:0];
    NSLayoutConstraint *innerViewCenterY = [NSLayoutConstraint constraintWithItem:_innerView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1
                                                                         constant:0];
    [self addConstraints:@[innerViewWidth, innerViewHeight, innerViewCenterX, innerViewCenterY]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.width / 2.0;
    self.innerView.layer.cornerRadius = self.innerView.bounds.size.width / 2.0;
}

#pragma mark - Setters

- (void)setColor:(UIColor *)color
{
    _color = color;
    self.backgroundColor = [color colorWithAlphaComponent:0.4];
    self.innerView.backgroundColor = color;
}


@end
