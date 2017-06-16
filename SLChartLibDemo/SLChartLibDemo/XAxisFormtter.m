//
//  XAxisFormtter.m
//  SLChartDemo
//
//  Created by smart on 2017/5/20.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "XAxisFormtter.h"

@implementation XAxisFormtter
-(NSString *) stringForValue:(double) value axis:(ChartAxisBase *) axis{
    NSString* axisLabel = [NSString stringWithFormat:@"%0.0lf", value];
    return axisLabel;
}

-(CGFloat) yStepWithaxis:(ChartAxisBase *) axis max:(CGFloat) max  Min:(CGFloat) min{
    return 0.0;
}
@end
