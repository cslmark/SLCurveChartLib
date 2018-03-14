//
//  SLChartBaseDataSet.m
//  SLChartDemo
//
//  Created by smart on 2017/5/17.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "SLChartBaseDataSet.h"

/*主要用来解决一些默认设置*/
@implementation SLChartBaseDataSet
-(void) notifyDataSetChanged{
    //ToDO
}

-(CGFloat) yMin{
    return 0.0;
}

-(CGFloat) yMax{
    return 0.0;
}

-(CGFloat) xMin{
    return 0.0;
}

-(CGFloat) xMax{
    return 0.0;
}

-(void) calcMinMax{
    //TO DO
}

//-(void) calcMinMaxYFrom:(double) fromX  to:(double) toX{
//    //TO DO
//}

-(NSString *) label{
    return nil;
}

-(NSInteger) entryCount{
    return 0;
}

-(int ) entryIndex:(ChartDataEntry *) e{
    return 0;
}

-(ChartDataEntry *) entryForIndex:(int) index{
    return nil;
}

-(void) setValueFormatter:(id<SLChartFormatterProtocol>) valueFormatter{
    _valueFormatter = valueFormatter;
}

-(id <SLChartFormatterProtocol>) valueFormatter{
    return _valueFormatter;
}

-(BOOL) addEntry:(ChartDataEntry *) e{
    return  NO;
}

-(BOOL) addEntryOrdered:(ChartDataEntry *) e{
    return NO;
}

-(BOOL) removeEntry:(ChartDataEntry *) e{
    return NO;
}

-(BOOL) removeEntryWithIndex:(int) index{
    return NO;
}

-(BOOL) removeFirst{
    return NO;
}

-(BOOL) removeLast{
    return NO;
}

-(BOOL) containsEntry:(ChartDataEntry *) e{
    return NO;
}

-(void) clear{
    
}

@end
