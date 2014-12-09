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

@interface ViewController ()<UITextFieldDelegate>

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
    NSLog(@"name %@, pass %@", name, pass);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)loginButton:(id)sender
{
    NSLog(@"%@ %@", _nameLBL.text, _passlbl.text);
    //save to keychain
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:_nameLBL.text forKey:KEYCHAIN_NAME];
    [usernamepasswordKVPairs setObject:_passlbl.text forKey:KEYCHAIN_PASS];
    [keychainObject saveKey:KEYCHAIN :(NSData *)usernamepasswordKVPairs];
}

-(IBAction)logoutButton:(id)sender
{
    NSLog(@"%@ %@", _nameLBL.text, _passlbl.text);
    _nameLBL.text = @"";
    _passlbl.text = @"";
    [keychainObject deleteKey:KEYCHAIN];
}

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
