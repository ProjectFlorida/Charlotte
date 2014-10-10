//
//  FirstViewController.m
//  Examples
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController () <CHChartViewDataSource, CHChartViewDelegate>

@property (nonatomic, strong) NSArray *minValues;
@property (nonatomic, strong) NSArray *maxValues;
@property (nonatomic, strong) NSArray *xAxisLabels;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.minValues = @[@1, @2, @0, @1, @2, @1];
    self.maxValues = @[@5, @4, @7, @5, @8, @5];
    self.xAxisLabels = @[@"M", @"T", @"W", @"Th", @"F", @"S", @"Su"];
    self.currentIndex = 0;
    self.chartView.delegate = self;
    self.chartView.dataSource = self;
    [self.chartView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.chartView scrollToPage:3 animated:NO];
}

#pragma mark CHChartViewDataSource

- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView
{
    return self.minValues.count;
}

- (NSString *)chartView:(CHChartView *)chartView xAxisLabelForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return self.xAxisLabels[index];
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return 7;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return 3;
}

- (NSInteger)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page
{
    return [self.minValues[self.currentIndex] integerValue];
}

- (NSInteger)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page
{
    return [self.maxValues[self.currentIndex] integerValue];
}

- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView
{
    return 5;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index
{
    return index;
}

#pragma mark CHChartViewDelegate

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page
{
    self.currentIndex = page;
}

@end
