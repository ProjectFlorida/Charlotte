//
//  ScatterChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/28/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "ScatterChartViewController.h"
#import <Charlotte/Charlotte.h>

@interface ScatterChartViewController () <CHChartViewDataSource, CHScatterChartViewDataSource, CHScatterChartViewDelegate,
CHTooltipViewDelegate>

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
        _chartView.scatterChartDataSource = self;
        _chartView.scatterChartDelegate = self;
        _chartView.pageInset = UIEdgeInsetsMake(0, 30, 0, 30);

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:_chartView];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.view addSubview:_scrollView];
    self.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.36 blue:0.17 alpha:1];
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

- (NSInteger)numberOfScatterPointsInChartView:(CHScatterChartView *)chartView
{
    return 200;
}

- (CGFloat)chartView:(CHScatterChartView *)chartView valueOfScatterPointAtIndex:(NSInteger)index
{
    return sin(index)*2 + 2.5;
}

- (UIColor *)chartView:(CHScatterChartView *)chartView colorOfScatterPointInPageAtIndex:(NSInteger)index
{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (CGFloat)chartView:(CHScatterChartView *)chartView radiusOfScatterPointInPageAtIndex:(NSInteger)index
{
    return 2;
}

- (UIView *)viewForInteractivePointInChartView:(CHScatterChartView *)chartView
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

- (CGFloat)valueOfInteractivePointInChartView:(CHScatterChartView *)chartView
{
    return 3.5;
}

- (NSInteger)indexOfInteractivePointInChartView:(CHScatterChartView *)chartView
{
    return 150;
}

#pragma mark - CHScatterChartViewDelegate

- (void)chartView:(CHScatterChartView *)chartView didSelectInteractivePointWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"wide tooltip, prefersCenterX = YES";
    [label sizeToFit];
    [[CHTooltipView sharedView] setDefaults];
    [[CHTooltipView sharedView] setArrowSize:CGSizeMake(10, 10)];
    [[CHTooltipView sharedView] setPrefersCenterX:YES];
    [[CHTooltipView sharedView] setContentView:label];
    [[CHTooltipView sharedView] setHandlesDismissal:YES];
    [[CHTooltipView sharedView] showWithTargetRect:frame relativeToView:chartView inView:self.view];
    [CHTooltipView sharedView].delegate = self;
}

#pragma mark - CHChartViewDataSource

- (void)chartView:(CHChartView *)chartView configureXAxisLabelView:(UIView *)view
   forPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    CHXAxisLabelView *labelView = (CHXAxisLabelView *)view;
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
        labelView.font = [UIFont boldSystemFontOfSize:13];
        labelView.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        labelView.text = labelText;
        labelView.hidden = NO;
        labelView.tickColor = [UIColor clearColor];
    }
    else {
        labelView.hidden = YES;
    }
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return 60;
}

- (NSNumber *)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return @(pow(1.3, (index/20.0)));
}

- (void)chartView:(CHChartView *)chartView configureLabel:(UILabel *)label forPointInPage:(NSInteger)page
          atIndex:(NSInteger)index
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

- (NSInteger)numberOfGridlinesInChartView:(CHChartView *)chartView
{
    return 5;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForGridlineAtIndex:(NSInteger)index
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