//
//  SLChartDataProtocol.h
//  SLChartDemo
//
//  Created by smart on 2017/5/17.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartDataEntry.h"
#import "SLChartFormatterProtocol.h"

@protocol SLChartDataProtocol <NSObject>
-(void) notifyDataSetChanged;
-(CGFloat) yMin;
-(CGFloat) yMax;
-(CGFloat) xMin;
-(CGFloat) xMax;
-(void) calcMinMax;
//-(void) calcMinMaxYFrom:(double) fromX  to:(double) toX;
-(NSInteger) entryCount;
-(ChartDataEntry *) entryForIndex:(int) index;
-(void) setValueFormatter:(id<SLChartFormatterProtocol>) valueFormatter;
-(id <SLChartFormatterProtocol>) valueFormatter;
-(NSString *) label;
-(int ) entryIndex:(ChartDataEntry *) e;
-(BOOL) addEntry:(ChartDataEntry *) e;
-(BOOL) addEntryOrdered:(ChartDataEntry *) e;
-(BOOL) removeEntry:(ChartDataEntry *) e;
-(BOOL) removeEntryWithIndex:(int) index;
-(BOOL) removeFirst;
-(BOOL) removeLast;
-(BOOL) containsEntry:(ChartDataEntry *) e;
-(void) clear;
@end
