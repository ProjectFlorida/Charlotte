//
//  CHChartView.h
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kCHPageTransitionAnimationDuration;
extern CGFloat const kCHPageTransitionAnimationSpringDamping;

extern NSString *const CHChartViewElementKindHeader;

@class CHChartView;
@protocol CHChartViewDataSource <NSObject>

- (NSInteger)numberOfPagesInChartView:(CHChartView *)chartView;

- (NSInteger)chartView:(CHChartView *)chartView numberOfPointsInPage:(NSInteger)page;

- (CGFloat)chartView:(CHChartView *)chartView valueForPointInPage:(NSInteger)page atIndex:(NSInteger)index;

// Return nil for no label
- (NSString *)chartView:(CHChartView *)chartView xAxisLabelForPointInPage:(NSInteger)page atIndex:(NSInteger)index;

- (NSInteger)chartView:(CHChartView *)chartView minValueForPage:(NSInteger)page;

- (NSInteger)chartView:(CHChartView *)chartView maxValueForPage:(NSInteger)page;

/// The total number of distinct horizontal gridlines that may be displayed
- (NSInteger)numberOfHorizontalGridlinesInChartView:(CHChartView *)chartView;

- (CGFloat)chartView:(CHChartView *)chartView valueForHorizontalGridlineAtIndex:(NSInteger)index;

@optional
- (NSString *)chartView:(CHChartView *)chartView textForHorizontalGridlineAtIndex:(NSInteger)index;

@end

@protocol CHChartViewDelegate <NSObject>

- (void)chartView:(CHChartView *)chartView didTransitionToPage:(NSInteger)page;

@end

@interface CHChartView : UIView

@property (nonatomic, weak) id<CHChartViewDataSource> dataSource;
@property (nonatomic, weak) id<CHChartViewDelegate> delegate;

- (void)reloadData;
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

@end
