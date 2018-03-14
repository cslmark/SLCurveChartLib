//
//  ChartBaseLine.h
//  SLChartLibDemo
//
//  Created by smart on 2017/7/10.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "ChartComponentBase.h"


typedef NS_ENUM(NSUInteger, ChartBaseLineMode){
    ChartBaseLineDashMode = 0,
    ChartBaseLineStraightMode = 1
};

@interface ChartBaseLine : ChartComponentBase
@property (nonatomic, assign) CGFloat   lineWidth;
@property (nonatomic, strong) UIColor*  lineColor;
@property (nonatomic, assign) ChartBaseLineMode lineMode;
@property (nonatomic, assign) double    yValue;
@end
