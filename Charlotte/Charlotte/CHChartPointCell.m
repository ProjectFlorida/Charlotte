//
//  CHChartPointCell.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartPointCell.h"

NSString *const kCHChartPointCellReuseId = @"ChartPointCell";

@interface CHChartPointCell ()

@property (nonatomic, strong) UILabel *xAxisLabel;

@end

@implementation CHChartPointCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _xAxisLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _xAxisLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_xAxisLabel];
        NSLayoutConstraint *xAxisLabelCenterX = [NSLayoutConstraint constraintWithItem:_xAxisLabel
                                                                             attribute:NSLayoutAttributeCenterX
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1
                                                                              constant:0];
        NSArray *xAxisLabelV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_xAxisLabel]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(_xAxisLabel)];
        [self addConstraint:xAxisLabelCenterX];
        [self addConstraints:xAxisLabelV];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)setXAxisLabelText:(NSString *)text
{
    self.xAxisLabel.text = text;
    [self.xAxisLabel sizeToFit];
}


@end
