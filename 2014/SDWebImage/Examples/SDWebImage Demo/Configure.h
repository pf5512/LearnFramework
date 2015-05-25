//
//  Configure.h
//  SDWebImage Demo
//
//  Created by chen on 14-8-29.
//  Copyright (c) 2014年 Dailymotion. All rights reserved.
//

/*
 *Configure.h 用来注释讲述这个framework工作流程.
 
 SDWebImage Framework
 1,下载, 手动去github下载 是下载不完全的, 因为在SDWebImage中还用到了libwebp(google出品)关于图片的有损和无损压缩算法.
 如果是用cocoapods的用户就不需要了, 我是手动命令下载的用git命令从网上clone下来.
 单独从github上下载下来的第三库 编译出错
 clang: error: no such file or directory: 'SDWebImage/Vendors/libwebp/src/utils/random.c'
 clang: error: no input files
 显示文件找不到
 问题原因: SDWebImage 有submodules ->libwepo 关联  直接下载会下载不到这个submodules
 解决方式: 直接用git 命令去git clone一份代码下来, git 命令会自动关联下载submodules
 git命令:
 git clone --recursive https://github.com/rs/SDWebImage.git
 
 
 2,分析代码
 第一个文件:
 UIImageView+WebCache 是UIImageView的扩展类 主要是辅助有WebCache
 
 //下载图片文件
 - (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
 
 
 
 */