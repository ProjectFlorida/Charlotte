//
//  BarChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "BarChartViewController.h"
#import <Charlotte/Charlotte.h>

@interface BarChartViewController () <CHChartViewDataSource, CHChartViewDelegate, CHBarChartViewDataSource>

@property (nonatomic, strong) CHBarChartView *chartView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *minValues;
@property (nonatomic, strong) NSArray *maxValues;
@property (nonatomic, strong) NSArray *averages;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *xAxisLabels;
@property (nonatomic, strong) NSArray *gridlineValues;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIColor *barColor;

@end

@implementation BarChartViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"CHBarChartView";

        [[CHBarChartView appearance] setPageTransitionAnimationDuration:0.5];
        [[CHBarChartView appearance] setPageTransitionAnimationSpringDamping:0.7];

        _chartView = [[CHBarChartView alloc] initWithFrame:CGRectZero];
        _chartView.delegate = self;
        _chartView.dataSource = self;
        _chartView.barChartDataSource = self;
        _chartView.headerHeight = 0;
        _chartView.backgroundColor = [UIColor clearColor];
        _chartView.relativeBarWidth = 0.3;

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:_chartView];

        _minValues = @[@0, @0, @0, @0,  @0];
        _maxValues = @[@120, @40, @75, @60, @50];
        _averages = @[@35, @40, @50, @45, @55];
        _values = @[
                    @[@0, @20, @30, @40, @50, @60, @30],
                    @[@0, @20, @30, @40, @50, @60, @30],
                    @[@0, @20, @30, @40, @50, @60, @30],
                    @[@70, @0, @50, @40, @70, @60, @45],
                    @[@10, @20, @0, @50, @70, @80, @40]
                    ];
        _gridlineValues = @[@0, @40, @52, @60, @80, @100, @120];
        _xAxisLabels = @[@"M", @"T", @"W", @"Th", @"F", @"S", @"Su"];
        _currentIndex = 0;

        _barColor = [UIColor whiteColor];

        [self.view addSubview:_scrollView];
        self.view.backgroundColor = [UIColor colorWithRed:0.33 green:0.62 blue:0.55 alpha:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chartView reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect bounds = self.view.bounds;
    self.scrollView.frame = bounds;
    self.scrollView.contentSize = CGSizeMake(bounds.size.width, bounds.size.height*1.5);
    self.chartView.frame = CGRectMake(0, 50, CGRectGetWidth(bounds), 350);
    CGFloat pageMargin = CGRectGetWidth(bounds)*0.1;
    self.chartView.sectionInset = UIEdgeInsetsMake(0, pageMargin*0.5, 0, pageMargin*0.5);
    self.chartView.pageInset = UIEdgeInsetsMake(0, pageMargin, 0, pageMargin);
}

#pragma mark - CHChartViewDataSource

- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView
{
    return self.minValues.count;
}

- (void)configureXAxisLabel:(UILabel *)label forPointInPage:(NSInteger)page atIndex:(NSInteger)index
                inChartView:(CHChartView *)chartView
{
    label.text = self.xAxisLabels[index];
    label.font = [UIFont systemFontOfSize:13];
    if (index == 3) {
        label.textColor = [UIColor whiteColor];
    }
    else {
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    [label sizeToFit];
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return [self.values[page] count];
}

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return [self.values[page][index] floatValue];
}

- (void)configureLabel:(UILabel *)label forPointWithValue:(CGFloat)value inPage:(NSInteger)page
               atIndex:(NSInteger)index inChartView:(CHChartView *)chartView;
{
    label.text = [NSString stringWithFormat:@"%d", (int)roundf(value)];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.alpha = (value == 0) ? 0 : 1;
    label.textColor = (index == 5) ? [UIColor colorWithWhite:0.5 alpha:1] : [UIColor whiteColor];
    [label sizeToFit];
}

- (CGFloat)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page
{
    return [self.minValues[page] floatValue];
}

- (CGFloat)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page
{
    return [self.maxValues[page] floatValue];
}

- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView
{
    return self.gridlineValues.count;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index
{
    if (index == 2) {
        return [self.averages[self.currentIndex] floatValue];
    }
    else {
        return [self.gridlineValues[index] floatValue];
    }
}

- (UIView *)chartView:(CHChartView *)chartView leftLabelViewForHorizontalGridlineWithValue:(CGFloat)value atIndex:(NSInteger)index
{
    if (index != 2) {
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%d", (int)value];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        return label;
    }
    else {
        return nil;
    }
}

- (UIView *)chartView:(CHChartView *)chartView lowerLeftLabelViewForHorizontalGridlineWithValue:(CGFloat)value atIndex:(NSInteger)index
{
    if (index != 2 && value != 0) {
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%d", arc4random_uniform(100)];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textColor = [UIColor lightGrayColor];
        [label sizeToFit];
        return label;
    }
    else {
        return nil;
    }
}

- (UIView *)chartView:(CHChartView *)chartView rightLabelViewForHorizontalGridlineWithValue:(CGFloat)value atIndex:(NSInteger)index
{
    if (index == 2) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.numberOfLines = 0;
        label.text = @"Avg";
        label.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [label sizeToFit];
        return label;
    }
    else {
        return nil;
    }
}

- (NSArray *)chartView:(CHChartView *)chartView lineDashPatternForHorizontalGridlineAtIndex:(NSInteger)index
{
    if (index == 2) {
        return @[@1, @3];
    }
    else {
        return nil;
    }
}

- (UIColor *)chartView:(CHChartView *)chartView lineColorForHorizontalGridlineAtIndex:(NSInteger)index
{
    if (index == 2) {
        return [UIColor colorWithRed:0.79 green:1 blue:0.95 alpha:1];
    }
    else {
        return [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
}

- (UIEdgeInsets)chartView:(CHChartView *)chartView lineInsetForHorizontalGridlineAtIndex:(NSInteger)index
{
    if (index == 2) {
        return UIEdgeInsetsMake(0, 0, 0, 30);
    }
    else {
        return UIEdgeInsetsMake(0, 30, 0, 0);
    }
}

#pragma mark - CHBarChartDataSource

- (UIColor *)chartView:(CHBarChartView *)chartView colorForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (value == 0) {
        return [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    else if (index == 5) {
        return [UIColor clearColor];
    }
    else {
        return [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
}

- (NSArray *)chartView:(CHBarChartView *)chartView borderDashPatternForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 5) {
        return @[@2, @2];
    }
    else {
        return nil;
    }
}

- (UIColor *)chartView:(CHBarChartView *)chartView borderColorForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 5) {
        return [UIColor colorWithWhite:0.5 alpha:1];
    }
    else {
        return nil;
    }
}

- (CGFloat)chartView:(CHChartView *)chartView borderWidthForBarWithValue:(CGFloat)value
              inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 5) {
        return 2;
    }
    else {
        return 0;
    }
}

#pragma mark - CHChartViewDelegate

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page
{
    self.currentIndex = page;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
