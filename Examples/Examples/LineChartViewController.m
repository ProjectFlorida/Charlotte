//
//  LineChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "LineChartViewController.h"
#import <Charlotte/Charlotte.h>

@interface LineChartViewController () <CHChartViewDataSource, CHChartViewDelegate, CHLineChartViewDelegate>

@property (nonatomic, strong) CHLineChartView *chartView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *xAxisLabels;
@property (nonatomic, strong) UILabel *tooltipLabel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger pointCount;

@end

@implementation LineChartViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"CHLineChartView";

        _chartView = [[CHLineChartView alloc] initWithFrame:CGRectZero];
        _chartView.dataSource = self;
        _chartView.delegate = self;
        _chartView.lineChartDelegate = self;
        _chartView.backgroundColor = [UIColor clearColor];
        _chartView.headerHeight = 30;
        _chartView.pageInset = UIEdgeInsetsMake(0, 30, 0, 30);
        _chartView.lineWidth = 3;
        _chartView.lineColor = [UIColor whiteColor];
        _chartView.cursorColor = [UIColor colorWithRed:0.56 green:0.8 blue:0.07 alpha:1];
        [_chartView setLineColors:@[
                                    [UIColor colorWithRed:0.56 green:0.8 blue:0.07 alpha:1],
                                    [UIColor colorWithRed:0.45 green:0.65 blue:0.04 alpha:1],
                                    [UIColor colorWithRed:0.31 green:0.46 blue:0 alpha:1]
                                    ]
                        locations:@[@(1.5), @(2.5), @(3.5)]];


        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"❤️";
        [label sizeToFit];
        _chartView.yAxisLabelView = label;

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:_chartView];

        _tooltipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 80, 50)];
        _tooltipLabel.textAlignment = NSTextAlignmentCenter;
        _tooltipLabel.backgroundColor = [UIColor whiteColor];

        _pointCount = 20;
        _currentIndex = 0;
        _xAxisLabels = @[@"M", @"T", @"W", @"Th", @"F", @"S", @"Su"];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.view addSubview:_scrollView];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self action:@selector(refreshAction)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.chartView reloadData];
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
    self.chartView.frame = CGRectMake(0, 100, CGRectGetWidth(bounds), 300);
}

#pragma mark CHChartViewDataSource

- (void)chartView:(CHChartView *)chartView configureXAxisLabelView:(UIView *)view
   forPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    CHXAxisLabelView *labelView = (CHXAxisLabelView *)view;
    NSString *labelText;
    if (index == 2) {
        labelText = @"11:24pm";
    }
    else if (index == 10) {
        labelText = @"2:58am";
    }
    else if (index == 17) {
        labelText = @"7:04am";
    }
    if (labelText) {
        labelView.font = [UIFont systemFontOfSize:13];
        labelView.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        labelView.text = labelText;
        labelView.hidden = NO;
    }
    else {
        labelView.hidden = YES;
    }
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return self.pointCount;
}

- (NSNumber *)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 5 || index == 10) {
        return nil;
    }
    else {
        return @(sin(index*3)*sin(index*2)*2 + 2);
    }
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
    return 5.7;
}

- (NSInteger)numberOfGridlinesInChartView:(CHChartView *)chartView
{
    return 6;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForGridlineAtIndex:(NSInteger)index
{
    return index;
}

- (void)chartView:(CHChartView *)chartView configureGridlineView:(CHGridlineView *)gridlineView withValue:(CGFloat)value atIndex:(NSInteger)index
{
    gridlineView.lineInset = UIEdgeInsetsMake(0, 30, 0, 0);
    gridlineView.leftLabel.text = [NSString stringWithFormat:@"%.0f", value];
    gridlineView.leftLabel.textColor = [UIColor darkGrayColor];
    [gridlineView.leftLabel sizeToFit];
    gridlineView.lineColor = [UIColor lightGrayColor];
    gridlineView.lineWidth = 1;
    [gridlineView setNeedsLayout];
}

#pragma mark CHChartViewDelegate

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page
{
    self.currentIndex = page;
}

#pragma mark CHLineChartViewDelegate

- (void)chartView:(CHLineChartView *)chartView cursorAppearedInPage:(NSInteger)page
          atIndex:(NSInteger)index value:(CGFloat)value position:(CGPoint)position
{
    [[CHTooltipView sharedView] setDefaults];
    [[CHTooltipView sharedView] setContentInset:UIEdgeInsetsZero];
    [[CHTooltipView sharedView] setContentView:self.tooltipLabel];
    [[CHTooltipView sharedView] showWithTargetRect:CGRectMake(position.x, 0, 0, 0) inView:self.chartView];
    self.tooltipLabel.text = [NSString stringWithFormat:@"%.2f", value];
}

- (void)chartView:(CHLineChartView *)chartView cursorMovedInPage:(NSInteger)page
          toIndex:(NSInteger)index value:(CGFloat)value position:(CGPoint)position
{
    [[CHTooltipView sharedView] showWithTargetRect:CGRectMake(position.x, 0, 0, 0) inView:self.chartView];
    self.tooltipLabel.text = [NSString stringWithFormat:@"%.2f", value];
}

- (void)chartView:(CHLineChartView *)chartView cursorDisappearedInPage:(NSInteger)page
          atIndex:(NSInteger)index value:(CGFloat)value position:(CGPoint)position
{
    [[CHTooltipView sharedView] dismiss];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
