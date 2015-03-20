//
//  IntervalChartViewController.m
//  Examples
//
//  Created by Ben Guo on 1/30/15.
//  Copyright (c) 2015 Project Florida. All rights reserved.
//

#import "IntervalChartViewController.h"
#import <Charlotte/Charlotte.h>

@interface IntervalChartViewController ()

@property (nonatomic, strong) CHIntervalChartView *chartView;
@property (nonatomic, strong) UIColor *lightColor;
@property (nonatomic, strong) UIColor *darkColor;
@property (nonatomic, strong) UIColor *redColor;

@end

@implementation IntervalChartViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"CHIntervalChartView";
        _chartView = [[CHIntervalChartView alloc] initWithFrame:CGRectZero];
        _lightColor = [UIColor colorWithRed:0.2 green:0.38 blue:0.68 alpha:1];
        _darkColor = [UIColor colorWithRed:0.11 green:0.23 blue:0.44 alpha:1];
        _redColor = [UIColor colorWithRed:0.67 green:0.07 blue:0.09 alpha:1];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.view addSubview:_chartView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.chartView setIntervals:@[
                                   [CHInterval intervalWithRange:NSMakeRange(0, 40) color:self.lightColor],
                                   [CHInterval intervalWithRange:NSMakeRange(40, 5) color:self.darkColor],
                                   [CHInterval intervalWithRange:NSMakeRange(45, 5) color:self.redColor],
                                   [CHInterval intervalWithRange:NSMakeRange(60, 30) color:self.lightColor],
                                   [CHInterval intervalWithRange:NSMakeRange(90, 10) color:self.darkColor],
                                   ]
                             max:100
                        animated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect bounds = self.view.bounds;
    self.chartView.frame = CGRectMake(10, 100, CGRectGetWidth(bounds) - 20, 100);
}

@end
