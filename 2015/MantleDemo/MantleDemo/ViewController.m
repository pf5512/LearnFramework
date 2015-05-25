//
//  ViewController.m
//  MantleDemo
//
//  Created by Mac on 15/5/23.
//  Copyright (c) 2015年 JuGuang. All rights reserved.
//

#import "ViewController.h"
#import "DemoModel.h"
#import "WeatherDemo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100.f, 100.f, 100.f, 50.f)];
    [btn setTitle:@"Demo" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClicked:(id)sender
{
     NSURL *url = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?lat=37.785834&lon=-122.406417&units=imperial"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError){
                               
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:NSJSONReadingMutableContainers
                                                                                      error:nil];
                               //NSLog(@"dict %@", dict);
                               DemoModel *model = [MTLJSONAdapter modelOfClass:[DemoModel class]
                                                            fromJSONDictionary:dict
                                                                         error:nil];
                               NSLog(@"model %@", model);
                               
                               NSDictionary *nsdict = [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
                               //NSLog(@"nsdict %@", nsdict);
                               
                               /*****/
                               NSArray *array = [dict objectForKey:@"weather"];
                               NSDictionary *weatherDict = [array objectAtIndex:0];
                               WeatherDemo *weartherDemo = [MTLJSONAdapter modelOfClass:[WeatherDemo class]
                                                                     fromJSONDictionary:weatherDict
                                                                                  error:nil];
                               //NSLog(@"weatherclass %@", weartherDemo);
                               
                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
