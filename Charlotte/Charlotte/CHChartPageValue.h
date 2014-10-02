//
//  CHChartPageValue.h
//  Pods
//
//  Created by Ben Guo on 10/2/14.
//
//

@import UIKit;

typedef NS_ENUM(NSInteger, CHChartPageValueType) {
    CHChartPageValueTypeMissing,
    CHChartPageValueTypeIncomplete,
    CHChartPageValueTypeComplete
};

@interface CHChartPageValue : NSObject

/// The value's type.
@property (nonatomic, assign) CHChartPageValueType type;

@property (nonatomic, assign) CGFloat value;

@end
