//
//  LineChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "LineChartViewController.h"

@interface LineChartViewController () <CHChartViewDataSource, CHChartViewDelegate, CHLineChartViewDelegate, CHLineChartViewDataSource>

@property (nonatomic, strong) NSArray *xAxisLabels;
@property (nonatomic, strong) UIView *tooltipView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger pointCount;

@end

@implementation LineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0.12 green:0.26 blue:0.49 alpha:1];
    self.pointCount = 100;
    self.currentIndex = 0;

    self.tooltipView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 80, 50)];
    self.tooltipView.backgroundColor = [UIColor whiteColor];
    self.tooltipView.alpha = 0;
    [self.view addSubview:self.tooltipView];

    self.xAxisLabels = @[@"M", @"T", @"W", @"Th", @"F", @"S", @"Su"];
    self.chartView.dataSource = self;
    self.chartView.delegate = self;
    self.chartView.lineChartDelegate = self;
    self.chartView.lineChartDataSource = self;
    self.chartView.backgroundColor = [UIColor clearColor];
    self.chartView.backgroundColor = [UIColor colorWithRed:0.12 green:0.26 blue:0.49 alpha:1];
    self.chartView.headerHeight = 30;
    [self.chartView reloadData];
}

#pragma mark CHChartViewDataSource

- (UILabel *)chartView:(CHChartView *)chartView xAxisLabelForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    NSString *labelText;
    if (index == 10) {
        labelText = @"11:24pm";
    }
    else if (index == 50) {
        labelText = @"2:58am";
    }
    else if (index == 90) {
        labelText = @"7:04am";
    }
    if (labelText) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        label.text = labelText;
        [label sizeToFit];
        return label;
    }
    else {
        return nil;
    }
}

- (UIView *)labelViewForYAxisInChartView:(CHChartView *)chartView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"❤️";
    [label sizeToFit];
    return label;
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

- (CGFloat)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page
{
    return 0;
}

- (CGFloat)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page
{
    return 6.1;
}

- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView
{
    return 6;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index
{
    return index + 1;
}

#pragma mark CHLineChartDataSource

- (NSArray *)chartView:(CHLineChartView *)chartView regionsInPage:(NSInteger)page
{
    UIColor *blue = [UIColor colorWithRed:0.35 green:0.54 blue:0.82 alpha:0.5];
    UIColor *green = [UIColor colorWithRed:0.47 green:0.69 blue:0.02 alpha:0.5];
    return @[
             [CHChartRegion regionWithRange:NSMakeRange(30, 10) color:blue tintColor:self.view.backgroundColor],
             [CHChartRegion regionWithRange:NSMakeRange(65, 10) color:green tintColor:self.view.backgroundColor],
             [CHChartRegion regionWithRange:NSMakeRange(75, 20) color:blue tintColor:self.view.backgroundColor]
             ];
}

- (UIColor *)chartView:(CHLineChartView *)chartView lineColorInPage:(NSInteger)page
{
    return [UIColor whiteColor];
}

#pragma mark CHChartViewDelegate

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page
{
    self.currentIndex = page;
}

#pragma mark CHLineChartViewDelegate

- (void)chartView:(CHLineChartView *)chartView highlightBeganInPage:(NSInteger)page
          atIndex:(NSInteger)index value:(CGFloat)value position:(CGPoint)position
{
    self.tooltipView.alpha = 1;
    [self.tooltipView setCenter:CGPointMake(position.x, self.tooltipView.center.y)];
}

- (void)chartView:(CHLineChartView *)chartView highlightMovedInPage:(NSInteger)page
          toIndex:(NSInteger)index value:(CGFloat)value position:(CGPoint)position
{
    [UIView animateWithDuration:self.chartView.highlightMovementAnimationDuration animations:^{
        [self.tooltipView setCenter:CGPointMake(position.x, self.tooltipView.center.y)];
    }];
}

- (void)chartView:(CHLineChartView *)chartView highlightEndedInPage:(NSInteger)page
          atIndex:(NSInteger)index value:(CGFloat)value position:(CGPoint)position
{
    self.tooltipView.alpha = 0;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
