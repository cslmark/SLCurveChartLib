//
//  Accelerator.m
//  SLChartLibDemo
//
//  Created by smart on 2017/7/2.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "SLAccelerator.h"
#import "SLGCDTimerTool.h"
@interface SLAccelerator()
{
    double accelerator;
    double decelerationRate;
    double timeStep;
    double current_v;      //加速器使用的当前速度
    double time;           //减速器所使用的时间间隔
    double deRate;         //减速的加速度
}
@property (nonatomic, strong) SLGCDTimer timer;
@end

@implementation SLAccelerator
-(void) setup{
    _lastVelocity = [[VelocityPoint alloc] init];
    _currentVelocity = [[VelocityPoint alloc] init];
    _decelerationRate = 50.0f;    //当传入异常值的时候也会按照50效果减速
    _decelerationEnable = NO;
}


-(instancetype) init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}


/**
 这里提供3个方法分别给你手势开始和移动和结束使用

 @param velocity 当前的速度
 */
-(void) panGesStarWith:(double) velocity{
    if (self.timer) {
        [SLGCDTimerTool cancelTimer:self.timer];
        self.timer = nil;
    }
    _lastVelocity.velocity = velocity;
    _lastVelocity.time = [[NSDate date] timeIntervalSince1970];
}

-(double) panGesStateChangeWith:(double) velocity{
    double distance = 0;
    if (self.timer) {
        [SLGCDTimerTool cancelTimer:self.timer];
        self.timer = nil;
    }
    _currentVelocity.velocity = velocity;
    _currentVelocity.time = [[NSDate date] timeIntervalSince1970];
    timeStep = _currentVelocity.time - _lastVelocity.time;
    if (timeStep != 0) {
        accelerator = (_currentVelocity.velocity - _lastVelocity.velocity)/timeStep;
        distance = [self getTimeStance];
    }
    _lastVelocity.velocity = _currentVelocity.velocity;
    _lastVelocity.time = _currentVelocity.time;
    return distance;
}

-(double) panGesStateEndWith:(double) velocity  decelerationBlock:(DecelerationBlock) deceBlock{
    double move_s = [self panGesStateChangeWith:velocity];
    if ((deceBlock != nil) && (_decelerationEnable == YES)) {
        current_v = _currentVelocity.velocity;
        time = timeStep;
        if(_decelerationRate > 0){
            deRate = _decelerationRate;
        }else{
            deRate = 50;
        }
        self.timer = [SLGCDTimerTool scheduledWith:dispatch_get_main_queue() interval:time handler:^{
            double distance = (current_v * time) + (time * time) * deRate * 0.5;
            if (fabs(current_v) > deRate) {
                if (current_v < 0) {
                    current_v += deRate;
                }else{
                    current_v -= deRate;
                }
            }else{
                [SLGCDTimerTool cancelTimer:self.timer];
            }
            deceBlock(distance);
        }];
    }
    return move_s;
}

-(double) getTimeStance{
   double move_S = (_lastVelocity.velocity * timeStep) + (timeStep * timeStep) * accelerator * 0.5;
    return move_S;
}

//提供停止减速的方法给外界使用,当其他手势作用的时候生效
-(void) stopTracking{
    if (self.timer) {
        [SLGCDTimerTool cancelTimer:self.timer];
        self.timer = nil;
    }
}

@end

@implementation VelocityPoint

@end
