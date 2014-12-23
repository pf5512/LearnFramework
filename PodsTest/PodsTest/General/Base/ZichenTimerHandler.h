//
//  ZichenTimerHandler.h
//  PodsTest
//
//  Created by chen on 14-12-23.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

/*
 * 将 nsitmer 跟 viewconyroller 分离开来, 解耦
 */

#import <Foundation/Foundation.h>

@class ZichenTimerHandler;

@protocol ZichenTimerDelegate <NSObject>
-(void)ZichenNStimerHandler:(ZichenTimerHandler *)handler;
@end

@interface ZichenTimerHandler : NSObject
@property(nonatomic, weak)id<ZichenTimerDelegate> ZichenTimerDelegate;

-(void)startZichenTimer:(NSTimeInterval)timerInterval
                delegate:(id<ZichenTimerDelegate>)delegate
                repeate:(BOOL)repeate;

-(void)stopZichenTimer;

@end
