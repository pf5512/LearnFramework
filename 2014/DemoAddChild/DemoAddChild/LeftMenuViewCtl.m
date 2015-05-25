//
//  LeftMenuViewCtl.m
//  DemoAddChild
//
//  Created by chen on 14-12-18.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "LeftMenuViewCtl.h"

@interface LeftMenuViewCtl ()

@end

@implementation LeftMenuViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self setDefaultButton];
}

-(void)setDefaultButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 120, 50)];
    [btn setTitle:@"点击返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(IBAction)leftButtonCLick:(id)sender
{
    //NSLog(@"left click...");
    [_delegate didMoveToCenter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
