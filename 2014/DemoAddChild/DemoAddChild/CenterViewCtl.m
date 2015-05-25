//
//  CenterViewCtl.m
//  DemoAddChild
//
//  Created by chen on 14-12-18.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "CenterViewCtl.h"

@interface CenterViewCtl ()

@end

@implementation CenterViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationItems];
    self.title = @"center";
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)setNavigationItems
{
    [_ChangeViewButton setTitle:@"开始/返回" forState:UIControlStateNormal];
    [_ChangeViewButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [_ChangeViewButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ChangeViewButton];
}

-(IBAction)leftButtonClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            [_delegate DidMoveCenterViewController];
            break;
        }
        case 1:
        {
            [_delegate didMoveLeft];
            break;
        }
        default:
            break;
    }
}

#pragma mark --delegate
-(void)didMoveToCenter
{
    [_delegate DidMoveCenterViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _ChangeViewButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 100, 120, 44)];
    }
    return self;
}

@end
