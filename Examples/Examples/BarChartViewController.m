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
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.view addSubview:_scrollView];
    self.view.backgroundColor = [UIColor colorWithRed:0.33 green:0.62 blue:0.55 alpha:1];
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

- (void)chartView:(CHChartView *)chartView configureXAxisLabelView:(UIView *)view
   forPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    CHXAxisLabelView *labelView = (CHXAxisLabelView *)view;
    labelView.text = self.xAxisLabels[index];
    labelView.font = [UIFont systemFontOfSize:13];
    if (index == 3) {
        labelView.textColor = [UIColor whiteColor];
    }
    else {
        labelView.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return [self.values[page] count];
}

- (NSNumber *)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    NSNumber *value = self.values[page][index];
    if ([value floatValue] == 0) {
        return nil;
    }
    else {
        return self.values[page][index];
    }
}

- (void)chartView:(CHChartView *)chartView configureCell:(CHBarChartCell *)cell
   forPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    NSNumber *value = self.values[page][index];
    cell.glowRadius = 5;
    cell.valueLabelView.upperLabel.text = [NSString stringWithFormat:@"%d", (int)roundf([value floatValue])];
    cell.valueLabelView.lowerLabel.text = @"foo";
    cell.valueLabelView.upperLabel.font = [UIFont boldSystemFontOfSize:18];
    cell.valueLabelView.lowerLabel.font = [UIFont boldSystemFontOfSize:18];
    cell.valueLabelView.upperLabel.textColor = (index == 5) ? [UIColor colorWithWhite:0.5 alpha:1] : [UIColor whiteColor];
    cell.valueLabelView.lowerLabel.textColor = [UIColor grayColor];
    [cell.valueLabelView.upperLabel sizeToFit];
    [cell.valueLabelView.lowerLabel sizeToFit];
    [cell.valueLabelView setNeedsLayout];
    [cell.valueLabelView sizeToFit];
}

- (CGFloat)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page
{
    return [self.minValues[page] floatValue];
}

- (CGFloat)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page
{
    return [self.maxValues[page] floatValue];
}

- (NSInteger)numberOfGridlinesInChartView:(CHChartView *)chartView
{
    return self.gridlineValues.count;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForGridlineAtIndex:(NSInteger)index
{
    if (index == 2) {
        return [self.averages[self.currentIndex] floatValue];
    }
    else {
        return [self.gridlineValues[index] floatValue];
    }
}

- (void)chartView:(CHChartView *)chartView configureGridlineView:(CHGridlineView *)gridlineView withValue:(CGFloat)value atIndex:(NSInteger)index
{
    if (index != 2) {
        gridlineView.leftLabel.text = [NSString stringWithFormat:@"%d", (int)value];
        gridlineView.leftLabel.font = [UIFont boldSystemFontOfSize:12];
        gridlineView.leftLabel.textColor = [UIColor whiteColor];
        [gridlineView.leftLabel sizeToFit];
        gridlineView.lowerLeftLabel.text = @"foo";
        gridlineView.lowerLeftLabel.font = [UIFont systemFontOfSize:12];
        gridlineView.lowerLeftLabel.textColor = [UIColor grayColor];
        [gridlineView.lowerLeftLabel sizeToFit];
        gridlineView.lineInset = UIEdgeInsetsMake(0, 30, 0, 0);
        gridlineView.lineColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    else {
        gridlineView.rightLabel.text = @"Avg";
        gridlineView.rightLabel.textColor = [UIColor grayColor];
        gridlineView.rightLabel.font = [UIFont boldSystemFontOfSize:13];
        [gridlineView.rightLabel sizeToFit];
        gridlineView.lineDashPattern = @[@1, @3];
        gridlineView.lineInset = UIEdgeInsetsMake(0, 0, 0, 30);
        gridlineView.lineColor = [UIColor grayColor];
    }
}

#pragma mark - CHBarChartDataSource

- (UIColor *)chartView:(CHBarChartView *)chartView colorForBarInPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 0) {
        return [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    else if (index == 5) {
        return [UIColor clearColor];
    }
    else {
        return [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
}

- (NSArray *)chartView:(CHBarChartView *)chartView borderDashPatternForBarInPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 5) {
        return @[@2, @2];
    }
    else {
        return nil;
    }
}

- (UIColor *)chartView:(CHBarChartView *)chartView borderColorForBarInPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 5) {
        return [UIColor colorWithWhite:0.5 alpha:1];
    }
    else {
        return nil;
    }
}

- (CGFloat)chartView:(CHChartView *)chartView borderWidthForBarInPage:(NSInteger)page atIndex:(NSInteger)index
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
