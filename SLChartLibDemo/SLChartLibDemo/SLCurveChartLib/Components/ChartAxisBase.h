//
//  ChartAxisBase.h
//  SLChartDemo
//
//  Created by smart on 2017/5/19.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "ChartComponentBase.h"
#import "SLChartAxisValueFormatterPotocol.h"

@protocol SLChartAxisValueFormatterPotocol;
typedef enum : NSUInteger {
    XAxisType,
    YLeftAxisType,
    YrightAxisType,
} ChartAxisType;

typedef enum : NSUInteger {
    straightModeLine,
    dashModeLine,
} GridLinesMode;

@interface ChartAxisBase : ChartComponentBase
@property (nonatomic, strong) id<SLChartAxisValueFormatterPotocol> axisValueFormatter;
@property (nonatomic, strong) UIFont*       labelFont;
@property (nonatomic, strong) UIColor*      labelTextColor;
@property (nonatomic, strong) UIColor*      axisLineColor;
@property (nonatomic, assign) CGFloat       axisLineWidth;
@property (nonatomic, strong) UIColor*      gridColor;
@property (nonatomic, assign) CGFloat       gridLineWidth;
@property (nonatomic, assign) BOOL          drawGridLinesEnabled;
@property (nonatomic, assign) GridLinesMode GridLinesMode;
@property (nonatomic, assign) BOOL          drawAxisLineEnabled;
@property (nonatomic, assign) BOOL          drawLabelsEnabled;
@property (nonatomic, assign) BOOL          centerAxisLabelsEnabled;
@property (nonatomic, assign) NSString*     maxLongLabelString;
@property (nonatomic, assign) ChartAxisType axisType;

-(CGSize) getLabelSize;
-(NSDictionary *) getAttributes;
-(NSMutableDictionary *) getAttributesWithfont:(UIFont*)font Color:(UIColor*) color;
@end
