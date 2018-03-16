//
//  ChartBaseLine.m
//  SLChartLibDemo
//
//  Created by smart on 2017/7/10.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "ChartBaseLine.h"

@implementation ChartBaseLine
-(void) setup{
    self.lineWidth = 1.0;
    if (self.lineColor == nil) {
        self.lineColor = [UIColor whiteColor];
    }
    self.lineMode = ChartBaseLineDashMode;
    self.yValue = 0.0;
}

-(instancetype) init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

@end
