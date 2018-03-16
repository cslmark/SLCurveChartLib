//
//  IValueFormatter.h
//  SLChartDemo
//
//  Created by smart on 2017/5/17.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartDataEntry.h"

@protocol SLChartFormatterProtocol <NSObject>
-(NSString *) stringForValue:(ChartDataEntry *) entry
                dataSetIndex:(int) index;
@end
