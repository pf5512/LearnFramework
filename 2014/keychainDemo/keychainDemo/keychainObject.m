//
//  keychainObject.m
//  keychainDemo
//
//  Created by chen on 14-12-9.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "keychainObject.h"

@implementation keychainObject

+(NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge id)(kSecClassGenericPassword),kSecClass,
            service, kSecAttrService,
            service, kSecAttrAccount,
            kSecAttrAccessibleAfterFirstUnlock,kSecAttrAccessible,nil];
}

+(void)saveKey:(NSString *)keychainString :(NSData *)data
{
    NSMutableDictionary *chaindDic = [self getKeychainQuery:keychainString];
    SecItemDelete((__bridge CFDictionaryRef)chaindDic);
    [chaindDic setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)chaindDic, NULL);
}

+(id)loadKey:(NSString *)keychainString
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:keychainString];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", keychainString, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+(void)deleteKey:(NSString *)keychainString
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:keychainString];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

@end
