//
//  BarChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "BarChartViewController.h"

@interface BarChartViewController () <CHChartViewDataSource, CHChartViewDelegate>

@property (nonatomic, strong) NSArray *minValues;
@property (nonatomic, strong) NSArray *maxValues;
@property (nonatomic, strong) NSArray *xAxisLabels;
@property (nonatomic, assign) NSInteger currentIndex;

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
    self.chartView.backgroundColor = [UIColor colorWithRed:0.14 green:0.19 blue:0.27 alpha:1];
    [self.chartView reloadData];
}

#pragma mark CHChartViewDataSource

- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView
{
    return self.minValues.count;
}

- (NSString *)chartView:(CHChartView *)chartView xAxisLabelStringForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return self.xAxisLabels[index];
}

- (UIColor *)chartView:(CHChartView *)chartView xAxisLabelColorForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 3) {
        return [UIColor whiteColor];
    }
    else {
        return [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    }
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return 7;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return index;
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

#pragma mark CHChartViewDelegate

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page
{
    self.currentIndex = page;
}

@end
