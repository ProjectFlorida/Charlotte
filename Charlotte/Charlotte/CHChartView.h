//
//  CHChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHChartView;
@protocol CHChartViewDataSource <NSObject>

// page indices increase from right to left. the rightmost page has index 0.
- (NSInteger)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page;
- (NSInteger)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page;

- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView;
- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page;
// point indices increase from left to right.
- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index;

// the total number of distinct horizontal gridlines that may be displayed, across all possible pages
- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView;
- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index;

@optional
- (NSInteger)chartView:(CHChartView *)chartView textForHorizontalGridlineAtIndex:(NSInteger)index;

@end

@protocol CHChartViewDelegate <NSObject>

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page;

@end

@interface CHChartView : UIView

@property (nonatomic, weak) id<CHChartViewDataSource> dataSource;
@property (nonatomic, weak) id<CHChartViewDelegate> delegate;

- (void)reloadData;

@end
