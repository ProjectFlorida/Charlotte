//
//  CHXAxisLabelView.m
//  Charlotte
//
//  Created by Ben Guo on 2/3/15.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHXAxisLabelView.h"
#import "CHLabel.h"

@interface CHXAxisLabelView ()

@property (nonatomic, strong) UIView *tickView;

@end

@implementation CHXAxisLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[CHLabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel = [[CHLabel alloc] initWithFrame:CGRectZero];
        _tickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 6)];
        _tickView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _tickPosition = CHRelativeTickPositionAbove;
        [self addSubview:_tickView];
        [self addSubview:_titleLabel];
        [self addSubview:_subtitleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    if (self.tickPosition == CHRelativeTickPositionAbove) {
        self.tickView.center = CGPointMake(CGRectGetMidX(bounds),
                                           CGRectGetMidY(self.tickView.bounds));
        self.titleLabel.center = CGPointMake(CGRectGetMidX(bounds),
                                             CGRectGetMaxY(self.tickView.frame) +
                                             CGRectGetMidY(self.titleLabel.bounds));
        self.subtitleLabel.center = CGPointMake(CGRectGetMidX(bounds),
                                                CGRectGetMaxY(self.titleLabel.frame) +
                                                CGRectGetMidY(self.subtitleLabel.bounds));

    }
    else if (self.tickPosition == CHRelativeTickPositionBelow) {
        self.titleLabel.center = CGPointMake(CGRectGetMidX(bounds),
                                             CGRectGetMidY(self.titleLabel.bounds));
        self.subtitleLabel.center = CGPointMake(CGRectGetMidX(bounds),
                                                CGRectGetMaxY(self.titleLabel.frame) +
                                                CGRectGetMidY(self.subtitleLabel.bounds));
        self.tickView.center = CGPointMake(CGRectGetMidX(bounds),
                                           CGRectGetMaxY(self.subtitleLabel.frame) +
                                           CGRectGetMidY(self.tickView.bounds));
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [self layoutIfNeeded];
    CGSize sizeThatFits = CGSizeMake(CGRectGetWidth(self.titleLabel.bounds),
                                     CGRectGetHeight(self.tickView.bounds) +
                                     CGRectGetHeight(self.titleLabel.bounds) +
                                     CGRectGetHeight(self.subtitleLabel.bounds));
    return sizeThatFits;
}

#pragma mark - Setters

- (void)setTickColor:(UIColor *)tickColor
{
    _tickColor = tickColor;
    self.tickView.backgroundColor = tickColor;
}

- (void)setTickWidth:(CGFloat)tickWidth
{
    _tickWidth = tickWidth;
    if (self.tickView.frame.size.width != tickWidth) {
        self.tickView.frame = CGRectMake(self.tickView.frame.origin.x,
                                         self.tickView.frame.origin.y,
                                         tickWidth,
                                         self.tickView.frame.size.height);
        [self setNeedsLayout];
    }
}

- (void)setTickHeight:(CGFloat)tickHeight
{
    _tickHeight = tickHeight;
    if (self.tickView.frame.size.height != tickHeight) {
        self.tickView.frame = CGRectMake(self.tickView.frame.origin.x,
                                         self.tickView.frame.origin.y,
                                         self.tickView.frame.size.width,
                                         tickHeight);
        [self setNeedsLayout];
    }
}

- (void)setTickPosition:(CHRelativeTickPosition)tickPosition
{
    if (_tickPosition == tickPosition) {
        return;
    }
    _tickPosition = tickPosition;
    [self setNeedsLayout];
}

@end
