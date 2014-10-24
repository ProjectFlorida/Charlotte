//
//  BarChartViewController.m
//  Examples
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "BarChartViewController.h"

@interface BarChartViewController () <CHChartViewDataSource, CHChartViewDelegate, CHBarChartDataSource>

@property (nonatomic, strong) NSArray *minValues;
@property (nonatomic, strong) NSArray *maxValues;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *xAxisLabels;
@property (nonatomic, strong) NSArray *gridlineValues;
@property (nonatomic, strong) NSArray *gridlineTopLabels;
@property (nonatomic, strong) NSArray *gridlineBottomLabels;
@property (nonatomic, strong) UIColor *chartColor;
@property (nonatomic, strong) UIColor *avgLineColor;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) UIColor *incompleteColor;

@end

@implementation BarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.minValues = @[@0, @30,  @0];
    self.maxValues = @[@80, @80, @140];
    self.values = @[@[@10, @20, @30, @40, @50, @60, @70],
                    @[@70, @60, @50, @40, @40, @50, @60],
                    @[@10, @20, @40, @50, @70, @80, @110]];
    self.gridlineValues = @[@40, @60, @52, @80, @100, @120];
    self.xAxisLabels = @[@"M", @"T", @"W", @"Th", @"F", @"S", @"Su"];
    self.gridlineTopLabels = @[@"Critical", @"Run-down", @"Daily avg", @"Solid", @"Strong", @"Superhuman"];
    self.gridlineBottomLabels = @[@"0-39", @"40-59", @"-", @"60-79", @"80-100", @"100+"];
    self.currentIndex = 0;
    self.chartView.delegate = self;
    self.chartView.dataSource = self;
    self.chartView.barChartDataSource = self;
    self.barColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    self.barTintColor = [UIColor colorWithRed:0.52 green:0.62 blue:0.77 alpha:1];
    self.incompleteColor = [UIColor colorWithRed:0.35 green:0.41 blue:0.5 alpha:1];
    self.chartColor = [UIColor colorWithRed:0.14 green:0.19 blue:0.27 alpha:1];
    self.avgLineColor = [UIColor colorWithRed:0.82 green:0.89 blue:1 alpha:1] ;
    self.chartView.backgroundColor = self.chartColor;
    [self.chartView reloadData];
}

#pragma mark - CHChartViewDataSource

- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView
{
    return self.minValues.count;
}

- (UILabel *)chartView:(CHChartView *)chartView xAxisLabelForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.text = self.xAxisLabels[index];
    label.font = [UIFont systemFontOfSize:13];
    if (index == 3) {
        label.textColor = [UIColor whiteColor];
    }
    else {
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return label;
}

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page
{
    return [self.values[page] count];
}

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index
{
    return [self.values[page][index] floatValue];
}

- (UILabel *)chartView:(CHChartView *)chartView labelForPointWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%d", (int)roundf(value)];
    label.font = [UIFont boldSystemFontOfSize:18];
    if (index == 0) {
        label.alpha = 0;
    }
    else if (index == 6) {
        label.textColor = self.incompleteColor;
    }
    else {
        label.textColor = [UIColor whiteColor];
    }
    return label;
}

- (NSInteger)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page
{
    return [self.minValues[page] integerValue];
}

- (NSInteger)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page
{
    return [self.maxValues[page] integerValue];
}

- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView
{
    return self.gridlineValues.count;
}

- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index
{
    return [self.gridlineValues[index] floatValue];
}

- (UIView *)chartView:(CHChartView *)chartView labelViewForHorizontalGridlineWithValue:(CGFloat)value atIndex:(NSInteger)index
{
    if (index == 2) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont boldSystemFontOfSize:12];
        label.numberOfLines = 0;
        label.shadowColor = self.chartColor;
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
        label.textColor = self.avgLineColor;
        return label;
    }
    else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        UILabel *topLabel = [[UILabel alloc] init];
        topLabel.text = self.gridlineTopLabels[index];
        topLabel.font = [UIFont boldSystemFontOfSize:14];
        topLabel.textColor = [UIColor whiteColor];
        topLabel.shadowColor = self.chartColor;
        topLabel.shadowOffset = CGSizeMake(1, 1);
        [topLabel sizeToFit];
        [view addSubview:topLabel];
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.text = self.gridlineBottomLabels[index];
        bottomLabel.font = [UIFont boldSystemFontOfSize:14];
        bottomLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        bottomLabel.shadowColor = self.chartColor;
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
        return self.avgLineColor;
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

#pragma mark - CHBarChartDataSource

- (UIColor *)chartView:(CHChartView *)chartView colorForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (value == 0) {
        return [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    else if (value == 6) {
        return [UIColor clearColor];
    }
    else {
        return [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
}

- (UIColor *)chartView:(CHChartView *)chartView tintColorForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (value == 0 || value == 6) {
        return nil;
    }
    else {
        return self.barTintColor;
    }
}

- (NSArray *)chartView:(CHChartView *)chartView borderDashPatternForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 6) {
        return @[@2, @2];
    }
    else {
        return nil;
    }
}

- (UIColor *)chartView:(CHChartView *)chartView borderColorForBarWithValue:(CGFloat)value
                inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 6) {
        return self.incompleteColor;
    }
    else {
        return nil;
    }
}

- (CGFloat)chartView:(CHChartView *)chartView borderWidthForBarWithValue:(CGFloat)value
              inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (index == 6) {
        return 2;
    }
    else {
        return 0;
    }
}

- (CGFloat)chartView:(CHChartView *)chartView shadowOpacityForBarWithValue:(CGFloat)value
              inPage:(NSInteger)page atIndex:(NSInteger)index
{
    if (value == 0) {
        return 0;
    }
    else {
        return 0.5;
    }
}


#pragma mark - CHChartViewDelegate

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page
{
    self.currentIndex = page;
}

@end
