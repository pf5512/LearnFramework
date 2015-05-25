//
//  WeatherDemo.m
//  MantleDemo
//
//  Created by Mac on 15/5/23.
//  Copyright (c) 2015年 JuGuang. All rights reserved.
//

#import "WeatherDemo.h"

@implementation WeatherDemo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"wearthDescription":@"description",
             @"weartherMain":@"main",
             @"weartherId":@"id",
             @"wearthericon":@"icon"
             };
}

@end
