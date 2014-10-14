//
//  CHGridlineView.m
//  Charlotte
//
//  Created by Ben Guo on 10/14/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHGridlineView.h"

@interface CHGridlineView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CHGridlineView

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

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, 1);
}

- (void)initialize
{
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    _lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];

    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:_lineView];
    [self addSubview:_label];

    NSLayoutConstraint *lineViewY = [NSLayoutConstraint constraintWithItem:_lineView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:0];

    NSLayoutConstraint *lineViewHeight = [NSLayoutConstraint constraintWithItem:_lineView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1
                                                                       constant:1];
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_lineView]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(_lineView)];
    [self addConstraints:@[lineViewY, lineViewHeight]];
    [self addConstraints:constraintsH];
}

@end
