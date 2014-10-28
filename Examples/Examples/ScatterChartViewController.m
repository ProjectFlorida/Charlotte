//
//  ScatterChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/28/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "ScatterChartViewController.h"

@interface ScatterChartViewController () <CHChartViewDataSource, CHScatterChartViewDataSource>

@end

@implementation ScatterChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chartView.dataSource = self;
    self.chartView.scatterChartDataSource = self;
}

#pragma mark - CHScatterChartViewDataSource

- (NSInteger)chartView:(CHChartView *)chartView numberOfScatterPointsInPage:(NSInteger)page
{
    return 100;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return 4.5;
}

#pragma mark - CHChartViewDataSource

- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView
{
    return 1;
}

- (UILabel *)chartView:(CHChartView *)chartView xAxisLabelForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return nil;
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return 1;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return 4;
}

- (UILabel *)chartView:(CHChartView *)chartView labelForPointWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    return nil;
}

- (NSInteger)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page
{
    return 0;
}

- (NSInteger)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page
{
    return 7;
}

- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView
{
    return 5;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index
{
    return index + 1;
}


@end