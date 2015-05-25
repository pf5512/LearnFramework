//
//  ASICommRequest.h
//  PodsTest
//
//  Created by chen on 14-12-17.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ASIHTTPRequest.h>

//第一种
typedef void (^CompletionBlock)(NSDictionary *result);
typedef void (^failBlock)(NSError *error);

//第二种 ASIhttp的回调函数 再做回调
@protocol ASICommRequestDelegate <NSObject>
@optional
-(void)DelegateSuccessHandle:(NSDictionary *)dicData;
-(void)DelegateFailHanlde:(NSError *)error;
@end

@interface ASICommRequest : NSObject

@property (nonatomic, assign) id<ASICommRequestDelegate> delegate;

//第一种
+(void)GetWearthInfo:(NSString *)url Completion:(CompletionBlock)handle  failHandle:(failBlock)failhand;

+(ASICommRequest *)shareInstance;
//第三种
-(void)getWeartherInfo:(NSString *)urlString successSEL:(SEL)success failSEL:(SEL)fail httpDelegate:(id<ASICommRequestDelegate>)delegate;

@end
