//
//  BaseCurveView.h
//  SLChartDemo
//
//  Created by smart on 2017/5/17.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLLineChartDataSet.h"
#import "ChartAxisBase.h"
#import "ChartHighlight.h"

#define   KScreen_W    [[UIScreen mainScreen] bounds].size.width
#define   KScreen_H    [[UIScreen mainScreen] bounds].size.height

@interface BaseCurveView : UIView
{
    NSNumber* _dynamicYAixs;
    NSNumber* _scaleXEnabled;
    NSNumber* _visibleXRangeMinimum;
    NSNumber* _visibleXRangeMaximum;
}
@property (nonatomic, strong) SLLineChartDataSet* datasource;
//常用的配置，是否开启缩放和动态纵坐标<默认是开启的>
//是否从0开始作为绘制点，默认是 NO
//传入 @YES  @NO   @num
@property (nonatomic, strong) NSNumber* dynamicYAixs;
@property (nonatomic, strong) NSNumber* scaleXEnabled;
@property (nonatomic, strong) NSNumber* visibleXRangeMinimum;
@property (nonatomic, strong) NSNumber* visibleXRangeMaximum;
@property (nonatomic, strong) NSNumber* visibleXRangeDefaultmum;
@property (nonatomic, strong) NSNumber* hightLightTap;
@property (nonatomic, strong) NSNumber* baseYValueFromZero;
//X轴和Y坐标轴
@property (nonatomic, strong) ChartAxisBase* XAxis;
@property (nonatomic, strong) ChartAxisBase* leftYAxis;
@property (nonatomic, strong) ChartAxisBase* rightYAxis;
@property (nonatomic, strong) ChartHighlight* hightLight;

#pragma mark - 常用的方法
/**
 根据数据源，将曲线部分的数据源完全重新更新，当程序更改曲线密度的时候，需要更改该方法
 @param datasource 数据源<内部的set方法实现等效于该方法>
 */
-(void) refreashDataSourceRestoreContext:(SLLineChartDataSet*) datasource;
/**
 仅仅是更新数据源，保存当前曲线的基本设定和现场
 @param datasource 数据源
 */
-(void) refreashDataSource:(SLLineChartDataSet*) datasource;
-(void) refreashGraph;
@end
