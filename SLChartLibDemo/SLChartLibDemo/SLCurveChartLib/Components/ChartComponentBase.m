//
//  ChartComponentBase.m
//  SLChartDemo
//
//  Created by smart on 2017/5/19.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "ChartComponentBase.h"

@implementation ChartComponentBase
-(instancetype) init{
    self = [super init];
    if (self) {
        _xOffset = 5.0;
        _yOffset = 5.0;
        _enabled = YES;
    }
    return self;
}
@end
