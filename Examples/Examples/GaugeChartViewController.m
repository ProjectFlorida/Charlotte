//
//  GaugeChartViewController.m
//  Examples
//
//  Created by Ben Guo on 3/31/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import "GaugeChartViewController.h"
#import <Charlotte/Charlotte.h>

@interface GaugeChartViewController () <CHGaugeChartViewDataSource>

@property (nonatomic, strong) CHGaugeChartView *chartView;
@property (nonatomic, strong) UIButton *zoomInButton1;
@property (nonatomic, strong) UIButton *zoomInButton2;
@property (nonatomic, strong) UIButton *zoomOutButton;
@property (nonatomic, strong) UIButton *movePointerButton;
@property (nonatomic, assign) CGFloat pointerValue;
@property (nonatomic, strong) NSArray *rangeColors;
@property (nonatomic, strong) NSArray *rangeUpperBounds;

@end

@implementation GaugeChartViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pointerValue = 5;
        _zoomInButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
        [_zoomInButton1 setTitle:@"zoom in" forState:UIControlStateNormal];
        [_zoomInButton1 addTarget:self action:@selector(zoomInUncentered) forControlEvents:UIControlEventTouchUpInside];
        [_zoomInButton1 sizeToFit];
        _zoomInButton2 = [UIButton buttonWithType:UIButtonTypeSystem];
        [_zoomInButton2 setTitle:@"zoom in centered at pointer" forState:UIControlStateNormal];
        [_zoomInButton2 addTarget:self action:@selector(zoomInCentered) forControlEvents:UIControlEventTouchUpInside];
        [_zoomInButton2 sizeToFit];
        _zoomOutButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_zoomOutButton setTitle:@"zoom out" forState:UIControlStateNormal];
        [_zoomOutButton addTarget:self action:@selector(zoomOut) forControlEvents:UIControlEventTouchUpInside];
        [_zoomOutButton sizeToFit];
        _movePointerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_movePointerButton setTitle:@"move pointer" forState:UIControlStateNormal];
        [_movePointerButton addTarget:self action:@selector(movePointer) forControlEvents:UIControlEventTouchUpInside];
        [_movePointerButton sizeToFit];

        UIColor *g = [UIColor colorWithRed:0.03 green:0.66 blue:0.42 alpha:1];
        UIColor *y = [UIColor colorWithRed:0.82 green:0.7 blue:0.17 alpha:1];
        UIColor *o = [UIColor colorWithRed:0.8 green:0.51 blue:0.12 alpha:1];
        _rangeColors = @[g, g, g, y, y, y, o, o, o];
        _rangeUpperBounds = @[@1, @2, @3, @4, @5, @6, @7, @8, @9];

        _chartView = [[CHGaugeChartView alloc] initWithFrame:CGRectZero];
        _chartView.dataSource = self;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.view addSubview:self.chartView];
    [self.view addSubview:self.zoomInButton1];
    [self.view addSubview:self.zoomInButton2];
    [self.view addSubview:self.zoomOutButton];
    [self.view addSubview:self.movePointerButton];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.chartView reload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)zoomInUncentered
{
    [self.chartView animateToVisibleRangeWithMin:2 length:5];
}

- (void)zoomInCentered
{
    [self.chartView animateToVisibleRangeWithCenter:self.pointerValue width:3];
}

- (void)zoomOut
{
    [self.chartView animateToVisibleRangeWithMin:0 length:10];
}

- (void)movePointer
{
    NSUInteger newPointerValue = self.pointerValue;
    do {
        newPointerValue = arc4random_uniform(10);
    }
    while (newPointerValue == self.pointerValue);
    self.pointerValue = newPointerValue;
    [self.chartView reloadPointerValue];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect bounds = self.view.bounds;
    self.chartView.frame = CGRectMake(10, 100, CGRectGetWidth(bounds) - 20, 150);

    self.zoomInButton1.center = CGPointMake(CGRectGetMidX(bounds),
                                            CGRectGetMaxY(self.chartView.frame) + 40);
    self.zoomInButton2.center = CGPointMake(CGRectGetMidX(bounds),
                                            CGRectGetMaxY(self.zoomInButton1.frame) + 20);
    self.zoomOutButton.center = CGPointMake(CGRectGetMidX(bounds),
                                            CGRectGetMaxY(self.zoomInButton2.frame) + 20);
    self.movePointerButton.center = CGPointMake(CGRectGetMidX(bounds),
                                                CGRectGetMaxY(self.zoomOutButton.frame) + 20);
}

#pragma mark - CHRangeChartViewDataSource

- (CGFloat)minValueInChartView:(CHGaugeChartView *)chartView
{
    return 0;
}

- (CGFloat)maxValueInChartView:(CHGaugeChartView *)chartView
{
    return 10;
}

- (NSUInteger)numberOfXAxisLabelsInChartView:(CHGaugeChartView *)chartView
{
    return 9;
}

- (CGFloat)chartView:(CHGaugeChartView *)chartView valueOfXAxisLabelAtIndex:(NSUInteger)index
{
    return index+1;
}

- (void)chartView:(CHGaugeChartView *)chartView configureXAxisLabelView:(CHXAxisLabelView *)labelView
          atIndex:(NSUInteger)index withValue:(CGFloat)value
{
    labelView.text = [NSString stringWithFormat:@"%d", (int)roundf(value)];
    labelView.labelEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    labelView.textColor = [UIColor grayColor];
    labelView.tickColor = [UIColor grayColor];
    [labelView sizeToFit];
}

- (NSUInteger)numberOfRangesInChartView:(CHGaugeChartView *)chartView
{
    return [self.rangeColors count];
}

- (UIColor *)chartView:(CHGaugeChartView *)chartView colorOfRangeAtIndex:(NSUInteger)index
{
    return self.rangeColors[index];
}

- (CGFloat)chartView:(CHGaugeChartView *)chartView upperBoundOfRangeAtIndex:(NSUInteger)index
{
    return [self.rangeUpperBounds[index] floatValue];
}

- (CGFloat)valueOfPointerInChartView:(CHGaugeChartView *)chartView
{
    return self.pointerValue;
}

- (void)chartView:(CHGaugeChartView *)chartView configurePointerView:(CHGaugePointerView *)pointerView
        withValue:(CGFloat)value colorUnderPointer:(UIColor *)color
{
    pointerView.needleColor = [UIColor grayColor];
    pointerView.text = @"Great";
    pointerView.font = [UIFont boldSystemFontOfSize:12];
    pointerView.labelBackgroundColor = color;
}

@end
