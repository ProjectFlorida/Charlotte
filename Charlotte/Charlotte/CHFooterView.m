//
//  CHFooterView.m
//  Charlotte
//
//  Created by Ben Guo on 10/22/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHFooterView.h"

NSString *const kCHFooterViewReuseId = @"CHFooterView";

@interface CHFooterView ()

/// Keys are boxed NSNumbers representing relative x position. Values are UILabels.
@property (nonatomic, strong) NSMutableDictionary *xAxisLabels;

@end

@implementation CHFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _xAxisLabels = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.xAxisLabels enumerateKeysAndObjectsUsingBlock:^(NSNumber *position, UILabel *label, BOOL *stop) {
        CGFloat x = self.bounds.size.width * [position floatValue];
        label.center = CGPointMake(x, CGRectGetMidY(self.bounds));
    }];
}

- (void)setXAxisLabel:(UILabel *)label atRelativeXPosition:(CGFloat)position
{
    UILabel *existingLabel = self.xAxisLabels[@(position)];
    if (existingLabel) {
        [existingLabel removeFromSuperview];
    }
    CGFloat x = self.bounds.size.width * position;
    label.center = CGPointMake(x, CGRectGetMidY(self.bounds));
    self.xAxisLabels[@(position)] = label;
    [self addSubview:label];
}

@end
