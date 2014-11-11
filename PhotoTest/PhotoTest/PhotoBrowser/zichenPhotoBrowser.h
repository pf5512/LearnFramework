//
//  zichenPhotoBrowser.h
//  PhotoTest
//
//  Created by chen on 14-11-11.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommDefine.h"
#import "zichenPhotoView.h"

@interface zichenPhotoBrowser : UIViewController<UIScrollViewDelegate,zichenPhotoViewDelegate>
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@end
