//
//  SLChartHighlight.m
//  SLChartDemo
//
//  Created by smart on 2017/5/21.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "ChartHighlight.h"

@implementation ChartHighlight
-(void) setup{
    _x = NAN;
    _y = NAN;
    _xPx = NAN;
    _yPx = NAN;
    _dataIndex = -1;
    _drawX = NAN;
    _drawY = NAN;
}

-(instancetype) init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

@end
