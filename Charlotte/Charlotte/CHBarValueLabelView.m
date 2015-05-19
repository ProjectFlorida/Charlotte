//
//  CHBarValueLabelView.m
//  Charlotte
//
//  Created by Ben Guo on 3/20/15.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHBarValueLabelView.h"
#import "CHLabel.h"

@interface CHBarValueLabelView ()

@end

@implementation CHBarValueLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _upperLabel = [[CHLabel alloc] initWithFrame:CGRectZero];
        _upperLabel.edgeInsets = UIEdgeInsetsMake(2, 0, 5, 0);
        _upperLabel.textAlignment = NSTextAlignmentCenter;
        _lowerLabel = [[CHLabel alloc] initWithFrame:CGRectZero];
        _lowerLabel.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _lowerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_upperLabel];
        [self addSubview:_lowerLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat maxWidth = MAX(CGRectGetWidth(self.upperLabel.frame), CGRectGetWidth(self.lowerLabel.frame));
    self.upperLabel.frame = CGRectMake(0, 0,
                                       maxWidth,
                                       CGRectGetHeight(self.upperLabel.frame));
    self.lowerLabel.center = CGPointMake(CGRectGetMidX(self.upperLabel.frame),
                                         CGRectGetMaxY(self.upperLabel.frame));
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [self layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.lowerLabel.frame);
    CGFloat maxWidth = MAX(CGRectGetWidth(self.upperLabel.frame), CGRectGetWidth(self.lowerLabel.frame));
    return CGSizeMake(maxWidth, height);
}

@end
