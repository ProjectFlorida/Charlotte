//
//  HorizontalBarChartViewController.m
//  Examples
//
//  Created by Ben Guo on 2/2/15.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "HorizontalBarChartViewController.h"
#import <Charlotte/Charlotte.h>

@interface HorizontalBarChartViewController () <CHHorizontalBarChartViewDataSource>

@property (nonatomic, strong) CHHorizontalBarChartView *chartView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL loaded;

@end

@implementation HorizontalBarChartViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _chartView = [[CHHorizontalBarChartView alloc] initWithFrame:CGRectZero];
        _chartView.dataSource = self;
        _loaded = NO;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.view addSubview:self.chartView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.chartView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.loaded = YES;
    [self.chartView reloadValues];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect bounds = self.view.bounds;
    self.chartView.frame = CGRectMake(10, 100, CGRectGetWidth(bounds) - 20, 400);
}

#pragma mark - CHHorizontalBarChartViewDataSource

- (NSUInteger)numberOfBarsInHorizontalBarChartView:(CHHorizontalBarChartView *)chartView
{
    return 4;
}

- (CGFloat)maxValueInHorizontalBarChartView:(CHHorizontalBarChartView *)chartView
{
    return 100;
}

- (CGFloat)averageValueInHorizontalBarChartView:(CHHorizontalBarChartView *)chartView
{
    if (!self.loaded) {
        return 0;
    }
    else {
        return 50;
    }
}

- (CGFloat)horizontalBarChartView:(CHHorizontalBarChartView *)chartView valueOfBarAtIndex:(NSUInteger)index
{
    NSArray *values = @[@120, @0, @70, @0];
    if (!self.loaded) {
        values = @[@0, @0, @0, @0];
    }
    return [values[index] floatValue];
}

- (void)horizontalBarChartView:(CHHorizontalBarChartView *)chartView configureBar:(CHHorizontalBarCell *)barCell
                     withValue:(CGFloat)value atIndex:(NSUInteger)index
{
    NSArray *colors = @[
                        [UIColor purpleColor],
                        [UIColor grayColor],
                        [UIColor grayColor],
                        [UIColor grayColor]
                        ];
    NSArray *leftLabels = @[@"foo", @"bar", @"baz", @"qux"];
    barCell.barColor = colors[index];
    barCell.leftLabelText = leftLabels[index];
    barCell.rightLabelText = [NSString stringWithFormat:@"%.0f min", value];
    if (index == 3) {
        barCell.barLabelText = @"NO DATA";
    }
}

@end
