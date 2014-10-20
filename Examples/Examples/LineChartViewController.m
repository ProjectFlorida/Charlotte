//
//  LineChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "LineChartViewController.h"

@interface LineChartViewController () <CHChartViewDataSource, CHChartViewDelegate, CHChartTouchDelegate>

@property (nonatomic, strong) NSArray *xAxisLabels;
@property (nonatomic, strong) UIView *tooltipView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger pointCount;

@end

@implementation LineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pointCount = 100;
    self.currentIndex = 0;

    self.tooltipView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 80, 50)];
    self.tooltipView.backgroundColor = [UIColor whiteColor];
    self.tooltipView.alpha = 0;
    [self.view addSubview:self.tooltipView];

    self.xAxisLabels = @[@"M", @"T", @"W", @"Th", @"F", @"S", @"Su"];
    self.chartView.dataSource = self;
    self.chartView.delegate = self;
    self.chartView.touchDelegate = self;
    self.chartView.backgroundColor = [UIColor colorWithRed:0.12 green:0.26 blue:0.49 alpha:1];
    [self.chartView reloadData];
}

#pragma mark CHChartViewDataSource

- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView
{
    return 1;
}

- (NSString *)chartView:(CHChartView *)chartView xAxisLabelStringForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 10) {
        return @"11:24pm";
    }
    else if (index == 50) {
        return @"2:58am";
    }
    else if (index == 90) {
        return @"7:04am";
    }
    else {
        return nil;
    }
}

- (UIColor *)chartView:(CHChartView *)chartView xAxisLabelColorForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return [UIColor whiteColor];
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return self.pointCount;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return sin(index*3)*sin(index*2) + page + 3;
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

#pragma mark CHChartTouchDelegate

- (void)chartView:(CHChartView *)chartView touchBeganInPage:(NSInteger)page nearestIndex:(NSInteger)index
{
    CGFloat cellWidth = self.view.bounds.size.width / self.pointCount;
    CGFloat xPosition = (cellWidth * index) + (cellWidth/2.0);
    self.tooltipView.alpha = 1;
    [self.tooltipView setCenter:CGPointMake(xPosition, self.tooltipView.center.y)];
}

- (void)chartView:(CHChartView *)chartView touchMovedInPage:(NSInteger)page nearestIndex:(NSInteger)index
{
    CGFloat cellWidth = self.view.bounds.size.width / self.pointCount;
    CGFloat xPosition = (cellWidth * index) + (cellWidth/2.0);
    [UIView animateWithDuration:self.chartView.highlightMovementAnimationDuration animations:^{
        [self.tooltipView setCenter:CGPointMake(xPosition, self.tooltipView.center.y)];
    }];
}

- (void)chartView:(CHChartView *)chartView touchEndedInPage:(NSInteger)page nearestIndex:(NSInteger)index
{
    self.tooltipView.alpha = 0;
}

#pragma mark CHChartViewDelegate

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page
{
    self.currentIndex = page;
}

@end
