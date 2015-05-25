//
//  CenterViewCtl.h
//  DemoAddChild
//
//  Created by chen on 14-12-18.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewCtl.h"

@protocol centerviewDelegate <NSObject>

@optional
-(void)didMoveLeft;


@required
-(void)DidMoveCenterViewController;

@end



@interface CenterViewCtl : UIViewController<leftMenuDelegate>

@property(nonatomic, assign)id<centerviewDelegate> delegate;
@property(nonatomic, strong)UIButton *ChangeViewButton;

@end
