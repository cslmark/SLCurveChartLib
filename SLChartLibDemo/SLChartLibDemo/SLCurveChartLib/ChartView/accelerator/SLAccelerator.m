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
    double timeStep;
    double current_v;      //加速器使用的当前速度
    double time;           //减速器所使用的时间间隔
    double deRate;         //减速的加速度
    double totalPanLength; //总工滑动的距离
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
-(void) panGesStarWithVelocity:(CGPoint) velocity translation:(CGPoint) translation{
    if (self.timer) {
        [SLGCDTimerTool cancelTimer:self.timer];
        self.timer = nil;
    }
    totalPanLength = translation.x;
    _lastVelocity.velocity = velocity.x;
    _lastVelocity.time = [[NSDate date] timeIntervalSince1970];
}

-(double) panGesStateChangeWithVelocity:(CGPoint) velocity translation:(CGPoint) translation{
    double distance = 0;
    if (self.timer) {
        [SLGCDTimerTool cancelTimer:self.timer];
        self.timer = nil;
    }
    _currentVelocity.velocity = velocity.x;
    _currentVelocity.time = [[NSDate date] timeIntervalSince1970];
    timeStep = _currentVelocity.time - _lastVelocity.time;
    if (timeStep != 0) {
        accelerator = (_currentVelocity.velocity - _lastVelocity.velocity)/timeStep;
        distance = translation.x + [self getTimeStance];
        totalPanLength += distance;
    }
    _lastVelocity.velocity = _currentVelocity.velocity;
    _lastVelocity.time = _currentVelocity.time;
    return distance;
}

-(double) panGesStateEndWithVelocity:(CGPoint) velocity
                         translation:(CGPoint) translation
                   decelerationBlock:(DecelerationBlock) deceBlock{
    double move_s = [self panGesStateChangeWithVelocity:velocity translation:translation];
    if (deceBlock != nil) {
        time = timeStep;
        if(_decelerationRate > 0){
            deRate = _decelerationRate;
        }else{
            deRate = 100;
        }
        if (self.pageScrollerEnable) {
            deRate = 10000;
            double userSwipeLength = totalPanLength - ((int)(totalPanLength/self.pageWidth))*self.pageWidth;
            NSLog(@"totalPanLength = %lf, userSwipeLength = %lf", totalPanLength, userSwipeLength);
            if (fabs(userSwipeLength) > fabs(self.pageWidth/2.0)) {
                __block double retainLength = self.pageWidth - fabs(userSwipeLength);
                self.timer = [SLGCDTimerTool scheduledWith:dispatch_get_main_queue() interval:time handler:^{
                    double distance = deRate*time;
                    if (retainLength < distance) {
                        distance = retainLength;
                        [SLGCDTimerTool cancelTimer:self.timer];
                    }
                    retainLength = retainLength - distance;
                    int flag = (userSwipeLength > 0) ? 1 : -1;   //符号的位选择
                    deceBlock(distance * flag);
                }];
            }else{
                __block double retainLength = fabs(userSwipeLength);
                self.timer = [SLGCDTimerTool scheduledWith:dispatch_get_main_queue() interval:time handler:^{
                    double distance = deRate*time;
                    if (retainLength < distance) {
                        distance = retainLength;
                        [SLGCDTimerTool cancelTimer:self.timer];
                    }
                    retainLength = retainLength - distance;
                    int flag = (userSwipeLength > 0) ? -1 : 1;   //符号的位选择
                    deceBlock(distance * flag);
                }];
            }
            
        }else{
            if ((deceBlock != nil) && (_decelerationEnable == YES)) {
                current_v = _currentVelocity.velocity;
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
        }
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
