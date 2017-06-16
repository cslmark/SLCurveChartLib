//
//  SLChartAxisValueFormatterPotocol.h
//  SLChartDemo
//
//  Created by smart on 2017/5/19.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartAxisBase.h"

@class ChartAxisBase;
@protocol SLChartAxisValueFormatterPotocol <NSObject>
-(NSString *) stringForValue:(double) value axis:(ChartAxisBase *) axis;
//这部分只有对于Y轴有用 用于确定网格的密度  X轴不需要实现以下协议
-(CGFloat) yStepWithaxis:(ChartAxisBase *) axis max:(CGFloat) max  Min:(CGFloat) min;
@end
