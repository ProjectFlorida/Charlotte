//
//  CHFooterView.m
//  Charlotte
//
//  Created by Ben Guo on 10/22/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHFooterView.h"

NSString *const CHFooterViewReuseId = @"CHFooterView";

@interface CHFooterView ()

/// Keys are boxed NSNumbers representing relative x position. Values are UIViews.
@property (nonatomic, strong) NSMutableDictionary *xAxisLabelViews;

@end

@implementation CHFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _xAxisLabelViews = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.xAxisLabelViews enumerateKeysAndObjectsUsingBlock:^(NSNumber *position, UIView *view, BOOL *stop) {
        CGFloat x = self.bounds.size.width * [position floatValue];
        view.center = CGPointMake(x, CGRectGetMidY(view.bounds));
    }];
}

- (void)setXAxisLabelView:(UIView *)view atRelativeXPosition:(CGFloat)position
{
    UIView *existingLabelView = self.xAxisLabelViews[@(position)];
    if (existingLabelView) {
        [existingLabelView removeFromSuperview];
    }
    CGFloat x = self.bounds.size.width * position;
    view.center = CGPointMake(x, CGRectGetMidY(view.bounds));
    self.xAxisLabelViews[@(position)] = view;
    [self addSubview:view];
}

@end
