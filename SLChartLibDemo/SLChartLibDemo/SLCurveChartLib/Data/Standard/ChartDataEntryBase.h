//
//  ChartDataEntryBase.h
//  SLChartDemo
//
//  Created by smart on 2017/5/17.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChartDataEntryBase : NSObject
@property (nonatomic, assign) double y;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) UIImage* icon;
@end
