//
//  ASICommRequest.m
//  PodsTest
//
//  Created by chen on 14-12-17.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "ASICommRequest.h"

@implementation ASICommRequest

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

@end
