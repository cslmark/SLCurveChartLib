//
//  SLLineChartData.h
//  SLChartLibDemo
//
//  Created by smart on 2017/6/20.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLChartDataProtocol.h"
#import "ChartHighlight.h"

//HightLight中dictionary返回的内容Key值
UIKIT_EXTERN NSString *const SLDataLabelKey;
UIKIT_EXTERN NSString *const SLDataValueKey;

@interface SLLineChartData : NSObject
{
    NSMutableArray<id<SLChartDataProtocol>>* _dataSets;
}
@property (nonatomic, strong) NSMutableArray<id<SLChartDataProtocol>>* dataSets;
@property (nonatomic, strong) UIColor* graphColor;

-(instancetype) initWithValues:(NSMutableArray<id<SLChartDataProtocol>> *) set;
-(CGFloat) yMin;
-(CGFloat) yMax;
-(CGFloat) xMin;
-(CGFloat) xMax;
-(int) entryCount;
-(int) getDataSetIndexByLabel:(NSString *) label  ignoreCase:(bool) ignore;
-(NSArray<NSString *> *) dataSetLabels;
-(NSMutableArray<NSDictionary *>*)entryArrayForHighLight:(ChartHighlight *) highlight;
-(int) dataSetIndexForHigLight:(ChartHighlight *) highlight;
-(ChartDataEntry *) entryPointForHighLight:(ChartHighlight *) highlight;
-(id<SLChartDataProtocol>) getDataSetByLabel:(NSString*) label ignoreCase:(bool) ignore;
-(id<SLChartDataProtocol>) getDataSetByIndex:(int) index;
-(id<SLChartDataProtocol>) firstReference;
-(void) addDataSets:(id<SLChartDataProtocol>)dataSet;
-(BOOL) removeDataSet:(id<SLChartDataProtocol>) dataSet;
-(BOOL) removeDataSetByIndex:(int) index;
-(void) addEntry:(ChartDataEntry *) entry atIndex:(int) dataSetIndex;
-(BOOL) removeEntry:(ChartDataEntry *) entry atIndex:(int) dataSetIndex;
@end
