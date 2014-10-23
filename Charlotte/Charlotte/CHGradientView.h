//
//  CHGradientView.h
//  Charlotte
//
//  Created by Ben Guo on 10/21/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHGradientView : UIView

/**
 *  An array of UIColor objects defining the color of each gradient stop. Defaults to nil.
 */
@property (strong, nonatomic) NSArray *colors;

/**
 *  An optional array of NSNumber objects defining the location of each gradient stop.
 *  The gradient stops are specified as values between 0 and 1. The values must be monotonically increasing. 
 *  If this property is nil, or if contains a different number of objects than the colors array,
 *  the stops are spread uniformly across the range. Defaults to nil.
 */
@property (strong, nonatomic) NSArray *locations;

/**
 *  The start point of the gradient when drawn in the layer’s coordinate space.
 *  The start point corresponds to the first stop of the gradient. The point is defined in the unit coordinate space 
 *  and is then mapped to the layer’s bounds rectangle when drawn. Default value is (0.5,0.0).
 */
@property (assign, nonatomic) CGPoint startPoint;

/**
 *  The end point of the gradient when drawn in the layer’s coordinate space.
 *  The end point corresponds to the last stop of the gradient. The point is defined in the unit coordinate space
 *  and is then mapped to the layer’s bounds rectangle when drawn. Default value is (0.5,1.0).
 */
@property (assign, nonatomic) CGPoint endPoint;

@end
