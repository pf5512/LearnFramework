//
//  ViewController.m
//  keychainDemo
//
//  Created by chen on 14-12-9.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import "keychainObject.h"
#import "MenuVC.h"

@interface ViewController ()<UITextFieldDelegate>
{
    NSDictionary *dic;
}
@property (weak, nonatomic) IBOutlet UILabel *backInfoLbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _passlbl.secureTextEntry = YES;
    
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[keychainObject loadKey:KEYCHAIN];
    NSString *name = [usernamepasswordKVPairs objectForKey:KEYCHAIN_NAME];
    NSString *pass = [usernamepasswordKVPairs objectForKey:KEYCHAIN_PASS];
    _nameLBL.text = name;
    _passlbl.text = pass;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _backInfoLbl.text = _backInfo;
}

-(void)setBackInfo:(NSString *)backInfo
{
    _backInfo = backInfo;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = [segue destinationViewController];
    if ([vc respondsToSelector:@selector(setDicInfo:)]) {
        [vc setValue:dic forKey:@"DicInfo"];
    }
    
    if ([vc respondsToSelector:@selector(setReturnViewController:)]) {
        [vc setValue:self forKey:@"ReturnViewController"];
    }
}

#pragma mark ==login/out==
-(IBAction)loginButton:(id)sender
{
    //save to keychain
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:_nameLBL.text forKey:KEYCHAIN_NAME];
    [usernamepasswordKVPairs setObject:_passlbl.text forKey:KEYCHAIN_PASS];
    [keychainObject saveKey:KEYCHAIN :(NSData *)usernamepasswordKVPairs];
    dic = [[NSDictionary alloc] initWithDictionary:usernamepasswordKVPairs];
}

-(IBAction)logoutButton:(id)sender
{
    _nameLBL.text = @"";
    _passlbl.text = @"";
    [keychainObject deleteKey:KEYCHAIN];
}

#pragma mark ==textfield==
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _nameLBL) {
        [_nameLBL resignFirstResponder];
    }
    if (textField == _passlbl) {
        [_passlbl resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nameLBL) {
        [_nameLBL resignFirstResponder];
        _nameLBL.text = textField.text;
    }
    if (textField == _passlbl) {
        [_passlbl resignFirstResponder];
        _passlbl.text = textField.text;
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nameLBL resignFirstResponder];
    [_passlbl resignFirstResponder];
}

@end
