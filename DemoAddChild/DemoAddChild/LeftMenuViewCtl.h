//
//  LeftMenuViewCtl.h
//  DemoAddChild
//
//  Created by chen on 14-12-18.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol leftMenuDelegate <NSObject>

@optional
-(void)didMoveToCenter;

@end


@interface LeftMenuViewCtl : UIViewController

@property(nonatomic, assign)id<leftMenuDelegate> delegate;

@end
