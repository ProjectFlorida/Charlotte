//
//  LineChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "LineChartViewController.h"
#import <Charlotte/Charlotte.h>

@interface LineChartViewController () <CHBarChartViewDataSource, CHBarChartViewDelegate, CHLineChartViewDelegate>

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
        _chartView.pageInset = UIEdgeInsetsMake(0, 30, 0, 30);
        _chartView.lineWidth = 3;
        _chartView.lineColor = [UIColor whiteColor];
        _chartView.cursorColor = [UIColor colorWithRed:0.56 green:0.8 blue:0.07 alpha:1];
        _chartView.footerHeight = 50;
        [_chartView setLineColors:@[
                                    [UIColor colorWithRed:0.56 green:0.8 blue:0.07 alpha:1],
                                    [UIColor colorWithRed:0.56 green:0.8 blue:0.07 alpha:1],
                                    [UIColor colorWithRed:0.45 green:0.65 blue:0.04 alpha:1],
                                    [UIColor colorWithRed:0.45 green:0.65 blue:0.04 alpha:1],
                                    [UIColor colorWithRed:0.31 green:0.46 blue:0 alpha:1],
                                    [UIColor colorWithRed:0.31 green:0.46 blue:0 alpha:1]
                                    ]
                        locations:@[@(0), @(1), @(1.1), @(2), @(2.1), @(3)]];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"❤️";
        [label sizeToFit];
        _chartView.yAxisLabelView = label;

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:_chartView];

        _tooltipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 80, 50)];
        _tooltipLabel.textAlignment = NSTextAlignmentCenter;
        _tooltipLabel.backgroundColor = [UIColor whiteColor];

        _pointCount = 30;
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
    self.scrollView.contentSize = CGSizeMake(bounds.size.width, bounds.size.height*2);
    self.chartView.frame = CGRectMake(0, 100, CGRectGetWidth(bounds), 300);
}

#pragma mark CHChartViewDataSource

- (NSArray *)chartView:(CHBarChartView *)chartView indicesOfXAxisLabelsInPage:(NSInteger)page
{
    return @[@0, @10, @19];
}

- (void)chartView:(CHLineChartView *)chartView configureXAxisLabelView:(UIView *)view
   forPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    CHXAxisLabelView *labelView = (CHXAxisLabelView *)view;
    NSString *labelText;
    if (index == 0) {
        labelText = @"11:24pm";
    }
    else if (index == 10) {
        labelText = @"2:58am";
    }
    else if (index == 19) {
        labelText = @"7:04am";
    }
    if (labelText) {
        labelView.hidden = NO;
        labelView.titleLabel.font = [UIFont systemFontOfSize:13];
        labelView.subtitleLabel.font = [UIFont systemFontOfSize:13];
        labelView.titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        labelView.subtitleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        labelView.tickColor = labelView.titleLabel.textColor;
        labelView.titleLabel.text = labelText;
        labelView.subtitleLabel.text = labelText;
        [labelView.titleLabel sizeToFit];
        [labelView.subtitleLabel sizeToFit];
        [labelView setNeedsLayout];
        [labelView sizeToFit];
    }
    else {
        labelView.hidden = YES;
    }
}

- (NSInteger)chartView:(CHLineChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return self.pointCount;
}

- (NSNumber *)chartView:(CHLineChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 5 || index == 10) {
        return nil;
    }
    else {
        return @(sin(index*3)*sin(index*2)*2 + 1);
    }
}

- (CGFloat)chartView:(CHLineChartView *)chartView minValueForPage:(NSInteger)page
{
    return 0;
}

- (CGFloat)chartView:(CHLineChartView *)chartView maxValueForPage:(NSInteger)page
{
    return 5.7;
}

- (NSInteger)numberOfGridlinesInChartView:(CHLineChartView *)chartView
{
    return 6;
}

- (CGFloat)chartView:(CHLineChartView *)chartView valueForGridlineAtIndex:(NSInteger)index
{
    return index;
}

- (void)chartView:(CHLineChartView *)chartView configureGridlineView:(CHGridlineView *)gridlineView withValue:(CGFloat)value atIndex:(NSInteger)index
{
    gridlineView.lineInset = UIEdgeInsetsMake(0, 30, 0, 0);
    gridlineView.leftLabel.text = [NSString stringWithFormat:@"%.0f", value];
    gridlineView.leftLabel.textColor = [UIColor darkGrayColor];
    gridlineView.leftLabel.font = [UIFont boldSystemFontOfSize:12];
    [gridlineView.leftLabel sizeToFit];
    gridlineView.upperLeftLabel.text = @"foo";
    gridlineView.upperLeftLabel.font = [UIFont boldSystemFontOfSize:12];
    [gridlineView.upperLeftLabel sizeToFit];
    gridlineView.lineColor = [UIColor lightGrayColor];
    gridlineView.lineWidth = 1;
    [gridlineView setNeedsLayout];
}

#pragma mark CHChartViewDelegate

- (void)chartView:(CHLineChartView *)chartView didTransitionToPage:(NSInteger)page
{
    self.currentIndex = page;
}

#pragma mark CHLineChartViewDelegate

- (void)chartView:(CHLineChartView *)chartView cursorAppearedAtIndex:(NSInteger)index value:(CGFloat)value position:(CGPoint)position
{
    [[CHTooltipView sharedView] setDefaults];
    [[CHTooltipView sharedView] setContentInset:UIEdgeInsetsZero];
    [[CHTooltipView sharedView] setContentView:self.tooltipLabel];
    [[CHTooltipView sharedView] showWithTargetRect:CGRectMake(position.x, 0, 0, 0) relativeToView:self.chartView inView:self.view];
    self.tooltipLabel.text = [NSString stringWithFormat:@"%.2f", value];
}

- (void)chartView:(CHLineChartView *)chartView cursorMovedToIndex:(NSInteger)index value:(CGFloat)value position:(CGPoint)position
{
    [[CHTooltipView sharedView] showWithTargetRect:CGRectMake(position.x, 0, 0, 0) relativeToView:self.chartView inView:self.view];
    self.tooltipLabel.text = [NSString stringWithFormat:@"%.2f", value];
}

- (void)chartView:(CHLineChartView *)chartView cursorDisappearedAtIndex:(NSInteger)index value:(CGFloat)value position:(CGPoint)position
{
    [[CHTooltipView sharedView] dismiss];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
