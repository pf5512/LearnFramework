//
//  SingleAssetOperation.h
//  PhotoTest
//
//  Created by chen on 14-11-7.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

/**
 *  @brief  单例, 集中做一些控制操作
 */

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface SingleAssetOperation : NSObject

+(SingleAssetOperation *)ShareInstance;
-(NSString *)GetPhotoUrlByPath:(NSString *)filePath;
-(NSString *)GetPhotoAblumByPath:(NSString *)filePath;
-(NSString *)getFileName:(NSString *)fileName;
-(NSString *)GetUrlByPath:(NSString *)stringPath;

//imageView
-(UIImage *)MakeImageView:(UIImage *)image;
-(UIImage *)MakeImageView:(UIImage *)image NewSize:(CGSize)size;

@end
