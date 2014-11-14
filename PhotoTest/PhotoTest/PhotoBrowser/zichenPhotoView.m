//
//  zichenPhotoView.m
//  PhotoTest
//
//  Created by chen on 14-11-11.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "zichenPhotoView.h"

@interface zichenPhotoView()
{
    UIImageView *_imageView;
}

@end

@implementation zichenPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        // 图片
        _imageView = [[UIImageView alloc] initWithFrame:frame];//CGRectMake(0, frame.origin.y, 320, 568)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        // 属性
        //self.contentSize = _imageView.frame.size;
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.maximumZoomScale = 3;
        self.minimumZoomScale = 1;
        self.zoomScale = self.minimumZoomScale;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        //		self.decelerationRate = UIScrollViewDecelerationRateFast;
        //		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

#pragma mark - photoSetter
- (void)setPhoto:(zichenPhoto *)photo
{
    _photo = photo;
    [self showImage];
}

#pragma mark 显示图片
- (void)showImage
{
    _imageView.image = _photo.srcImageView.image;
    
    // 调整frame参数
    //[self adjustFrame];
}

#pragma mark 调整frame
- (void)adjustFrame
{
    if (_imageView.image == nil)
        return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    // 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
    if (minScale > 1) {
        minScale = 1.0;
    }
    CGFloat maxScale = 2.0;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
    } else {
        imageFrame.origin.y = 0;
    }
    
    _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap)]) {
        [self.photoViewDelegate photoViewSingleTap];
    }
}

@end
