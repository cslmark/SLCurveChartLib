//
//  SLChartHighlight.h
//  SLChartDemo
//
//  Created by smart on 2017/5/21.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartComponentBase.h"
#import <UIKit/UIKit.h>

@class ChartHighlight;
@protocol ChartHighlightDelegate <NSObject>
@optional
/**
 该协议用于给外部指定对应高亮形式只是蒙版的方法
 <特别注意在iOS中坐标的方向问题，曲线图的坐标X轴与系统一致，Y轴相反>
 @param highlight 被选定的数据
 @param context   当前处在的画布的图形上下文
 @param rect      当前曲线画布的frame
 @param edageInsets 具体曲线部分画布和整体画图的padding关系
 */
-(void) chartHighlight:(ChartHighlight *) highlight context:(CGContextRef) context bounds:(CGRect) rect edageInsets:(UIEdgeInsets) edageInsets;
@end

@interface ChartHighlight : ChartComponentBase
@property (nonatomic, assign) double x;                  //选定点的X数值
@property (nonatomic, assign) double y;                  //选定点的Y数值
@property (nonatomic, assign) double touchYValue;        //手势所在点的Y坐标数值
@property (nonatomic, assign) CGFloat xPx;               //整体曲线图整图的X坐标
@property (nonatomic, assign) CGFloat yPx;               //整体曲线图整图的Y坐标
@property (nonatomic, assign) int     dataSetIndex;      //处于那条曲线上面的点击<用于区分多条曲线的情况>
@property (nonatomic, assign) int     dataIndex;         //距离点击点最近的当前数据源下标
@property (nonatomic, assign) CGFloat drawX;             //选定点处于当前屏幕X坐标
@property (nonatomic, assign) CGFloat drawY;             //选定点处于当前屏幕Y坐标
@property (nonatomic, weak)   id<ChartHighlightDelegate>     delegate;          //高亮显示具体绘制代理
@end
