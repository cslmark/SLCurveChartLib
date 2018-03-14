//
//  ChartDataEntry.m
//  SLChartDemo
//
//  Created by smart on 2017/5/17.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "ChartDataEntry.h"

@implementation ChartDataEntry
-(instancetype) initWithX:(double) x y:(double) y{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
    }
    return self;
}

-(BOOL) isEqualWithEntry:(ChartDataEntry *) e{
    if ((self.x == e.x) && (self.y == e.y)) {
        return YES;
    }else{
        return NO;
    }
}
@end
