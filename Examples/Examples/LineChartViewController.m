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

- (UILabel *)chartView:(CHChartView *)chartView xAxisLabelForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    if (index == 10) {
        label.text = @"11:24pm";
        return label;
    }
    else if (index == 50) {
        label.text = @"2:58am";
        return label;
    }
    else if (index == 90) {
        label.text = @"7:04am";
        return label;
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
