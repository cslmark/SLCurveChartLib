//
//  SLChartDataSet.m
//  SLChartDemo
//
//  Created by smart on 2017/5/17.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "SLLineChartDataSet.h"
@interface SLLineChartDataSet()
{
    double _yMax;
    double _yMin;
    double _xMax;
    double _xMin;
}
@end


@implementation SLLineChartDataSet
#pragma mark - 初始化的方法
-(void) setup{
    if (_values == nil) {
        _values = [NSMutableArray arrayWithCapacity:1];
    }
    _yMax = -DBL_MAX;
    _yMin = DBL_MAX;
    _xMax = -DBL_MAX;
    _xMin = DBL_MAX;
    
    //默认点的颜色和对应展示
    self.label = @"Default Line";
    self.mode = brokenLineMode;
    self.drawCirclesEnabled = YES;
    self.drawCircleHoleEnabled = NO;
    self.lineCapType = kCGLineCapButt;
    self.lineWidth = 2.0;
    self.circleRadius = 4.0;
    self.circleHoleRadius = 0.0;
    
    //颜色部分默认设置
    self.color = [UIColor whiteColor];
    self.circleColor = [UIColor whiteColor];
    self.circleHoleColor = [UIColor clearColor];
    self.highlightColor = [UIColor whiteColor];
    self.graphColor = [UIColor lightGrayColor];
    
    //默认的设置
    self.drawFilledEnabled = NO;
    self.lineFillMode = gradientolorFillMode;
    self.gradientColors = @[[UIColor greenColor], [UIColor lightGrayColor]];
    self.fillColor = [UIColor greenColor];
}

-(instancetype) initWithValues:(NSMutableArray *) values label:(NSString *) label{
    self = [super init];
    if (self) {
        [self setup];
        self.values = values;
        self.label = label;
    }
    return self;
}

#pragma mark - Get 和 Set方法
-(NSMutableArray *) values{
    return _values;
}

-(void) setValues:(NSMutableArray<ChartDataEntry *> *)values{
    _values = values;
    [self notifyDataSetChanged];
}


#pragma mark - SLChartDataProtocol 协议部分
-(void) notifyDataSetChanged{
    [self calcMinMax];
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

-(void) calcMinMax{
    if (_values.count == 0) {
        return;
    }
    _yMax = -DBL_MAX;
    _yMin = DBL_MAX;
    _xMax = -DBL_MAX;
    _xMin = DBL_MAX;
    for (ChartDataEntry* entry in _values) {
        [self calcMinMaxWithEntry:entry];
    }
}

-(NSInteger) entryCount{
    if (_values == nil) {
        return 0;
    }else{
        return _values.count;
    }
}

-(ChartDataEntry *) entryForIndex:(int) index{
    if ((index >= 0) && (index < _values.count)) {
        return _values[index];
    }else{
        return nil;
    }
}
-(int ) entryIndex:(ChartDataEntry *) e{
    for (int i = 0; i < _values.count; i++) {
        if ([_values[i] isEqualWithEntry:e]) {
            return i;
        }
    }
    return -1;
}

-(BOOL) addEntry:(ChartDataEntry *) e{
    if (_values == nil) {
        _values = [NSMutableArray arrayWithCapacity:1];
    }
    [self calcMinMaxWithEntry:e];
    [_values addObject:e];
    return YES;
}

-(BOOL) addEntryOrdered:(ChartDataEntry *) e{
    if (_values == nil) {
        _values = [NSMutableArray arrayWithCapacity:1];
    }
    [self calcMinMaxWithEntry:e];
    if ((_values.count > 0) && ([_values lastObject].x > e.x)) {
        int closetIndex = [self entryIndexWithX:e.x closestToY:e.y rounding:up];
        while (_values[closetIndex].x < e.x) {
            closetIndex += 1;
        }
        [_values insertObject:e atIndex:closetIndex];
    }else{
        [_values addObject:e];
    }
    return NO;
}

-(BOOL) removeEntry:(ChartDataEntry *) e{
    BOOL removed = NO;
    for (ChartDataEntry* entry in _values) {
        if ([entry isEqualWithEntry:e]) {
            [_values removeObject:entry];
            removed = YES;
            break;
        }
    }
    if (removed) {
        [self calcMinMax];
    }
    return removed;
}

-(BOOL) removeEntryWithIndex:(int) index{
    if ((_values == nil) || (_values.count == 0)) {
        return NO;
    }
    [_values removeObjectAtIndex:index];
    [self calcMinMax];
    return YES;
}

-(BOOL) removeFirst{
    if ((_values == nil) || (_values.count == 0)) {
        return NO;
    }
    [_values removeObjectAtIndex:0];
    [self calcMinMax];
    return YES;
}

-(BOOL) removeLast{
    if ((_values == nil) || (_values.count == 0)) {
        return NO;
    }
    [_values removeLastObject];
    [self calcMinMax];
    return YES;
}

-(BOOL) containsEntry:(ChartDataEntry *) e{
    for (ChartDataEntry* entry in _values) {
        if ([entry isEqualWithEntry:e]) {
            return YES;
        }
    }
    return NO;
}

-(void) clear{
    [_values removeAllObjects];
    [self notifyDataSetChanged];
}

#pragma mark - 额外提供计算最大和最小值的方法
-(void) calcMinMaxWithEntry:(ChartDataEntry *) entry{
    [self calcMinMaxXWithEntry:entry];
    [self calcMinMaxYWithEntry:entry];
}

-(void) calcMinMaxXWithEntry:(ChartDataEntry *)entry{
    if (entry.x < _xMin)
    {
        _xMin = entry.x;
    }
    if (entry.x > _xMax)
    {
        _xMax = entry.x;
    }
}

-(void) calcMinMaxYWithEntry:(ChartDataEntry *) entry{
    if (entry.y < _yMin)
    {
        _yMin = entry.y;
    }
    if (entry.y > _yMax)
    {
        _yMax = entry.y;
    }
}

//二分法查找对应位置的坐标
-(int) entryIndexWithX:(double) xValue closestToY:(double) yValue rounding:(ChartDataSetRounding) rounding{
    int low = 0;
    int high = (int)(_values.count - 1);
    int closest = high;
    while (low < high) {
        int m  = (low + high)/2;
        double d1 = _values[m].x - xValue;
        double d2 = _values[m+1].x - xValue;
        double ad1 = fabs(d1);
        double ad2 = fabs(d2);
        if (ad2 < ad1) {
            low = m + 1;
        }
        else if(ad1 < ad2){
            high = m;
        }
        else{
            if (d1 >= 0.0) {
                high = m;
            }else if(d1 < 0.0){
                low = m + 1;
            }
        }
        closest = high;
    }
    if (closest != -1) {
        double closestXValue = _values[closest].x;
        if (rounding == up) {
            if ((closestXValue < xValue) && (closest < _values.count - 1)) {
                closest += 1;
            }
        }else if(rounding == down){
            if ((closestXValue > xValue) && (closest < _values.count - 1)) {
                closest -= 1;
            }
        }
        
        //Search by closet to y-Value
        if (yValue != NAN) {
            while ((closest > 0) && (_values[closest - 1].x == closestXValue)) {
                closest -= 1;
            }
        }
        
        double closestYValue = _values[closest].y;
        int closeYIndex = closest;
        while(1){
            closest += 1;
            if (closest > _values.count) {
                break;
            }
            ChartDataEntry* value = _values[closest];
            if (value.x != closestXValue) {
                break;
            }
            if (fabs(value.y - yValue) < fabs(closestYValue - yValue)) {
                closestYValue = yValue;
                closeYIndex = closest;
            }
            closest = closestYValue;
        }
    }
    return closest;
}


@end
