//
//  zichenPhotoView.h
//  PhotoTest
//
//  Created by chen on 14-11-11.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zichenPhoto.h"
#import "CommDefine.h"

@class zichenPhoto, zichenPhotoBrowser;

@protocol zichenPhotoViewDelegate <NSObject>

@optional
- (void)photoViewSingleTap;
@end

@interface zichenPhotoView : UIScrollView<UIScrollViewDelegate>
// 图片
@property (nonatomic, strong) zichenPhoto *photo;
// 代理
@property (nonatomic, assign) id<zichenPhotoViewDelegate> photoViewDelegate;
@end
