//
//  AppDelegate.m
//  LocationGps
//
//  Created by chen on 14-9-16.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //设置最小后台获取内容间隔
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = (id)self;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    [_locationManager startUpdatingLocation];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //进入后台 更新gps信息
    if ([CLLocationManager significantLocationChangeMonitoringAvailable])
    {
        [_locationManager stopUpdatingLocation];
        [_locationManager startMonitoringSignificantLocationChanges];
    }
    
    if ([self isMultitaskingSupported] == NO)
        return ;
    //[self performSelector:@selector(timerMethod:) withObject:nil afterDelay:2];
    _m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
    /*
     *进入后台,主线程一般挂起,可以利用下面的保留一段时间
     *想在后台完成一个长期任务，必须调用UIApplication的beginBackgroundTaskWithExpirationHandler:
     *如果在这个期限内，长期任务没有被完成，iOS将终止程序。
     *每个对beginBackgroundTaskWithExpirationHandler:方法的调用，必须要相应的调用endBackgroundTask:
     */
    _taskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void){
        [self endBackTask];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if (_taskIdentifier != UIBackgroundTaskInvalid)
    {
        [self endBackTask];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([CLLocationManager significantLocationChangeMonitoringAvailable])
    {
        [_locationManager stopMonitoringSignificantLocationChanges];
        [_locationManager startUpdatingLocation];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 *收到远程推送之后, 可以根据推送过来的东西进入后台传输下载
 */
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Received remote notification with userInfo %@", userInfo);
    
    NSNumber *contentID = userInfo[@"content-id"];
    NSString *downloadURLString = [NSString stringWithFormat:@"http://yourserver.com/downloads/%d.mp3", [contentID intValue]];
    NSURL* downloadURL = [NSURL URLWithString:downloadURLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    NSURLSessionDownloadTask *task = [[self backgroundSession] downloadTaskWithRequest:request];
    task.taskDescription = [NSString stringWithFormat:@"Podcast Episode %d", [contentID intValue]];
    [task resume];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

/*
 *IOS 7 后台获取新内容, 类似于远程通知,服务器推送内容过来
 */
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
}

/*
 *后台文件传输  -_-不太懂这个api如何处理
 */
-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    //completionHandler();
}

- (void) beginDownload
{
    NSString *DownloadURLString = @"url";
    NSURL *downloadURL = [NSURL URLWithString:DownloadURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    self.session = [self backgroundSession];
    self.downloadTask = [self.session downloadTaskWithRequest:request];
    [self.downloadTask resume]; //下载开始
}

- (NSURLSession *)backgroundSession
{
    //Use dispatch_once_t to create only one background session. If you want more than one session, do with different identifier
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.yourcompany.appId.BackgroundSession"];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:(id)self delegateQueue:nil];
    });
    return session;
}

#pragma mark locationGps
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", locations);
}

/*当前设备是否支持多任务 */
-(BOOL)isMultitaskingSupported
{
    BOOL result= NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
    {
        result = [[UIDevice currentDevice] isMultitaskingSupported];
    }
    return  result;
}

//UIApplication的backgroundTimeRemaining属性包含了程序完成他的任务可以使用的秒数
- (void)timerMethod:(NSTimer *)paramSender
{
    //UIApplication的backgroundTimeRemaining属性包含了程序完成他的任务可以使用的秒数
    NSTimeInterval TimeVal = [[UIApplication sharedApplication] backgroundTimeRemaining];
    if (TimeVal == DBL_MAX)
    {
        NSLog(@"timeval isequal dbl_max");
    }
    else
    {
        NSLog(@"timeval %.2f", TimeVal);
    }
    
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setActive:YES error:nil];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    
//    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"shijianzhuyu" ofType:@"mp3"];
//    NSURL *url = [NSURL fileURLWithPath:mp3Path];
//    
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    //用下列代码播放音乐，测试后台播放
//    // 创建播放器
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//    //[url release];
//    [player prepareToPlay];
//    [player setVolume:1];
//    player.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
//    [player play]; //播放
}

-(void)endBackTask
{
    NSLog(@"endBackTask");
    dispatch_queue_t queue = dispatch_get_main_queue();
    __block AppDelegate *weakself = self;
    dispatch_async(queue, ^(void){
        AppDelegate *strongself = weakself;
        if (strongself != nil)
        {
            //移除定时器, 结束后台任务, 任务标记为UIBackgroundTaskInvalid
            [strongself.m_timer invalidate];
            [[UIApplication sharedApplication] endBackgroundTask:strongself.taskIdentifier];
            strongself.taskIdentifier = UIBackgroundTaskInvalid;
        }
    });
}

//url session for background
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"Background URL session %@ finished events.\n", session);
    if (session.configuration.identifier) {
        // Call the handler we stored in -application:handleEventsForBackgroundURLSession:
        //[self callCompletionHandlerForSession:session.configuration.identifier];
    }
}

@end
