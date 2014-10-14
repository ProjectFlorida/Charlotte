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
    return CGSizeMake(UIViewNoIntrinsicMetric, CGRectGetMaxY(self.label.frame));
}

- (void)initialize
{
    _labelColor = [UIColor whiteColor];
    _labelFont = [UIFont systemFontOfSize:13];

    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    _lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];

    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.font = _labelFont;
    _label.textColor = _labelColor;

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
    NSLayoutConstraint *labelLeft = [NSLayoutConstraint constraintWithItem:_label
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_lineView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:10];
    NSDictionary *views = NSDictionaryOfVariableBindings(_lineView, _label);
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_lineView]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lineView]-(2)-[_label]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];

    [self addConstraints:@[lineViewY, lineViewHeight, labelLeft]];
    [self addConstraints:constraintsH];
    [self addConstraints:constraintsV];
}

#pragma mark - Setters

- (void)setLabelColor:(UIColor *)labelColor
{
    _labelColor = labelColor;
    self.label.textColor = labelColor;
}

- (void)setLabelFont:(UIFont *)labelFont
{
    _labelFont = labelFont;
    self.label.font = labelFont;
    [self.label sizeToFit];
    [self invalidateIntrinsicContentSize];
}

- (void)setLabelText:(NSString *)labelText
{
    _labelText = labelText;
    self.label.text = labelText;
    [self.label sizeToFit];
    [self invalidateIntrinsicContentSize];
}

@end
