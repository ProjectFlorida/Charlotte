//
//  CHLineChartViewSubclass.h
//  Charlotte
//
//  Created by Ben Guo on 10/29/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHLineChartView.h"

@interface CHLineChartView (CHLineChartViewProtected)

- (void)handleTouchGesture:(CHTouchGestureRecognizer *)gestureRecognizer;

@property (nonatomic, strong) NSMapTable *visibleLineViews;

@end

