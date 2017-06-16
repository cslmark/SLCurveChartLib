//
//  YAxisFormtter.m
//  SLChartDemo
//
//  Created by smart on 2017/5/20.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "YAxisFormtter.h"

@implementation YAxisFormtter
-(NSString *) stringForValue:(double) value axis:(ChartAxisBase *) axis{
    //看起来直接采用方法会出现四舍五入 %0.0lf
    NSString* axisLabel = [NSString stringWithFormat:@"%0.1lf", value];
    return axisLabel;
}

//这部分只有对于Y轴有用 用于确定网格的密度  X轴不需要实现以下协议
-(CGFloat) yStepWithaxis:(ChartAxisBase *) axis max:(CGFloat) max  Min:(CGFloat) min{
    CGFloat ystep = (max - min)/6;
    return ystep;
}

@end
