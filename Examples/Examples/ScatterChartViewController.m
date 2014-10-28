//
//  ScatterChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/28/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "ScatterChartViewController.h"

@interface ScatterChartViewController () <CHChartViewDataSource, CHScatterChartViewDataSource, CHLineChartViewDataSource>

@end

@implementation ScatterChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.36 blue:0.17 alpha:1];
    self.chartView.backgroundColor = [UIColor clearColor];
    self.chartView.dataSource = self;
    self.chartView.lineChartDataSource = self;
    self.chartView.xAxisLineHidden = YES;
    self.chartView.scatterChartDataSource = self;
}

#pragma mark - CHScatterChartViewDataSource

- (NSInteger)chartView:(CHScatterChartView *)chartView numberOfScatterPointsInPage:(NSInteger)page
{
    return 200;
}

- (CGFloat)chartView:(CHScatterChartView *)chartView valueForScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return sin(index)*2 + 2.5;
}

- (UIColor *)chartView:(CHScatterChartView *)chartView colorForScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (CGFloat)chartView:(CHScatterChartView *)chartView radiusForScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return 2;
}

#pragma mark - CHLineChartDataSource

- (UIColor *)chartView:(CHLineChartView *)chartView lineTintColorInPage:(NSInteger)page
{
    return [UIColor colorWithRed:1 green:0.74 blue:0.63 alpha:1];
}

#pragma mark - CHChartViewDataSource

- (UILabel *)chartView:(CHChartView *)chartView xAxisLabelForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    if (index == 10) {
        label.text = @"March";
        return label;
    }
    else if (index == 20) {
        label.text = @"April";
        return label;
    }   
    else if (index == 30) {
        label.text = @"May";
        return label;
    }
    else if (index == 40) {
        label.text = @"June";
        return label;
    }   
    else if (index == 50) {
        label.text = @"July";
        return label;
    }
    else {
        return nil;
    }
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return 60;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return pow(1.3, (index/20.0));
}

- (UILabel *)chartView:(CHChartView *)chartView labelForPointWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    return nil;
}

- (CGFloat)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page
{
    return 0;
}

- (CGFloat)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end