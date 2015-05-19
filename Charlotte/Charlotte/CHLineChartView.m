//
//  CHLineChartView.m
//  Charlotte
//
//  Created by Ben Guo on 10/15/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHLineChartView.h"
#import "CHLineView.h"
#import "CHBarChartViewProtected.h"
#import "CHPagingLineChartFlowLayout.h"
#import "CHTouchGestureRecognizer.h"
#import "CHGradientView.h"
#import "CHFooterView.h"
#import "CHBarChartCell.h"
#import "CHMathUtils.h"

NSString *const CHSupplementaryElementKindLine = @"CHSupplementaryElementKindLine";

@interface CHLineChartView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) CHTouchGestureRecognizer *touchGR;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGR;
@property (nonatomic, strong) UIView *cursorView;
@property (nonatomic, strong) UIView *cursorDotView;
@property (nonatomic, assign) BOOL cursorIsActive;
@property (nonatomic, strong) NSArray *lineGradientColors;
@property (nonatomic, strong) NSArray *lineGradientLocations;
@property (nonatomic, strong) CHFooterView *footerView;
@property (nonatomic, strong) CHLineView *lineView;

@end

@implementation CHLineChartView

- (void)initialize
{
    [super initialize];

    _lineWidth = 2;
    _lineColor = [UIColor whiteColor];
    _lineGradientColors = @[_lineColor];
    _lineGradientLocations = @[@0];

    _footerView = [[CHFooterView alloc] initWithFrame:CGRectZero];
    _lineView = [[CHLineView alloc] initWithFrame:CGRectZero];
    _lineView.footerHeight = self.footerHeight;
    _lineView.lineWidth = _lineWidth;
    _lineView.lineColor = _lineColor;

    [self addSubview:_lineView];
    [self addSubview:_footerView];

    _cursorEnabled = YES;
    _cursorIsActive = NO;
    _cursorMovementAnimationDuration = 0.2;
    _cursorEntranceAnimationDuration = 0.15;
    _cursorExitAnimationDuration = 0.15;
    _cursorWidth = 1;
    _cursorDotRadius = 4;
    _cursorTopInset = 20;
    _cursorView = [[UIView alloc] initWithFrame:CGRectZero];
    _cursorView.backgroundColor = [UIColor whiteColor];
    _cursorView.alpha = 0;
    _cursorDotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cursorDotRadius*2, _cursorDotRadius*2)];
    _cursorDotView.backgroundColor = [UIColor whiteColor];
    _cursorDotView.layer.cornerRadius = _cursorDotRadius;
    _cursorDotView.alpha = 0;
    [self addSubview:_cursorView];
    [self addSubview:_cursorDotView];

    _longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    _longPressGR.minimumPressDuration = 0.1;
    [self addGestureRecognizer:_longPressGR];

    _touchGR = [[CHTouchGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchGesture:)];
    _touchGR.enabled = NO;
    _touchGR.delegate = self;
    [self addGestureRecognizer:_touchGR];

    self.multipleTouchEnabled = NO;

    [self.collectionView removeFromSuperview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGFloat widthMinusInsets = CGRectGetWidth(bounds) - self.pageInset.right - self.pageInset.left;
    self.lineView.frame = CGRectMake(self.pageInset.left, 0, widthMinusInsets, CGRectGetHeight(bounds));
    self.footerView.frame = CGRectMake(self.pageInset.left, CGRectGetMaxY(bounds) - self.footerHeight,
                                       widthMinusInsets,
                                       self.footerHeight);
    self.lineView.gradientColors = self.lineGradientColors;
    self.lineView.gradientLocations = self.lineGradientLocations;
}

- (void)setLineColors:(NSArray *)colors locations:(NSArray *)locations
{
    self.lineGradientColors = colors;
    self.lineGradientLocations = locations;
    self.lineView.gradientColors = colors;
    self.lineView.gradientLocations = locations;
}

- (void)reloadData
{
    [super reloadData];
    NSInteger pointCount = [self.dataSource chartView:self numberOfPointsInPage:0];
    // clamp to a reasonable range
    pointCount = MIN(MAX(0, pointCount), 1000);
    if ([self.dataSource respondsToSelector:@selector(chartView:indicesOfXAxisLabelsInPage:)] &&
        [self.dataSource respondsToSelector:@selector(chartView:configureXAxisLabelView:forPointInPage:atIndex:)]) {
        NSArray *indices = [self.dataSource chartView:self indicesOfXAxisLabelsInPage:0];
        for (NSNumber *index in indices) {
            NSUInteger i = [index unsignedIntegerValue];
            UIView *labelView = [[self.xAxisLabelViewClass alloc] init];
            [self.dataSource chartView:self configureXAxisLabelView:labelView forPointInPage:0
                               atIndex:i];
            [labelView sizeToFit];
            CGFloat relativeX = 0.5;
            if (pointCount > 1) {
                relativeX = (i/(float)(pointCount)) + (0.5/(float)(pointCount));
            }
            [self.footerView setXAxisLabelView:labelView atRelativeXPosition:relativeX];
        }
    }

    CGFloat min = [self.dataSource chartView:self minValueForPage:self.currentPage];
    CGFloat max = [self.dataSource chartView:self maxValueForPage:self.currentPage];
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:pointCount];
    for (int i = 0; i < pointCount; i++) {
        id value = [self.dataSource chartView:self valueForPointInPage:0 atIndex:i];
        if (!value) {
            value = [NSNull null];
        }
        [values addObject:value];
    }
    [self.lineView setMinValue:min maxValue:max animated:NO completion:nil];
    [self.lineView drawLineWithValues:values animated:YES];
}

#pragma mark - Setters
- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.lineView.lineWidth = lineWidth;
}

- (void)setCursorColor:(UIColor *)cursorColor
{
    _cursorColor = cursorColor;
    self.cursorView.backgroundColor = cursorColor;
    self.cursorDotView.backgroundColor = cursorColor;
}

- (void)setCursorDotRadius:(CGFloat)cursorDotRadius
{
    _cursorDotRadius = cursorDotRadius;
    self.cursorDotView.frame = CGRectMake(CGRectGetMinX(self.cursorDotView.frame),
                                          CGRectGetMinY(self.cursorDotView.frame),
                                          cursorDotRadius*2, cursorDotRadius*2);
    self.cursorDotView.layer.cornerRadius = cursorDotRadius;
}

- (void)setLineDrawingAnimationDuration:(NSTimeInterval)lineDrawingAnimationDuration
{
    _lineDrawingAnimationDuration = lineDrawingAnimationDuration;
    [[CHLineView appearance] setLineDrawingAnimationDuration:_lineDrawingAnimationDuration];
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
    self.lineView.footerHeight = footerHeight;
    [super setFooterHeight:footerHeight];
}

#pragma mark - UIGestureRecognizerDelegate

// Make sure our gesture recognizer doesn't block other gesture recognizers
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Gesture recognizer action

- (void)handleLongPressGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.cursorEnabled) {
        return;
    }
    self.touchGR.enabled = YES;
    [self handleTouchGesture:gestureRecognizer];
}

- (void)handleTouchGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.cursorEnabled) {
        return;
    }
    CGPoint touchLocation = [gestureRecognizer locationInView:self];
    NSInteger pointCount = [self.dataSource chartView:self numberOfPointsInPage:self.currentPage];
    UIEdgeInsets sectionInset = self.sectionInset;
    UIEdgeInsets pageInset = self.pageInset;
    CGFloat sectionInsetWidth = sectionInset.left + sectionInset.right;
    CGFloat pageInsetWidth = pageInset.left + pageInset.right;
    CGFloat cellWidth = (self.bounds.size.width - sectionInsetWidth - pageInsetWidth)/pointCount;
    NSInteger index = (touchLocation.x - pageInset.left - sectionInset.left)/cellWidth;

    CGFloat trueMinValue = [CHMathUtils trueMinValueWithMin:self.lineView.minValue max:self.lineView.maxValue
                                                     height:CGRectGetHeight(self.bounds)
                                               footerHeight:self.footerHeight];
    index = MIN(MAX(0, index), pointCount - 1);
    NSNumber *value = [self.dataSource chartView:self valueForPointInPage:self.currentPage atIndex:index];
    BOOL isOnNullValue = !value || [value isKindOfClass:[NSNull class]];
    CGFloat y = [CHMathUtils yPositionWithValue:[value floatValue]
                                            min:trueMinValue
                                            max:self.lineView.maxValue
                                         height:CGRectGetHeight(self.bounds)];
    CGFloat x = (index * cellWidth) + cellWidth*0.5 + pageInset.left + sectionInset.left;
    CGPoint highlightPointPosition = CGPointMake(x, y);

    BOOL touchBegan = NO;
    if ((gestureRecognizer.state == UIGestureRecognizerStateBegan && !isOnNullValue) ||
        (gestureRecognizer.state == UIGestureRecognizerStateChanged && !self.cursorIsActive && !isOnNullValue)) {
        self.cursorIsActive = YES;
        [UIView animateWithDuration:self.cursorEntranceAnimationDuration animations:^{
            self.cursorView.alpha = 1;
            self.cursorDotView.alpha = 1;
        }];
        touchBegan = YES;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
             gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        self.cursorIsActive = NO;
        [UIView animateWithDuration:self.cursorExitAnimationDuration animations:^{
            self.cursorView.alpha = 0;
            self.cursorDotView.alpha = 0;
        } completion:^(BOOL finished) {
            if ([self.lineChartDelegate respondsToSelector:@selector(chartView:cursorDisappearedAtIndex:value:position:)]) {
                [self.lineChartDelegate chartView:self cursorDisappearedAtIndex:index value:[value floatValue] position:highlightPointPosition];
            }
        }];
        self.touchGR.enabled = NO;
    }

    void(^updateBlock)() = ^() {
        self.cursorView.frame = CGRectMake(x - CGRectGetWidth(self.cursorView.bounds)/2.0,
                                           self.cursorTopInset,
                                           self.cursorWidth,
                                           MAX(0, y - self.cursorTopInset));
        self.cursorDotView.center = CGPointMake(x, y);
    };

    if (isOnNullValue) {
        return;
    }

    if (!touchBegan) {
        [UIView animateWithDuration:self.cursorMovementAnimationDuration animations:^{
            updateBlock();
        }];
    }
    else {
        updateBlock();
    }

    if (touchBegan) {
        if ([self.lineChartDelegate respondsToSelector:@selector(chartView:cursorAppearedAtIndex:value:position:)]) {
            [self.lineChartDelegate chartView:self cursorAppearedAtIndex:index value:[value floatValue] position:highlightPointPosition];
        }
    }
    else if (self.cursorIsActive) {
        if ([self.lineChartDelegate respondsToSelector:@selector(chartView:cursorMovedToIndex:value:position:)]) {
            [self.lineChartDelegate chartView:self cursorMovedToIndex:index value:[value floatValue] position:highlightPointPosition];
        }
    }
}

@end
