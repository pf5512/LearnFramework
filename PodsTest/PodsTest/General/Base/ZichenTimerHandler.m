//
//  ZichenTimerHandler.m
//  PodsTest
//
//  Created by chen on 14-12-23.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "ZichenTimerHandler.h"

@interface ZichenTimerHandler ()
{
    NSTimer *_ZichenTimer;
    BOOL _ZichenRepeate;
}

@end

@implementation ZichenTimerHandler

/*
 * 初始化
 */
-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

/*
 * 开启定时器
 */
-(void)startZichenTimer:(NSTimeInterval)timerInterval
               delegate:(id<ZichenTimerDelegate>)delegate
                repeate:(BOOL)repeate

{
    _ZichenTimerDelegate = delegate;
    _ZichenRepeate = repeate;
    
    if (_ZichenTimer) {
        [_ZichenTimer invalidate];
        _ZichenTimer = nil;
    }
    
    _ZichenTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval
                                                    target:self
                                                  selector:@selector(ZichenDoTimer:)
                                                  userInfo:nil
                                                   repeats:_ZichenRepeate];
}

/*
 * 停止定时器
 */
-(void)stopZichenTimer
{
    [_ZichenTimer invalidate];
    _ZichenTimer = nil;
    _ZichenTimerDelegate = nil;
}

/*
 * 定时器方法
 */
-(void)ZichenDoTimer:(NSTimer *)timer
{
    if (!_ZichenRepeate) {
        _ZichenTimer = nil;
    }
    
    if (_ZichenTimerDelegate && [_ZichenTimerDelegate respondsToSelector:@selector(ZichenNStimerHandler:)]) {
        [_ZichenTimerDelegate ZichenNStimerHandler:self];
    }
}

/*
 * 销毁
 */
-(void)dealloc
{
    [self stopZichenTimer];
}

@end
