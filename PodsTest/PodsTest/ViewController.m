//
//  ViewController.m
//  PodsTest
//
//  Created by chen on 14-11-18.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "ViewController.h"
#import <JSONKit.h>
#import "EGOCache.h"
#import <Foundation/Foundation.h>
#import <ASIHTTPRequest.h>
#import "ASICommRequest.h"

@interface ViewController ()
{
    //JSONDecoder *m_decoder;
}

@property(nonatomic,weak)IBOutlet UIButton *EGObutton;
@property(nonatomic,weak)IBOutlet UILabel *EGOlbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"PodsTest";
    //test JSON
    [self jsonTest];
    //test EGOCache
    //[self EGOCacheTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - egocache -
-(void)EGOCacheTest
{
    NSData *temp = [[EGOCache globalCache] dataForKey:@"cacheTest"];
    NSString *tempStr = [[NSString alloc] initWithData:temp encoding:NSUTF8StringEncoding];
    if (tempStr == nil || [tempStr isEqualToString:@""]) {
        NSString *name = @"this is test egocache";
        NSData *data = [name dataUsingEncoding:NSUTF8StringEncoding];
        [[EGOCache globalCache] setData:data forKey:@"cacheTest"];
    }
    else
    {
        _EGOlbl.text = tempStr;
    }
}

-(IBAction)egoclick:(id)sender
{
    [self EGOCacheTest];
}

#pragma mark --Asihttp
-(IBAction)asibutton:(id)sender
{
    //天气查询接口
    NSString *string = @"http://www.weather.com.cn/data/sk/101190408.html";
    //NSString *string = @"http://www.xxxxxcocmc.cm";
//    [ASICommRequest GetWearthInfo:string Completion:^(id result, NSError *error){
//        if (error) {
//            NSLog(@"error %@", error);
//        }
//        NSLog(@"result %@", result);
//    }];
    
    [ASICommRequest GetWearthInfo:string Completion:^(NSDictionary *result){
        NSLog(@"result %@", result);
    } failHandle:^(NSError *error){
        NSLog(@"error %@", error);
    }];
}

#pragma mark - json -
-(void)jsonTest
{
    NSString *res = nil;
    /*
     * json格式编码
     */
    //字符串
    NSString *str = @"this is a nsstring";
    res = [str JSONString];
    NSLog(@"res= %@", [NSString stringWithString: res]);
    //res= "this is a nsstring"
    
    //数组
    NSArray *arr = [[NSArray alloc] initWithObjects:@"One",@"Two",@"Three",nil];
    res = [arr JSONString];
    NSLog(@"res= %@", [NSString stringWithString: res]);
    //res= ["One","Two","Three"]
    
    //字典类型（对象）
    NSArray *arr1 = [NSArray arrayWithObjects:@"dog",@"cat",nil];
    NSArray *arr2 = [NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:30],nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:arr1,@"pets",arr2,@"other",nil];
    res = [dic JSONString];
    NSLog(@"res= %@", [NSString stringWithString: res]);
    //res= {"pets":["dog","cat"],"other":[true,30]}
    /*
     * json格式解码
     */
    JSONDecoder *jd=[[JSONDecoder alloc] init];
    
    //针对NSData数据
    NSData *data = [dic JSONData];
    /*jsonkit 解析*/
    NSDictionary *ret = [jd objectWithData: data];
    NSLog(@"res= %@", [ret objectForKey:@"pets"]);
    NSLog(@"res= %@", [[ret objectForKey:@"other"] objectAtIndex:0]);
    //res= 1
    /*NSJSONSerialization 自带库解析*/
    NSDictionary *retDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"retDic %@", retDic);
    NSLog(@"retDic %@", [ret objectForKey:@"pets"]);
    
    //针对NSString字符串数据
    NSString *nstr = [dic JSONString];
    NSDictionary *ret2 = [jd objectWithUTF8String:(const unsigned char *)[nstr UTF8String] length:(unsigned int)[nstr length]];
   // NSLog(@"res= %lu", [[ret2 objectForKey:@"pets"] indexOfObject:@"cat"]);
    //res= 1
    NSLog(@"res= %@", [[ret2 objectForKey:@"other"] objectAtIndex:1]);
    //res= 30
}

@end
