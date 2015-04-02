//
//  CHXAxisLabelView.m
//  Charlotte
//
//  Created by Ben Guo on 2/3/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
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
        _font = [UIFont systemFontOfSize:13];
        _label = [[CHLabel alloc] initWithFrame:CGRectZero];
        _tickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 6)];
        _tickView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _tickPosition = CHRelativeTickPositionAbove;
        [self addSubview:_tickView];
        [self addSubview:_label];
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
        self.label.center = CGPointMake(CGRectGetMidX(bounds),
                                        CGRectGetMaxY(self.tickView.frame) + CGRectGetMidY(self.label.bounds));
    }
    else if (self.tickPosition == CHRelativeTickPositionBelow) {
        self.label.center = CGPointMake(CGRectGetMidX(bounds),
                                        CGRectGetMidY(self.label.bounds));
        self.tickView.center = CGPointMake(CGRectGetMidX(bounds),
                                           CGRectGetMaxY(self.label.frame) + CGRectGetMidY(self.tickView.bounds));
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [self layoutIfNeeded];
    CGSize sizeThatFits = CGSizeMake(CGRectGetWidth(self.label.bounds),
                                     CGRectGetHeight(self.tickView.bounds) + CGRectGetHeight(self.label.bounds));
    return sizeThatFits;
}

#pragma mark - Setters
- (void)setText:(NSString *)text
{
    _text = text;
    if (![self.label.text isEqualToString:text]) {
        self.label.text = text;
        [self.label sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    if (self.label.font != font) {
        self.label.font = font;
        [self.label sizeToFit];
        [self setNeedsLayout];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.label.textColor = textColor;
}

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

- (void)setLabelEdgeInsets:(UIEdgeInsets)labelEdgeInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_labelEdgeInsets, labelEdgeInsets)) {
        return;
    }
    _labelEdgeInsets = labelEdgeInsets;
    self.label.edgeInsets = labelEdgeInsets;
    [self.label sizeToFit];
    [self setNeedsLayout];
}

@end
