//
//  BarChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "BarChartViewController.h"

@interface BarChartViewController () <CHChartViewDataSource, CHChartViewDelegate, CHBarChartDataSource>

@property (nonatomic, strong) NSArray *minValues;
@property (nonatomic, strong) NSArray *maxValues;
@property (nonatomic, strong) NSArray *xAxisLabels;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) UIColor *incompleteColor;

@end

@implementation BarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.minValues = @[@0, @0,  @(-7), @0, @(-4), @0];
    self.maxValues = @[@7, @14, @14,   @9, @13,   @11];
    self.xAxisLabels = @[@"M", @"T", @"W", @"Th", @"F", @"S", @"Su"];
    self.currentIndex = 0;
    self.chartView.delegate = self;
    self.chartView.dataSource = self;
    self.chartView.barChartDataSource = self;
    self.chartView.backgroundColor = [UIColor colorWithRed:0.14 green:0.19 blue:0.27 alpha:1];
    self.barColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    self.barTintColor = [UIColor colorWithRed:0.52 green:0.62 blue:0.77 alpha:1];
    self.incompleteColor = [UIColor colorWithRed:0.35 green:0.41 blue:0.5 alpha:1];
    [self.chartView reloadData];
}

#pragma mark - CHChartViewDataSource

- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView
{
    return self.minValues.count;
}

- (UILabel *)chartView:(CHChartView *)chartView xAxisLabelForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.text = self.xAxisLabels[index];
    label.font = [UIFont systemFontOfSize:13];
    if (index == 3) {
        label.textColor = [UIColor whiteColor];
    }
    else {
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return label;
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return 7;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return index;
}

- (UILabel *)chartView:(CHChartView *)chartView labelForPointWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%d", (int)roundf(value)];
    label.font = [UIFont boldSystemFontOfSize:18];
    if (index == 0) {
        label.alpha = 0;
    }
    else if (index == 6) {
        label.textColor = self.incompleteColor;
    }
    else {
        label.textColor = [UIColor whiteColor];
    }
    return label;
}

- (NSInteger)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page
{
    return [self.minValues[page] integerValue];
}

- (NSInteger)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page
{
    return [self.maxValues[page] integerValue];
}

- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView
{
    return 5;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index
{
    return index + 1;
}

#pragma mark - CHBarChartDataSource

- (UIColor *)chartView:(CHChartView *)chartView colorForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (value == 0) {
        return [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    else if (value == 6) {
        return [UIColor clearColor];
    }
    else {
        return [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
}

- (UIColor *)chartView:(CHChartView *)chartView tintColorForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (value == 0 || value == 6) {
        return nil;
    }
    else {
        return self.barTintColor;
    }
}

- (NSArray *)chartView:(CHChartView *)chartView borderDashPatternForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 6) {
        return @[@2, @2];
    }
    else {
        return nil;
    }
}

- (UIColor *)chartView:(CHChartView *)chartView borderColorForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 6) {
        return self.incompleteColor;
    }
    else {
        return nil;
    }
}

- (CGFloat)chartView:(CHChartView *)chartView borderWidthForBarWithValue:(CGFloat)value
              inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 6) {
        return 2;
    }
    else {
        return 0;
    }
}

- (CGFloat)chartView:(CHChartView *)chartView shadowOpacityForBarWithValue:(CGFloat)value
              inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (value == 0) {
        return 0;
    }
    else {
        return 0.5;
    }
}


#pragma mark - CHChartViewDelegate

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page
{
    self.currentIndex = page;
}

@end
