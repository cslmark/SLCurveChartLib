//
//  SLGCDTimerTool.h
//  BrytyAir1
//
//  Created by smart on 16/8/18.
//  Copyright © 2016年 smart. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef dispatch_source_t SLGCDTimer;
@interface SLGCDTimerTool : NSObject
+(SLGCDTimer) scheduledOnceWith:(dispatch_queue_t) queue
                 interval:(NSTimeInterval) timeinterval
                  handler:(dispatch_block_t) handler;
+(SLGCDTimer) scheduledWith:(dispatch_queue_t) queue
                   interval:(NSTimeInterval) timeinterval
                    handler:(dispatch_block_t) handler;
+(void) cancelTimer:(SLGCDTimer) timer;

@end
