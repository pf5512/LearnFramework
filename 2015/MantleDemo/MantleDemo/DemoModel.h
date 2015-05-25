//
//  DemoModel.h
//  MantleDemo
//
//  Created by Mac on 15/5/23.
//  Copyright (c) 2015年 JuGuang. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"
#import "WeatherDemo.h"

@interface DemoModel : MTLModel<MTLJSONSerializing>

/*日期格式*/
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *tempHigh;
@property (nonatomic, strong) NSNumber *tempLow;
@property (nonatomic, strong) NSString *locationName;
/*日期格式*/
@property (nonatomic, strong) NSDate *sunrise;
/*日期格式*/
@property (nonatomic, strong) NSDate *sunset;

@property (nonatomic, strong) NSNumber *windBearing;
@property (nonatomic, strong) NSNumber *windSpeed;

/*
 * 传递回数组方式,既要数组,又要第一个的情况, 拆开分成两个类
 */
//数组方式
@property (nonatomic, strong) NSArray *weatherArray;
/*取数组第一个*/
@property (nonatomic, strong) WeatherDemo *weatherFirst;

@end
