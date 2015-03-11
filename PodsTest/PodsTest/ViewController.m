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
#import "BlockPersonClass.h"
#import "VAStartClass.h"
#import <SVProgressHUD.h>
#import <TMCache.h>
#import<TMMemoryCache.h>
#import <netinet/in.h>
#include <netdb.h>

@interface ViewController ()<ASICommRequestDelegate>
{
    //JSONDecoder *m_decoder;
    NSMutableArray *m_array;
}

@property(nonatomic,weak)IBOutlet UIButton *EGObutton;
@property(nonatomic,weak)IBOutlet UILabel *EGOlbl;
@property (weak, nonatomic) IBOutlet UILabel *m_lazyText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"PodTest", nil);
    //test JSON
    [self jsonTest];
    //test EGOCache
    //[self EGOCacheTest];
    self.m_lazyText.frame = CGRectMake(0, self.view.bounds.size.height-30, self.view.bounds.size.width, 30);
    self.m_lazyText.textAlignment = NSTextAlignmentCenter;
    m_array = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EGO缓存 -
-(void)EGOCacheTest
{
    UIImage *iamge = [[EGOCache globalCache] imageForKey:@"http://112.95.146.91:10001/Content/uploads/images/141229130347649.jpg"];
    if (iamge == nil || [iamge isKindOfClass:[NSNull class]]) {
        UIImage *imageName = [UIImage imageNamed:@"btnBlueRound@2x.png"];
        [[EGOCache globalCache] setImage:imageName forKey:@"http://112.95.146.91:10001/Content/uploads/images/141229130347649.jpg"];
        //[[TMCache sharedCache] setObject:imageName forKey:@"string"];
    }
    else
    {
        NSLog(@"....");
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300, 320, 50)];
        imageview.image = iamge;
        [self.view addSubview:imageview];
    }
//    NSData *temp = [[EGOCache globalCache] dataForKey:@"cacheTest"];
//    NSString *tempStr = [[NSString alloc] initWithData:temp encoding:NSUTF8StringEncoding];
//    if (tempStr == nil || [tempStr isEqualToString:@""]) {
//        NSString *name = @"this is test egocache";
//        NSData *data = [name dataUsingEncoding:NSUTF8StringEncoding];
//        [[EGOCache globalCache] setData:data forKey:@"cacheTest"];
//    }
//    else
//    {
//        _EGOlbl.text = tempStr;
//    }
}

-(IBAction)egoclick:(id)sender
{
    [self EGOCacheTest];
}

#pragma mark --TMCache
-(IBAction)TMCacheButton:(id)sender
{
    //NSString *dic = @"i-am-a-student";
    //UIImage *imageName = [UIImage imageNamed:@"btnBlueRound@2x.png"];
    //[[TMCache sharedCache] setObject:dic forKey:@"string"];
    NSString *KEY = @"http://112.95.146.91:10001/Content/uploads/images/141229130347649.jpg";
    UIImage *iamge = [[TMMemoryCache sharedCache] objectForKey:KEY];
    if (iamge == nil || [iamge isKindOfClass:[NSNull class]]) {
        UIImage *imageName = [UIImage imageNamed:@"btnBlueRound@2x.png"];
        [[TMMemoryCache sharedCache] setObject:imageName forKey:KEY];
    }
    else
    {
        NSLog(@"....");
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300, 320, 50)];
        imageview.image = iamge;
        [self.view addSubview:imageview];
    }
    
    [TMDiskCache sharedCache].ageLimit = 10;
    UIImage *xxxx = (UIImage *)[[TMDiskCache sharedCache] objectForKey:KEY];
    if (xxxx == nil || [xxxx isKindOfClass:[NSNull class]]) {
        NSLog(@"缓存....");
        UIImage *imageName = [UIImage imageNamed:@"btnBlueRound@2x.png"];
        [[TMDiskCache sharedCache] setObject:imageName forKey:KEY];
    }
    else
    {
        NSLog(@"....xxxx");
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 50)];
        imageview.image = iamge;
        [self.view addSubview:imageview];
    }
    
//    [[TMCache sharedCache] objectForKey:@"string" block:^(TMCache *cache, NSString *key, id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *strGet = (NSString *)object;
//            [SVProgressHUD showInfoWithStatus:strGet];
//        });
//    }];
}

#pragma mark --ASI测试
-(IBAction)asibutton:(id)sender
{
    //天气查询接口
    //改变获取数据的url
    NSString *string = @"http://allseeing-i.com";
    //NSString *string = @"http://www.weather.com.cn/data/sk/101190408.html";
    [ASICommRequest GetWearthInfo:string Completion:^(NSDictionary *result){
        NSLog(@"result %@", result);
    } failHandle:^(NSError *error){
        NSLog(@"error %@", error);
    }];
    
//    [[ASICommRequest shareInstance] getWeartherInfo:string successSEL:@selector(asiHttpSuccess:) failSEL:@selector(asiHttpFail:) httpDelegate:(id)self];
}

-(void)asiHttpSuccess:(NSDictionary *)dicInfo
{
    NSLog(@"dic info %@", dicInfo);
}

-(void)asiHttpFail:(NSError *)error
{
    NSLog(@"error %@", error);
}

#pragma mark --block排序
-(IBAction)blockButton:(id)sender
{
    BlockPersonClass *person1 = [[BlockPersonClass alloc] init];
    person1.username = @"lix";
    person1.age = 18;
    BlockPersonClass *person2 = [[BlockPersonClass alloc] init];
    person2.username = @"xux";
    person2.age = 43;
    BlockPersonClass *person3 = [[BlockPersonClass alloc] init];
    person3.username = @"lyue";
    person3.age = 52;
    BlockPersonClass *person4 = [[BlockPersonClass alloc] init];
    person4.username = @"res";
    person4.age = 21;
    BlockPersonClass *person5 = [[BlockPersonClass alloc] init];
    person5.username = @"heelp";
    person5.age = 49;
    m_array = [NSMutableArray arrayWithObjects:person1,person2,person3,person4,person5,nil];
    
    NSLog(@"排序qian:");
    for (BlockPersonClass *per in m_array) {
        NSLog(@"name %@ age %d", per.username, per.age);
    }
    
    NSArray *sortedArray = [m_array sortedArrayUsingComparator:comptr];
    
    NSLog(@"排序后:");
    for (BlockPersonClass *per in sortedArray) {
        NSLog(@"name %@ age %d", per.username, per.age);
    }

}

NSComparator comptr = ^(BlockPersonClass *obj1, BlockPersonClass *obj2)
{
    if(obj1 != nil && obj2 != nil)
    {
        //年龄排序
        if(obj1.age > obj2.age)
            return NSOrderedDescending;
        else if(obj1.age < obj2.age)
            return NSOrderedAscending;
        else
            return NSOrderedSame;
        
        //名字排序
//        NSComparisonResult result = [obj1.username compare:obj2.username];
//        if(result == NSOrderedAscending)
//            return NSOrderedAscending;
//        else if(result == NSOrderedDescending)
//            return NSOrderedDescending;
    }
    return NSOrderedSame;
};


-(IBAction)GetAddressInfo:(id)sender
{
    CFHostRef host;
    CFArrayRef             addressArray;
    CFStringRef hostname = CFSTR("www.baidu.com");
    host = CFHostCreateWithName(kCFAllocatorDefault, hostname);
    
    CFStreamError error;
    BOOL success = CFHostStartInfoResolution(host, kCFHostAddresses, &error);
    if (success) {
        addressArray = CFHostGetAddressing(host, nil);
        NSLog(@"--- %@", addressArray);
        NSString *address = [self getAddressFromArray:addressArray];
        [SVProgressHUD showInfoWithStatus:address];
    }
    else{
        NSLog(@"%d", error.error);
    }
}

-(NSString*) getAddressFromArray:(CFArrayRef) addresses
{
    struct sockaddr  *addr;
    char             ipAddress[INET6_ADDRSTRLEN];
    CFIndex          index, count;
    int              err;
    assert(addresses != NULL);
    count = CFArrayGetCount(addresses);
    for (index = 0; index < count; index++)
    {
        addr = (struct sockaddr *)CFDataGetBytePtr(CFArrayGetValueAtIndex(addresses, index));
        assert(addr != NULL);
        /* getnameinfo coverts an IPv4 or IPv6 address into a text string. */
        err = getnameinfo(addr, addr->sa_len, ipAddress, INET6_ADDRSTRLEN, NULL, 0, NI_NUMERICHOST);
        if (err == 0) {
            NSLog(@"解析到ip地址：%s\n", ipAddress);
        } else {
            NSLog(@"地址格式转换错误：%d\n", err);
        }
    }

    return   [[NSString alloc] initWithFormat:@"%s", ipAddress];//这里只返回最后一个，一般认为只有一个地址
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


#pragma mark -storyboard
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = [segue destinationViewController];
    if ([vc respondsToSelector:@selector(setVAStartString:)]) {
        [vc setValue:@"testDemo" forKey:@"VAStartString"];
    }
    
    //需要回传的  需要加这个
    if ([vc respondsToSelector:@selector(setReturnViewController:)]) {
        [vc setValue:self forKey:@"ReturnViewController"];
    }
}

-(void)setReturnString:(NSString *)returnString
{
    _returnString = returnString;
    NSLog(@"return %@", _returnString);
//    [SVProgressHUD setBackgroundColor:[UIColor lightGrayColor]];
//    [SVProgressHUD showWithString:_returnString Duration:2];
}

@end
