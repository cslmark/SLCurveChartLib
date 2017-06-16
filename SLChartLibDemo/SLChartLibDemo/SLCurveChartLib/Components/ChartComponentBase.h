//
//  ChartComponentBase.h
//  SLChartDemo
//
//  Created by smart on 2017/5/19.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChartComponentBase : NSObject
@property (nonatomic, assign) CGFloat xOffset;
@property (nonatomic, assign) CGFloat yOffset;
@property (nonatomic, assign, getter=isEnabled) BOOL    enabled;
@end
