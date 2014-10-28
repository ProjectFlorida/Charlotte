//
//  CHHeaderView.m
//  Charlotte
//
//  Created by Ben Guo on 10/10/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHHeaderView.h"

NSString *const kCHHeaderViewReuseId = @"CHHeaderView";

@interface CHHeaderView ()

@property (nonatomic, strong) UIView *labelView;

@end

@implementation CHHeaderView

- (void)setLabelView:(UIView *)view
{
    for (NSLayoutConstraint *constraint in _labelView.constraints) {
        [self removeConstraint:constraint];
    }
    [_labelView removeFromSuperview];
    _labelView = view;
    _labelView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_labelView];
    NSDictionary *views = NSDictionaryOfVariableBindings(_labelView);
    NSArray *labelViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_labelView]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    NSArray *labelViewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_labelView]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    [self addConstraints:labelViewH];
    [self addConstraints:labelViewV];
}

@end
