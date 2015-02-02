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
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidLoad
{
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
    self.chartView.frame = CGRectMake(0, 100, CGRectGetWidth(bounds), 300);
}

#pragma mark CHChartViewDataSource

- (void)configureXAxisLabel:(UILabel *)label forPointInPage:(NSInteger)page atIndex:(NSInteger)index
                inChartView:(CHChartView *)chartView
{
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
        label.font = [UIFont systemFontOfSize:13];
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
    return self.pointCount;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return sin(index*3)*sin(index*2) + page + 3;
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
    return 5.7;
}

- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView
{
    return 3 + arc4random_uniform(3);
}

- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index
{
    return index + 1;
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
