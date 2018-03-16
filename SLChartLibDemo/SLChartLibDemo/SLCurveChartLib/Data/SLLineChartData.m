//
//  SLLineChartData.m
//  SLChartLibDemo
//
//  Created by smart on 2017/6/20.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "SLLineChartData.h"

NSString *const SLDataLabelKey = @"SLDataLabelKey";
NSString *const SLDataValueKey = @"SLDataValueKey";
@interface SLLineChartData()
{
    double _yMax;
    double _yMin;
    double _xMax;
    double _xMin;
}
@end

@implementation SLLineChartData
-(void) setup{
    if (_dataSets == nil) {
        _dataSets = [NSMutableArray arrayWithCapacity:1];
    }
    _yMax = -DBL_MAX;
    _yMin = DBL_MAX;
    _xMax = -DBL_MAX;
    _xMin = DBL_MAX;
    
    self.graphColor = [UIColor lightGrayColor];
}

-(instancetype) initWithValues:(NSMutableArray<id<SLChartDataProtocol>> *) set{
    self = [super init];
    if (self) {
        [self setup];
        self.dataSets = set;
         [self notifyDataSetChanged];
    }
    return self;
}

-(void) setDataSets:(NSMutableArray<id<SLChartDataProtocol>> *)dataSets{
    _dataSets = dataSets;
    [self notifyDataSetChanged];
}

-(void) notifyDataSetChanged{
    [self calcMinMax];
}

-(void) calcMinMax{
    if (_dataSets.count == 0) {
        return;
    }
    _yMax = -DBL_MAX;
    _yMin = DBL_MAX;
    _xMax = -DBL_MAX;
    _xMin = DBL_MAX;
    for (id<SLChartDataProtocol> d in _dataSets) {
        [self calcMinMaxDataSet:d];
    }
}

-(void) calcMinMaxDataSet:(id<SLChartDataProtocol>) d{
    if (_yMax < [d yMax]) {
        _yMax = [d yMax];
    }
    if (_yMin > [d yMin]) {
        _yMin = [d yMin];
    }
    if (_xMax < [d xMax]) {
        _xMax = [d xMax];
    }
    if (_xMin > [d xMin]) {
        _xMin = [d xMin];
    }
}

-(CGFloat) yMin{
    return _yMin;
}

-(CGFloat) yMax{
    return _yMax;
}

-(CGFloat) xMin{
    return _xMin;
}

-(CGFloat) xMax{
    return _xMax;
}

-(int) entryCount{
    id<SLChartDataProtocol> ref = [self firstReference];
    if (ref != nil) {
        return [ref entryCount];
    }
    return -1;
}


-(int) getDataSetIndexByLabel:(NSString *) label  ignoreCase:(BOOL) ignore{
    if (_dataSets.count == 0) {
        return -1;
    }
    if (ignore) {
        for (int i = 0; i < _dataSets.count; i++) {
            id<SLChartDataProtocol> d = _dataSets[i];
            if ([d label] == nil) {
                continue;
            }
            if ([label compare:[d label] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                return i;
            }
        }
    }else{
        for (int i = 0; i < _dataSets.count; i++) {
            id<SLChartDataProtocol> d = _dataSets[i];
            if ([d label] == nil) {
                continue;
            }
            if ([label compare:[d label]] == NSOrderedSame) {
                return i;
            }
        }
    }
    return -1;
}

-(NSArray<NSString *> *) dataSetLabels{
    NSMutableArray* types = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < _dataSets.count; i++) {
        id<SLChartDataProtocol> d = _dataSets[i];
        if ([d label] == nil) {
            continue;
        }
        [types addObject:[d label]];
    }
    return types;
}


-(NSMutableArray<NSDictionary *>*)entryArrayForHighLight:(ChartHighlight *) highlight{
    NSMutableArray* entryArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < _dataSets.count; i++) {
        NSMutableDictionary* tempDict = [NSMutableDictionary dictionaryWithCapacity:2];
        id<SLChartDataProtocol> d = _dataSets[i];
        if (highlight.dataSetIndex >= [d entryCount]) {
            continue;
        }
        [tempDict setObject:[d label]?[d label]:@"" forKey:SLDataLabelKey];
        ChartDataEntry* data = [d entryForIndex:(int)highlight.dataIndex];
        [tempDict setObject:data forKey:SLDataValueKey];
        [entryArray addObject:tempDict];
    }
    return entryArray;
}

-(int) dataSetIndexForHigLight:(ChartHighlight *) highlight{
    CGFloat fabsTemp = DBL_MAX;
    int index = -1;
    for (int i = 0; i < _dataSets.count; i++) {
        id<SLChartDataProtocol> d = _dataSets[i];
        if (highlight.dataSetIndex >= [d entryCount]) {
            continue;
        }
        ChartDataEntry* data = [d entryForIndex:(int)highlight.dataIndex];
        if (fabs(data.y - highlight.touchYValue) < fabsTemp) {
            fabsTemp = fabs(data.y - highlight.touchYValue);
            index = i;
        }
    }
    return index;
}

-(ChartDataEntry *) entryPointForHighLight:(ChartHighlight *) highlight{
    int setIndex = [self dataSetIndexForHigLight:highlight];
    if (setIndex == -1) {
        return nil;
    }else{
        id<SLChartDataProtocol> d = _dataSets[setIndex];
        ChartDataEntry* entry = [d entryForIndex:(int)highlight.dataIndex];
        return entry;
    }
}

-(id<SLChartDataProtocol>) getDataSetByLabel:(NSString*) label ignoreCase:(BOOL) ignore{
    int index = [self getDataSetIndexByLabel:label ignoreCase:ignore];
    if ((index < 0) || (index > _dataSets.count)) {
        return nil;
    }else{
        return _dataSets[index];
    }
}

-(id<SLChartDataProtocol>) getDataSetByIndex:(int) index{
    if ((index < 0) || (index > _dataSets.count)) {
        return nil;
    }else{
        return _dataSets[index];
    }
}

-(id<SLChartDataProtocol>) firstReference{
    if (_dataSets.count) {
        return [_dataSets firstObject];
    }else{
        return nil;
    }
}

-(void) addDataSets:(id<SLChartDataProtocol>)dataSet{
    [self calcMinMaxDataSet:dataSet];
    [_dataSets addObject:dataSet];
}

-(BOOL) removeDataSet:(id<SLChartDataProtocol>) dataSet{
    if (dataSet == nil) {
        return NO;
    }else{
        [_dataSets removeObject:dataSet];
        [self notifyDataSetChanged];
        return YES;
    }
}

-(BOOL) removeDataSetByIndex:(int) index{
    if ((index >= _dataSets.count) || (index < 0)) {
        return NO;
    }
    [_dataSets removeObjectAtIndex:index];
    [self notifyDataSetChanged];
    return YES;
}

-(void) addEntry:(ChartDataEntry *) entry atIndex:(int) dataSetIndex{
    if (_dataSets.count > dataSetIndex  && dataSetIndex >= 0) {
        id<SLChartDataProtocol> d = _dataSets[dataSetIndex];
        if (![d respondsToSelector:@selector(addEntry:)]) {
            return;
        }else{
            [d addEntry:entry];
        }
        [self calcMinMaxDataSet:d];
    }else{
        return;
    }
}

-(BOOL) removeEntry:(ChartDataEntry *) entry atIndex:(int) dataSetIndex{
    if (_dataSets.count > dataSetIndex  && dataSetIndex >= 0) {
        id<SLChartDataProtocol> d = _dataSets[dataSetIndex];
        BOOL result = NO;
        if (![d respondsToSelector:@selector(removeEntry:)]) {
            return NO;
        }else{
           result = [d removeEntry:entry];
        }
        [self calcMinMaxDataSet:d];
        return result;
    }else{
        return NO;
    }
}


@end
