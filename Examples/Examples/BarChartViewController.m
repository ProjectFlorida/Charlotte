//
//  BarChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "BarChartViewController.h"
#import <Charlotte/Charlotte.h>

@interface BarChartViewController () <CHChartViewDataSource, CHChartViewDelegate, CHBarChartViewDataSource>

@property (nonatomic, strong) CHBarChartView *chartView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *minValues;
@property (nonatomic, strong) NSArray *maxValues;
@property (nonatomic, strong) NSArray *averages;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *xAxisLabels;
@property (nonatomic, strong) NSArray *gridlineValues;
@property (nonatomic, strong) NSArray *gridlineTopLabels;
@property (nonatomic, strong) NSArray *gridlineBottomLabels;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) UIColor *incompleteColor;

@end

@implementation BarChartViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"CHBarChartView";

        _chartView = [[CHBarChartView alloc] initWithFrame:CGRectZero];
        _chartView.delegate = self;
        _chartView.dataSource = self;
        _chartView.barChartDataSource = self;
        _chartView.xAxisLineHidden = YES;
        _chartView.headerHeight = 0;
        _chartView.backgroundColor = [UIColor clearColor];

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:_chartView];

        _minValues = @[@0, @35,  @0];
        _maxValues = @[@75, @90, @80];
        _averages = @[@50, @45, @55];
        _values = @[@[@0, @20, @30, @40, @50, @60, @30],
                    @[@70, @0, @50, @40, @70, @60, @45],
                    @[@10, @20, @0, @50, @70, @80, @40]];
        _gridlineValues = @[@40, @60, @52, @80, @100, @120];
        _xAxisLabels = @[@"M", @"T", @"W", @"Th", @"F", @"S", @"Su"];
        _gridlineTopLabels = @[@"Critical", @"Run-down", @"avg", @"Solid", @"Strong", @"Superhuman"];
        _gridlineBottomLabels = @[@"0-39", @"40-59", @"-", @"60-79", @"80-100", @"100+"];
        _currentIndex = 0;

        _barColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        _barTintColor = [UIColor colorWithRed:0.52 green:0.62 blue:0.77 alpha:1];
        _incompleteColor = [UIColor colorWithRed:0.35 green:0.41 blue:0.5 alpha:1];

        [self.view addSubview:_scrollView];
        self.view.backgroundColor = [UIColor colorWithRed:0.14 green:0.19 blue:0.27 alpha:1];
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
    self.chartView.frame = CGRectMake(0, 50, CGRectGetWidth(bounds), 350);
    CGFloat pageMargin = CGRectGetWidth(bounds)*0.1;
    self.chartView.sectionInset = UIEdgeInsetsMake(0, pageMargin*0.5, 0, pageMargin*0.5);
    self.chartView.pageInset = UIEdgeInsetsMake(0, pageMargin, 0, pageMargin);
}

#pragma mark - CHChartViewDataSource

- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView
{
    return self.minValues.count;
}

- (void)configureXAxisLabel:(UILabel *)label forPointInPage:(NSInteger)page atIndex:(NSInteger)index
                inChartView:(CHChartView *)chartView
{
    label.text = self.xAxisLabels[index];
    label.font = [UIFont systemFontOfSize:13];
    if (index == 3) {
        label.textColor = [UIColor whiteColor];
    }
    else {
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    [label sizeToFit];
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return [self.values[page] count];
}

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return [self.values[page][index] floatValue];
}

- (void)configureLabel:(UILabel *)label forPointWithValue:(CGFloat)value inPage:(NSInteger)page
               atIndex:(NSInteger)index inChartView:(CHChartView *)chartView;
{
    label.text = [NSString stringWithFormat:@"%d", (int)roundf(value)];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.alpha = (value == 0) ? 0 : 1;
    label.textColor = (index == 5) ? self.incompleteColor : [UIColor whiteColor];
    [label sizeToFit];
}

- (CGFloat)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page
{
    return [self.minValues[page] floatValue];
}

- (CGFloat)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page
{
    return [self.maxValues[page] floatValue];
}

- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView
{
    return self.gridlineValues.count;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index
{
    if (index == 2) {
        return [self.averages[self.currentIndex] floatValue];
    }
    else {
        return [self.gridlineValues[index] floatValue];
    }
}

- (UIView *)chartView:(CHChartView *)chartView labelViewForHorizontalGridlineWithValue:(CGFloat)value atIndex:(NSInteger)index
{
    if (index == 2) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont boldSystemFontOfSize:12];
        label.numberOfLines = 0;
        label.shadowColor = [UIColor colorWithRed:0.14 green:0.19 blue:0.27 alpha:1];
        label.shadowOffset = CGSizeMake(1, 1);
        label.text = self.gridlineTopLabels[index];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = label.lineBreakMode;
        paragraphStyle.alignment = label.textAlignment;
        CGRect boundingRect = [label.text boundingRectWithSize:CGSizeMake(40, 0)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName: label.font,
                                                                 NSParagraphStyleAttributeName: paragraphStyle}
                                                       context:nil];
        label.frame = CGRectMake(0, 0, boundingRect.size.width, boundingRect.size.height);
        label.textColor = [UIColor colorWithRed:0.82 green:0.89 blue:1 alpha:1];
        return label;
    }
    else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        UILabel *topLabel = [[UILabel alloc] init];
        topLabel.text = self.gridlineTopLabels[index];
        topLabel.font = [UIFont boldSystemFontOfSize:12];
        topLabel.textColor = [UIColor whiteColor];
        topLabel.shadowColor = [UIColor colorWithRed:0.14 green:0.19 blue:0.27 alpha:1];
        topLabel.shadowOffset = CGSizeMake(1, 1);
        [topLabel sizeToFit];
        [view addSubview:topLabel];
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.text = self.gridlineBottomLabels[index];
        bottomLabel.font = [UIFont boldSystemFontOfSize:14];
        bottomLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        bottomLabel.shadowColor = [UIColor colorWithRed:0.14 green:0.19 blue:0.27 alpha:1];
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
}

- (NSArray *)chartView:(CHChartView *)chartView lineDashPatternForHorizontalGridlineAtIndex:(NSInteger)index
{
    if (index == 2) {
        return @[@1, @3];
    }
    else {
        return nil;
    }
}

- (UIColor *)chartView:(CHChartView *)chartView lineColorForHorizontalGridlineAtIndex:(NSInteger)index
{
    if (index == 2) {
        return [UIColor colorWithRed:0.82 green:0.89 blue:1 alpha:1];
    }
    else {
        return [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
}

- (CHViewPosition)chartView:(CHChartView *)chartView labelPositionForHorizontalGridlineAtIndex:(NSInteger)index
{
    if (index == 2) {
        return CHViewPositionCenterRight;
    }
    else {
        return CHViewPositionBottomLeft;
    }
}

- (CGFloat)chartView:(CHChartView *)chartView leftFadeWidthForHorizontalGridlineAtIndex:(NSInteger)index
{
    if (index == 2) {
        return 0.3;
    }
    else {
        return 0;
    }
}

#pragma mark - CHBarChartDataSource

- (UIColor *)chartView:(CHBarChartView *)chartView colorForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (value == 0) {
        return [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    else if (index == 5) {
        return [UIColor clearColor];
    }
    else {
        return [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
}

- (UIColor *)chartView:(CHBarChartView *)chartView tintColorForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (value == 0 || index == 5) {
        return nil;
    }
    else {
        return self.barTintColor;
    }
}

- (NSArray *)chartView:(CHBarChartView *)chartView borderDashPatternForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 5) {
        return @[@2, @2];
    }
    else {
        return nil;
    }
}

- (UIColor *)chartView:(CHBarChartView *)chartView borderColorForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 5) {
        return self.incompleteColor;
    }
    else {
        return nil;
    }
}

- (CGFloat)chartView:(CHChartView *)chartView borderWidthForBarWithValue:(CGFloat)value
              inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 5) {
        return 2;
    }
    else {
        return 0;
    }
}

#pragma mark - CHChartViewDelegate

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page
{
    self.currentIndex = page;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
