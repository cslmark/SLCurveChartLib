//
//  ChartAxisBase.m
//  SLChartDemo
//
//  Created by smart on 2017/5/19.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "ChartAxisBase.h"

@implementation ChartAxisBase
#pragma mark - 初始化方法
-(void) setup{
    if (self.labelFont == nil) {
        self.labelFont = [UIFont systemFontOfSize:11.0];
    }
    if (self.labelTextColor == nil) {
        self.labelTextColor = [UIColor whiteColor];
    }
    if (self.axisLineColor == nil) {
        self.axisLineColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    }
    self.axisLineWidth = 1.0;
    if (self.gridColor == nil) {
        self.gridColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    }
    self.gridLineWidth = 1.0;
    self.drawGridLinesEnabled = NO;
    self.drawAxisLineEnabled = NO;
    self.drawLabelsEnabled = NO;
    self.maxLongLabelString = @"123";
}

-(instancetype) init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

#pragma mark - 工具类方法
-(CGSize) getLabelSize{
    if (self.maxLongLabelString != nil) {
        NSDictionary *attrs = [self getAttributes];
        CGSize size = [self.maxLongLabelString sizeWithAttributes:attrs];
        return size;
    }
    return CGSizeZero;
}

-(NSDictionary *) getAttributes{
    NSDictionary *attrs = [self getAttributesWithfont:self.labelFont Color:self.labelTextColor];
    return attrs;
}

-(NSMutableDictionary *) getAttributesWithfont:(UIFont*)font Color:(UIColor*) color{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = color;
    attrs[NSFontAttributeName] = font;
    return attrs;
}
@end
