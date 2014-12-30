//
//  DemoCopyPaste.m
//  DemoAddChild
//
//  Created by chen on 14-12-30.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "DemoCopyPaste.h"
#import "DemoWindowLabel.h"


@interface DemoCopyPaste ()

@end

@implementation DemoCopyPaste

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    DemoWindowLabel *valabel = [[DemoWindowLabel alloc] initWithFrame:CGRectMake(30, 100, 100, 30)];
    valabel.text = @"copytext";
    valabel.textColor = [UIColor blueColor];
    [self.view addSubview:valabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
