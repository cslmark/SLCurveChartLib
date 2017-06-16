//
//  ChartDataEntry.h
//  SLChartDemo
//
//  Created by smart on 2017/5/17.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "ChartDataEntryBase.h"

@interface ChartDataEntry : ChartDataEntryBase
@property (nonatomic, assign) double x;

-(instancetype) initWithX:(double) x y:(double) y;
-(BOOL) isEqualWithEntry:(ChartDataEntry *) e;
@end
