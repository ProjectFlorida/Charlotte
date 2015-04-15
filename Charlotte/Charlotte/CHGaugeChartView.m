//
//  CHGaugeChartView.m
//  Charlotte
//
//  Created by Ben Guo on 3/30/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import "CHGaugeChartView.h"
#import "CHXAxisLabelView.h"
#import "CHGradientView.h"
#import "CHGaugeChartContentView.h"
#import "CHLabel.h"

@interface CHGaugeChartView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CHGaugeChartContentView *contentView;
@property (nonatomic, strong) NSMutableArray *regionLabels;

@end

@implementation CHGaugeChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bandHeight = 100;
        _animationDuration = 0.5;
        _animationSpringDamping = 0.7;

        _regionLabels = [NSMutableArray array];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;

        _contentView = [[CHGaugeChartContentView alloc] initWithFrame:CGRectZero];
        _contentView.parentView = self;
        [_scrollView addSubview:_contentView];
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    if (CGRectEqualToRect(self.scrollView.frame, bounds)) {
        return;
    }
    
    self.scrollView.frame = bounds;
    self.scrollView.contentSize = CGSizeMake(bounds.size.width+1, bounds.size.height);
    self.contentView.frame = self.scrollView.bounds;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)animateToVisibleRangeWithCenter:(CGFloat)center width:(CGFloat)width
{
    CGFloat min = center - width/2.0;
    [self animateToVisibleRangeWithMin:min length:width];
}

- (void)animateToVisibleRangeWithMin:(CGFloat)min length:(CGFloat)length
{
    BOOL noChangeInRange = (self.minVisibleValue == min) && (self.maxVisibleValue = min + length);
    if (noChangeInRange) {
        return;
    }

    CGRect contentFrame = self.contentView.frame;
    CGFloat currentRange = self.maxVisibleValue - self.minVisibleValue;
    CGFloat scale = currentRange/length;
    CGFloat targetWidth = CGRectGetWidth(contentFrame)*scale;
    CGFloat targetX = 0 - targetWidth*(min/self.contentView.maxValue);
    [UIView animateWithDuration:self.animationDuration
                          delay:0
         usingSpringWithDamping:self.animationSpringDamping
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.contentView.frame = CGRectMake(targetX,
                                                             CGRectGetMinY(contentFrame),
                                                             targetWidth,
                                                             CGRectGetHeight(contentFrame));
    } completion:nil];
    self.minVisibleValue = min;
    self.maxVisibleValue = min + length;
}

- (void)reloadPointerValue
{
    CGFloat newValue = [self.dataSource valueOfPointerInChartView:self];
    if (newValue == self.contentView.pointerValue) {
        return;
    }
    [self.contentView setPointerValueWithTransitionByMovingGradient:newValue];
}

- (void)reload
{
    // set min/max
    CGFloat minValue = [self.dataSource minValueInChartView:self];
    self.contentView.minValue = minValue;
    self.minVisibleValue = minValue;
    CGFloat maxValue = [self.dataSource maxValueInChartView:self];
    self.contentView.maxValue = maxValue;
    self.maxVisibleValue = maxValue;

    // remove all current x axis labels
    [self.contentView.xAxisLabelViews enumerateObjectsUsingBlock:^(CHXAxisLabelView *view, NSUInteger _, BOOL *__) {
        [view removeFromSuperview];
    }];
    [self.contentView.xAxisLabelViews removeAllObjects];

    // add x axis labels
    NSUInteger numberOfXAxisLabels = [self.dataSource numberOfXAxisLabelsInChartView:self];
    for (int i=0; i<numberOfXAxisLabels; i++) {
        CHXAxisLabelView *labelView = [[CHXAxisLabelView alloc] initWithFrame:CGRectZero];
        labelView.tickPosition = CHRelativeTickPositionBelow;
        labelView.value = [self.dataSource chartView:self valueOfXAxisLabelAtIndex:i];
        [self.contentView addSubview:labelView];
        [self.dataSource chartView:self configureXAxisLabelView:labelView
                           atIndex:i withValue:labelView.value];
        [self.contentView.xAxisLabelViews addObject:labelView];
    }

    // configure gradient
    NSUInteger numberOfRanges = [self.dataSource numberOfRangesInChartView:self];
    NSMutableArray *colors = [NSMutableArray array];
    NSMutableArray *locations = [NSMutableArray array];
    CGFloat range = maxValue - minValue;
    CGFloat lastLocation = 0;
    for (int i=0; i<numberOfRanges; i++) {
        UIColor *color = [self.dataSource chartView:self colorOfRangeAtIndex:i];
        // duplicate the first color as a stop at 0
        // and set the left buffer view's color
        if (i == 0) {
            [locations addObject:@0];
            [colors addObject:color];
            self.contentView.leftGradientBufferView.backgroundColor = color;
        }

        CGFloat upperBound = [self.dataSource chartView:self upperBoundOfRangeAtIndex:i];
        CGFloat location = upperBound/range;
        if (location >= lastLocation && location < 1) {
            [locations addObject:@(location)];
            [colors addObject:color];
            lastLocation = location;
        }

        // duplicate the last color as a stop at 1
        // and set the right buffer view's color
        if (i == numberOfRanges-1) {
            [locations addObject:@1];
            [colors addObject:color];
            self.contentView.rightGradientBufferView.backgroundColor = color;
        }
    }
    self.contentView.gradientView.locations = locations;
    self.contentView.gradientView.colors = colors;
    self.contentView.pointerValue = [self.dataSource valueOfPointerInChartView:self];

    [self setNeedsLayout];
}

#pragma mark - Setters
- (void)setBandHeight:(CGFloat)bandHeight
{
    if (_bandHeight == bandHeight) {
        return;
    }
    _bandHeight = bandHeight;
    self.contentView.bandHeight = bandHeight;
    [self.contentView setNeedsLayout];
}

@end
