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
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *xAxisLabels;
@property (nonatomic, strong) NSArray *gridlineValues;
@property (nonatomic, strong) NSArray *gridlineTopLabels;
@property (nonatomic, strong) NSArray *gridlineBottomLabels;
@property (nonatomic, strong) UIColor *chartColor;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation BarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.minValues = @[@0, @30,  @0];
    self.maxValues = @[@80, @80, @140];
    self.values = @[@[@10, @20, @30, @40, @50, @60, @70],
                    @[@70, @60, @50, @40, @40, @50, @60],
                    @[@10, @20, @40, @50, @70, @80, @110]];
    self.gridlineValues = @[@40, @60, @80, @100, @120];
    self.xAxisLabels = @[@"M", @"T", @"W", @"Th", @"F", @"S", @"Su"];
    self.gridlineTopLabels = @[@"Critical", @"Run-down", @"Solid", @"Strong", @"Superhuman"];
    self.gridlineBottomLabels = @[@"0-39", @"40-59", @"60-79", @"80-100", @"100+"];
    self.currentIndex = 0;
    self.chartView.delegate = self;
    self.chartView.dataSource = self;
    self.chartColor = [UIColor colorWithRed:0.14 green:0.19 blue:0.27 alpha:1];
    self.chartView.backgroundColor = self.chartColor;
    [self.chartView reloadData];
}

#pragma mark CHChartViewDataSource

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
    return [self.values[page] count];
}

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return [self.values[page][index] floatValue];
}

- (UILabel *)chartView:(CHChartView *)chartView labelForPointWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%d", (int)roundf(value)];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
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
    return self.gridlineValues.count;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index
{
    return [self.gridlineValues[index] floatValue];
}

- (UIView *)chartView:(CHChartView *)chartView labelViewForHorizontalGridlineWithValue:(CGFloat)value atIndex:(NSInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = self.gridlineTopLabels[index];
    topLabel.font = [UIFont boldSystemFontOfSize:14];
    topLabel.textColor = [UIColor whiteColor];
    topLabel.shadowColor = self.chartColor;
    topLabel.shadowOffset = CGSizeMake(1, 1);
    [topLabel sizeToFit];
    [view addSubview:topLabel];
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = self.gridlineBottomLabels[index];
    bottomLabel.font = [UIFont boldSystemFontOfSize:14];
    bottomLabel.textColor = [UIColor grayColor];
    bottomLabel.shadowColor = self.chartColor;
    bottomLabel.shadowOffset = CGSizeMake(1, 1);
    [bottomLabel sizeToFit];
    bottomLabel.frame = CGRectMake(0, CGRectGetMaxY(topLabel.frame) + 2,
                                   bottomLabel.frame.size.width, bottomLabel.frame.size.height);
    [view addSubview:bottomLabel];
    view.frame = CGRectMake(0, 0,
                            MAX(CGRectGetWidth(topLabel.frame), CGRectGetWidth(bottomLabel.frame)),
                            CGRectGetMaxY(bottomLabel.frame));
    return view;
}

#pragma mark CHChartViewDelegate

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page
{
    self.currentIndex = page;
}

@end
