//
//  keychainObject.h
//  keychainDemo
//
//  Created by chen on 14-12-9.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

#define KEYCHAIN @"com.keychain.usernamepassword"
#define KEYCHAIN_NAME @"com.keychain.name"
#define KEYCHAIN_PASS @"com.keychain.pass"

@interface keychainObject : NSObject

+(void)saveKey:(NSString *)keychainString :(NSData *)data;
+(id)loadKey:(NSString *)keychainString;
+(void)deleteKey:(NSString *)keychainString;

@end
