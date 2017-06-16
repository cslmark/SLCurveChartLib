//
//  SLChartDataSet.h
//  SLChartDemo
//
//  Created by smart on 2017/5/17.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "SLChartBaseDataSet.h"

//根据给定的X查找对应X所处在的坐标模式
typedef enum : NSUInteger {
    up = 0,
    down = 1,
    closest = 2,
} ChartDataSetRounding;

//曲线的模式
typedef enum : NSUInteger {
    brokenLineMode = 0,
    curveLineMode = 1,
} LineMode;

@interface SLLineChartDataSet : SLChartBaseDataSet
{
    NSMutableArray<ChartDataEntry*>* _values;
}
@property (nonatomic, copy)   NSString* label;
@property (nonatomic, strong) NSMutableArray<ChartDataEntry*>* values;
@property (nonatomic, assign) LineMode  mode;
@property (nonatomic, assign) BOOL      drawCirclesEnabled;
@property (nonatomic, assign) BOOL      drawCircleHoleEnabled;
@property (nonatomic, assign) CGLineCap lineCapType;
@property (nonatomic, assign) CGFloat   lineWidth;
@property (nonatomic, assign) CGFloat   circleRadius;
@property (nonatomic, assign) CGFloat   circleHoleRadius;


//颜色部分<曲线的颜色，对应点的颜色，以及对应的圈内的颜色， 选中的点颜色>
@property (nonatomic, strong) UIColor*  color;
@property (nonatomic, strong) UIColor*  circleColor;
@property (nonatomic, strong) UIColor*  circleHoleColor;
@property (nonatomic, strong) UIColor*  highlightColor;
@property (nonatomic, strong) UIColor*  graphColor;

//初始化方法
-(instancetype) initWithValues:(NSMutableArray *) values label:(NSString *) label;
@end
