//
//  AppDelegate.m
//  PhotoTest
//
//  Created by chen on 14-10-29.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "AppDelegate.h"
#import "SingleAssetOperation.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //前后两次打开不同,删除存储的路径
    NSString *type = [self loadStoreImageType];
    if ([type integerValue] != StoreImage)
    {
        [self deleteDocumentFile];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *nav;
    if (StoreImage == 1)
    {
        self.rootview = [[RootView alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController:self.rootview];
    }
    if (StoreImage == 2)
    {
        self.photoview = [[PhotoAssertView alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController:self.photoview];
    }
    
    //保存存储信息
    NSString *storeType = [NSString stringWithFormat:@"%d", StoreImage];
    [self saveStoreImageType:storeType];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    //设置document icloud 不备份, 把图片保存到document下
    [self setNotBackup];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ==前后打开不对时候,要删除document文件==
-(void)deleteDocumentFile
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *FileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docPath error:nil];
    for (NSString *str in FileList)
    {
        NSString *docStr = [docPath stringByAppendingPathComponent:str];
        [[NSFileManager defaultManager] removeItemAtPath:docStr error:nil];
        DLog(@"delete file %@", docStr);
    }
}

#pragma mark ==判断前后两次打开方式是否一样==
-(NSString *)loadStoreImageType
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *type = [user objectForKey:StoreImageType];
    
    return type;
}

-(void)saveStoreImageType:(NSString *)type
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:type forKey:StoreImageType];
    [user synchronize];
}

#pragma mark ==设置icloud 不备份==
-(void)setNotBackup
{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                    objectAtIndex:0];
    NSURL *url=[NSURL fileURLWithPath:path isDirectory:YES];
    BOOL success = [self addSkipBackupAttributeToItemAtURL:url];
    DLog(@"stop icloud :%hhd",success);
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    //assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    DLog(@"url lasr path %@", [URL lastPathComponent]);
    DLog(@"error %@", error);
    return success;
}

@end
