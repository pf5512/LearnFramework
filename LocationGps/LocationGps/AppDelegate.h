//
//  AppDelegate.h
//  LocationGps
//
//  Created by chen on 14-9-16.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
