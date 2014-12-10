//
//  MenuVC.m
//  keychainDemo
//
//  Created by chen on 14-12-9.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "MenuVC.h"
#import "keychainObject.h"

@interface MenuVC ()

@property(nonatomic, weak)IBOutlet UILabel *TraNameLbl;
@property(nonatomic, weak)IBOutlet UILabel *TraPassLbl;

@end

@implementation MenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *name = [_dicInfo objectForKey:KEYCHAIN_NAME];
    NSString *pass = [_dicInfo objectForKey:KEYCHAIN_PASS];
    
    _TraNameLbl.text = name;
    _TraPassLbl.text = pass;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([_returnViewController respondsToSelector:@selector(setBackInfo:)]) {
        [_returnViewController setValue:@"MenuReturnInfo" forKey:@"BackInfo"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDicInfo:(NSDictionary *)dicInfo
{
    _dicInfo = dicInfo;
}


#pragma mark -back
-(IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
