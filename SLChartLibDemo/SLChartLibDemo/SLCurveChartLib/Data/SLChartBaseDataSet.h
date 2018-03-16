//
//  SLChartBaseDataSet.h
//  SLChartDemo
//
//  Created by smart on 2017/5/17.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLChartDataProtocol.h"

@interface SLChartBaseDataSet : NSObject<SLChartDataProtocol>
{
    id <SLChartFormatterProtocol> _valueFormatter;
}
@property (nonatomic, strong) id <SLChartFormatterProtocol> valueFormatter;
@end
