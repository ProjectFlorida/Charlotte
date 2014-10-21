//
//  CHPagingLineChartFlowLayout.h
//  Charlotte
//
//  Created by Ben Guo on 10/16/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHPagingChartFlowLayout.h"

@interface CHPagingLineChartFlowLayout : CHPagingChartFlowLayout

/**
 *  Returns the index of the point nearest to the given location in the given page.
 *
 *  @param location The location in the page, as a CGPoint
 *  @param page     The index of the page
 *
 *  @return The index of the point nearest to the given location in the given page.
 */
- (NSInteger)nearestIndexAtLocation:(CGPoint)location inPage:(NSInteger)page;

@end
