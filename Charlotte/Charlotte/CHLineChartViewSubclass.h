//
//  CHLineChartViewSubclass.h
//  Charlotte
//
//  Created by Ben Guo on 10/29/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "CHLineChartView.h"

@class CHTouchGestureRecognizer;
@interface CHLineChartView (CHLineChartViewProtected)

@property (nonatomic, strong) CHTouchGestureRecognizer *touchGR;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGR;
@property (nonatomic, strong) CHLineView *lineView;

- (void)handleTouchGesture:(CHTouchGestureRecognizer *)gestureRecognizer;
- (void)initialize;

@end

