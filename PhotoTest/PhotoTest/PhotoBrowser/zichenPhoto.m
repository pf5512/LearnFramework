//
//  zichenPhoto.m
//  PhotoTest
//
//  Created by chen on 14-11-11.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "zichenPhoto.h"
#import <QuartzCore/QuartzCore.h>

@implementation zichenPhoto

#pragma mark 截图
- (UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setSrcImageView:(UIImageView *)srcImageView
{
    _srcImageView = srcImageView;
}
@end
