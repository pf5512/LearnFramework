//
//  AppDelegate.h
//  PhotoTest
//
//  Created by chen on 14-10-29.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootView.h"
#import "PhotoAssertView.h"
#import "Configure.h"

/*
 *这个demo是昨天上午面试的题目:(上机)
 *大致功能是:1,调用摄像头拍照 2,排好的照片显示在界面上 3,点击单个图片可以进行放大缩小.
 */

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootView *rootview;
@property(strong, nonatomic) PhotoAssertView *photoview;


@end

