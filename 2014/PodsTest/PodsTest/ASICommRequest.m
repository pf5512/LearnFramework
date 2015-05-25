//
//  ASICommRequest.m
//  PodsTest
//
//  Created by chen on 14-12-17.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "ASICommRequest.h"

static ASICommRequest *ASIDemo = nil;
@interface ASICommRequest()
{
    SEL successHandle;
    SEL failHandle;
}
@end

@implementation ASICommRequest
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

//+(void)GetWearthInfo:(NSString *)url Completion:(CompletionBlock)handle
+(void)GetWearthInfo:(NSString *)url Completion:(CompletionBlock)handle failHandle:(failBlock)failhand
{
    NSURL *urlsring = [NSURL URLWithString:url];
    __block __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlsring];
    [request setRequestMethod:@"GET"];
    [request setCompletionBlock:^{
//        NSString *result = [request responseString];
//        NSDictionary *header = [request responseHeaders];
//        NSLog(@"code %d result %@ %@", [request responseStatusCode],result,header);
        
        NSData *data = [request responseData];
        //自带json解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic %@", dic);
        handle(dic);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failhand(error);
    }];
    [request startAsynchronous];
}

+(ASICommRequest *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ASIDemo = [[self alloc] init];
    });
    return ASIDemo;
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *data = [request responseData];
    //自带json解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"dic %@", dic);
    if ([_delegate respondsToSelector:successHandle]) {
        [_delegate performSelector:successHandle withObject:dic];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if ([_delegate respondsToSelector:failHandle]) {
        [_delegate performSelector:failHandle withObject:error];
    }
}

-(void)getWeartherInfo:(NSString *)urlString successSEL:(SEL)success failSEL:(SEL)fail httpDelegate:(id<ASICommRequestDelegate>)delegate
{
    successHandle = nil;
    successHandle = success;
    failHandle = nil;
    failHandle = fail;
    _delegate = nil;
    _delegate = delegate;
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

@end
