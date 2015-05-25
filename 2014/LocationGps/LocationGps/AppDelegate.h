//
//  AppDelegate.h
//  LocationGps
//
//  Created by chen on 14-9-16.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (unsafe_unretained, nonatomic) UIBackgroundTaskIdentifier taskIdentifier;
@property (nonatomic, retain) NSTimer *m_timer;
@property (nonatomic, retain) NSURLSession *session;
@property (nonatomic, retain) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, retain) NSMutableDictionary *completionHandlerDictionary;

@end
