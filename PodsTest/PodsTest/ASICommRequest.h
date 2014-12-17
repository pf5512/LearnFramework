//
//  ASICommRequest.h
//  PodsTest
//
//  Created by chen on 14-12-17.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ASIHTTPRequest.h>

typedef void (^CompletionBlock)(id result);
typedef void (^failBlock)(NSError *error);

@interface ASICommRequest : NSObject


+(void)GetWearthInfo:(NSString *)url Completion:(CompletionBlock)handle  failHandle:(failBlock)failhand;

@end
