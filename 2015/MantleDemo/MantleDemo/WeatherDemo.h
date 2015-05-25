//
//  WeatherDemo.h
//  MantleDemo
//
//  Created by Mac on 15/5/23.
//  Copyright (c) 2015年 JuGuang. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

@interface WeatherDemo : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *wearthDescription;
@property (strong, nonatomic) NSString *weartherMain;
@property (strong, nonatomic) NSNumber *weartherId;
@property (strong, nonatomic) NSString *wearthericon;

@end
