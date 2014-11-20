//
//  ScatterChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/28/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "ScatterChartViewController.h"
#import <Charlotte/Charlotte.h>

@interface ScatterChartViewController () <CHChartViewDataSource, CHScatterChartViewDataSource, CHScatterChartViewDelegate, CHLineChartViewDataSource, CHTooltipViewDelegate>

@property (nonatomic, strong) CHScatterChartView *chartView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ScatterChartViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"CHScatterChartView";
        _chartView = [[CHScatterChartView alloc] initWithFrame:CGRectZero];
        _chartView.backgroundColor = [UIColor clearColor];
        _chartView.dataSource = self;
        _chartView.lineChartDataSource = self;
        _chartView.xAxisLineHidden = YES;
        _chartView.scatterChartDataSource = self;
        _chartView.scatterChartDelegate = self;
        _chartView.headerHeight = 0;

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:_chartView];

        [self.view addSubview:_scrollView];
        self.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.36 blue:0.17 alpha:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chartView reloadData];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self action:@selector(refreshAction)];
}

- (void)refreshAction
{
    [self.chartView reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect bounds = self.view.bounds;
    self.scrollView.frame = bounds;
    self.scrollView.contentSize = CGSizeMake(bounds.size.width, bounds.size.height*1.5);
    self.chartView.frame = CGRectMake(0, 50, CGRectGetWidth(bounds), 300);
}

#pragma mark - CHScatterChartViewDataSource

- (NSInteger)chartView:(CHScatterChartView *)chartView numberOfScatterPointsInPage:(NSInteger)page
{
    return 200;
}

- (CGFloat)chartView:(CHScatterChartView *)chartView valueOfScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return sin(index)*2 + 2.5;
}

- (UIColor *)chartView:(CHScatterChartView *)chartView colorOfScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (CGFloat)chartView:(CHScatterChartView *)chartView radiusOfScatterPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return 2;
}

- (UIView *)chartView:(CHScatterChartView *)chartView viewForInteractivePointInPage:(NSInteger)page
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = view.bounds.size.width/2.0;
    view.clipsToBounds = NO;

    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.fromValue = @(1.0);
    pulse.toValue = @(1.5);
    pulse.duration = 0.6;
    pulse.autoreverses = YES;
    pulse.repeatCount = HUGE_VALF;
    [view.layer addAnimation:pulse forKey:@"pulse"];

    return view;
}

- (CGFloat)chartView:(CHScatterChartView *)chartView valueOfInteractivePointInPage:(NSInteger)page
{
    return 3.5;
}

- (NSInteger)chartView:(CHScatterChartView *)chartView indexOfInteractivePointInPage:(NSInteger)page
{
    return 150;
}

#pragma mark - CHScatterChartViewDelegate

- (void)chartView:(CHScatterChartView *)chartView didSelectInteractivePointInPage:(NSInteger)page frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"wide tooltip, prefersCenterX = YES";
    [label sizeToFit];
    [[CHTooltipView sharedView] setDefaults];
    [[CHTooltipView sharedView] setPrefersCenterX:YES];
    [[CHTooltipView sharedView] setContentView:label];
    [[CHTooltipView sharedView] setHandlesDismissal:YES];
    [[CHTooltipView sharedView] showWithTargetRect:frame inView:chartView];
    [CHTooltipView sharedView].delegate = self;
}

#pragma mark - CHLineChartDataSource

- (UIColor *)chartView:(CHLineChartView *)chartView lineTintColorInPage:(NSInteger)page
{
    return [UIColor colorWithRed:1 green:0.74 blue:0.63 alpha:1];
}

#pragma mark - CHChartViewDataSource

- (void)configureXAxisLabel:(UILabel *)label forPointInPage:(NSInteger)page atIndex:(NSInteger)index
                inChartView:(CHChartView *)chartView
{
    NSString *labelText;
    if (index == 10) {
        labelText = @"March";
    }
    else if (index == 20) {
        labelText = @"April";
    }
    else if (index == 30) {
        labelText = @"May";
    }
    else if (index == 40) {
        labelText = @"June";
    }
    else if (index == 50) {
        labelText = @"July";
    }
    if (labelText) {
        label.font = [UIFont boldSystemFontOfSize:13];
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        label.text = labelText;
        label.hidden = NO;
    }
    else {
        label.hidden = YES;
    }
    [label sizeToFit];
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return 60;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return pow(1.3, (index/20.0));
}

- (void)configureLabel:(UILabel *)label forPointWithValue:(CGFloat)value inPage:(NSInteger)page
               atIndex:(NSInteger)index inChartView:(CHChartView *)chartView;
{
    label.hidden = YES;
}

- (CGFloat)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page
{
    return 0;
}

- (CGFloat)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page
{
    return 6;
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

#pragma mark - CHTooltipViewDelegate

- (void)tooltipDidAppear:(CHTooltipView *)tooltipView
{
    NSLog(@"A wild tooltip appears!");
}

- (void)tooltipDidDisappear:(CHTooltipView *)tooltipView
{
    NSLog(@"A wild tooltip disappears!");
}

@end