//
//  SLGCDTimerTool.m
//  BrytyAir1
//
//  Created by smart on 16/8/18.
//  Copyright © 2016年 smart. All rights reserved.
//

#import "SLGCDTimerTool.h"

@implementation SLGCDTimerTool
+(SLGCDTimer) scheduledOnceWith:(dispatch_queue_t) queue
                interval:(NSTimeInterval) timeinterval
                 handler:(dispatch_block_t) handler{
    if (queue == nil) {
        queue = dispatch_get_main_queue();
    }
    SLGCDTimer timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeinterval * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(timeinterval * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, start, interval, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (handler) {
            dispatch_source_cancel(timer);
            handler();
        }
    });
    dispatch_resume(timer);
    return timer;
}

+(SLGCDTimer) scheduledWith:(dispatch_queue_t) queue
                   interval:(NSTimeInterval) timeinterval
                    handler:(dispatch_block_t) handler{
    if (queue == nil) {
        queue = dispatch_get_main_queue();
    }
    SLGCDTimer timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeinterval * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(timeinterval * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, start, interval, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (handler) {
            handler();
        }
    });
    dispatch_resume(timer);
    return timer;
}

+(void) cancelTimer:(SLGCDTimer) timer{
    if (timer) {
        dispatch_source_cancel(timer);
    }
}

@end
