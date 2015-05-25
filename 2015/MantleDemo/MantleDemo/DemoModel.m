//
//  DemoModel.m
//  MantleDemo
//
//  Created by Mac on 15/5/23.
//  Copyright (c) 2015年 JuGuang. All rights reserved.
//

#import "DemoModel.h"
#import "WeatherDemo.h"
#import <Foundation/Foundation.h>

@implementation DemoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"date": @"dt", //将JSON字典里dt键对应的值，赋值给date属性
             @"locationName": @"name",
             @"humidity": @"main.humidity",
             @"temperature": @"main.temp",//这个点是什么意思呢，表示将main键对应的子字典里，
             
             @"tempHigh": @"main.temp_max",
             @"tempLow": @"main.temp_min",
             @"sunrise": @"sys.sunrise",
             @"sunset": @"sys.sunset",
//             @"conditionDescription": @"weather.description",
//             @"condition": @"weather.main",
             //@"icon": @"weather.icon",
             @"windBearing": @"wind.deg",
             @"windSpeed": @"wind.speed",
             @"weatherArray": @"weather",
             @"weatherFirst": @"weather",
    };
}

/*date时间类型转换*/
+ (NSValueTransformer *)dateJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error){
        NSTimeInterval secs = [value doubleValue];
        return [NSDate dateWithTimeIntervalSince1970:secs];
    } reverseBlock:^id(id value, BOOL *success, NSError **error){
        return @([value timeIntervalSince1970]);
    }];
}
/*date时间类型转换*/
+ (NSValueTransformer *)sunriseJSONTransformer
{
    return [self dateJSONTransformer];
}
/*date时间类型转换*/
+ (NSValueTransformer *)sunsetJSONTransformer
{
    return [self dateJSONTransformer];
}

/* 数组方式转换*/
+ (NSValueTransformer *)weatherJSONTransformer
{
    /*
     * 取数组第一个
     */
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error){
            return [value firstObject];
        }];
    /*
     * 取数组第一个
     */
//    return [MTLValueTransformer transformerWithBlock:^id(NSArray *array){
//        return [array firstObject];
//    }];
    
    /*
     * 取整个数组
     */
//    return [NSValueTransformer mtl_validatingTransformerForClass:[WeatherDemo class]];
}

@end
