//
//  SingleAssetOperation.m
//  PhotoTest
//
//  Created by chen on 14-11-7.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "SingleAssetOperation.h"

static SingleAssetOperation *SingleOperation = nil;
@implementation SingleAssetOperation

+(SingleAssetOperation *)ShareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SingleOperation = [[SingleAssetOperation alloc] init];
    });
    
    return SingleOperation;
}

-(NSString *)GetPhotoUrlByPath:(NSString *)filePath
{
    NSString *returnStr;
    NSArray *temp = [filePath componentsSeparatedByString:@"."];
    NSString *fileTemp = @"assets-library://asset/asset.JPG";
    returnStr = [fileTemp stringByAppendingFormat:@"?id=%@&ext=%@",[temp objectAtIndex:0], [temp lastObject]];
    return returnStr;
}

-(NSString *)GetPhotoAblumByPath:(NSString *)filePath
{
    NSString *returnStr;
    NSArray *temp = [filePath componentsSeparatedByString:@"."];
    NSString *fileTemp = @"assets-library://asset/asset.PNG";
    returnStr = [fileTemp stringByAppendingFormat:@"?id=%@&ext=%@",[temp objectAtIndex:0], [temp lastObject]];
    return returnStr;
}

-(NSString *)getFileName:(NSString *)fileName
{
    NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
    NSString *suffix = [temp lastObject];
    
    temp = [[temp objectAtIndex:0] componentsSeparatedByString:@"?id="];
    NSString *name = [temp lastObject];
    
    name = [name stringByAppendingFormat:@".%@",suffix];
    return name;
}

-(NSString *)GetUrlByPath:(NSString *)stringPath
{
    NSArray *temp = [stringPath componentsSeparatedByString:@"."];
    NSString *lastObject = [temp lastObject];
    NSString *ImageTaken;
    if ([lastObject isEqualToString:@"JPG"])
    {
        ImageTaken = [self GetPhotoUrlByPath:stringPath];
    }
    else
    {
        ImageTaken = [self GetPhotoAblumByPath:stringPath];
    }
    
    return ImageTaken;
}

#pragma mark ==裁剪小图,用来显示==
-(UIImage *)MakeImageView:(UIImage *)image
{
    UIImage *newImage;
    //CGSize newSize = size;
    CGSize newSize=CGSizeMake(105, 105);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UIImage *)MakeImageView:(UIImage *)image NewSize:(CGSize)size
{
    UIImage *newImage;
    CGSize newSize = size;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(NSString *)getDateKeyPath
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSDateFormatter *m_formatter = [[NSDateFormatter alloc] init];
    [m_formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *time1 = [m_formatter stringFromDate:[NSDate date]];
    NSString *imageStr = [NSString stringWithFormat:@"%@.png", time1];
    NSString *filePath =  [docPath stringByAppendingPathComponent:imageStr];
    
    return filePath;
}

@end
