//
//  LineChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "LineChartViewController.h"
#import <Charlotte/Charlotte.h>

@interface LineChartViewController () <CHChartViewDataSource, CHChartViewDelegate, CHLineChartViewDelegate, CHLineChartViewDataSource>

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
        _chartView.lineChartDataSource = self;
        _chartView.backgroundColor = [UIColor clearColor];
        _chartView.backgroundColor = [UIColor colorWithRed:0.12 green:0.26 blue:0.49 alpha:1];
        _chartView.headerHeight = 30;

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:_chartView];

        _tooltipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 80, 50)];
        _tooltipLabel.textAlignment = NSTextAlignmentCenter;
        _tooltipLabel.backgroundColor = [UIColor magentaColor];

        _pointCount = 100;
        _currentIndex = 0;
        _xAxisLabels = @[@"M", @"T", @"W", @"Th", @"F", @"S", @"Su"];

        [self.view addSubview:_scrollView];
        self.view.backgroundColor = [UIColor colorWithRed:0.12 green:0.26 blue:0.49 alpha:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
             [CHChartRegion regionWithRange:NSMakeRange(70, 20) color:blue tintColor:self.view.backgroundColor]
             ];
}

- (UIColor *)chartView:(CHLineChartView *)chartView lineColorInPage:(NSInteger)page
{
    return [UIColor whiteColor];
}

- (NSInteger)chartView:(CHLineChartView *)chartView leftLineInsetInPage:(NSInteger)page
{
    return 10;
}

- (NSInteger)chartView:(CHLineChartView *)chartView rightLineInsetInPage:(NSInteger)page
{
    return 5;
}

- (CGFloat)chartView:(CHLineChartView *)chartView lineWidthInPage:(NSInteger)page
{
    return 3;
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
