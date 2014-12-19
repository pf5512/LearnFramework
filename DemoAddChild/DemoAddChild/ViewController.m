//
//  ViewController.m
//  DemoAddChild
//
//  Created by chen on 14-12-18.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "ViewController.h"
#import "CenterViewCtl.h"
#import "LeftMenuViewCtl.h"

#define VIEWWIDTH 100

@interface ViewController ()<centerviewDelegate>

@property (nonatomic, strong)CenterViewCtl *centerview;
@property (nonatomic, strong)LeftMenuViewCtl *leftView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setDefaultView];
}

#pragma mark -setview
-(void)setDefaultView
{
    _centerview = [[CenterViewCtl alloc] init];
    _centerview.delegate = (id)self;
    _centerview.ChangeViewButton.tag = 1;
    [self.view addSubview:_centerview.view];
    [self addChildViewController:_centerview];
    [_centerview didMoveToParentViewController:self];
}


-(UIView *)getLeftView
{
    if (_leftView == nil) {
        _leftView = [[LeftMenuViewCtl alloc] init];
        _leftView.delegate = (id)_centerview;
        [self.view addSubview:_leftView.view];
        [self addChildViewController:_leftView];
        [_leftView didMoveToParentViewController:self];
        
        _leftView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    UIView *view = _leftView.view;
    [self showSHAW:YES offsetVaule:-2];
    return view;
}


#pragma mark -delegate
-(void)didMoveLeft
{
    NSLog(@"move left");
    UIView *childView =[self getLeftView];
    [self.view sendSubviewToBack:childView];

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGRect rect = CGRectMake(self.view.frame.size.width-VIEWWIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                         _centerview.view.frame = CGRectInset(rect, 0, 50);
                         //_centerview.view.frame = CGRectMake(self.view.frame.size.width-VIEWWIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                    } completion:^(BOOL finished){
                        if (finished) {
                            _centerview.ChangeViewButton.tag = 0;
                        }
    }];
}

-(void)DidMoveCenterViewController
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         _centerview.view.frame = CGRectInset(rect, 0, 0);
                         
                         //_centerview.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self BackMainViewController];
                     }];
}


-(void)BackMainViewController
{
    if (_leftView != nil) {
        [_leftView.view removeFromSuperview];
        _leftView = nil;
        _centerview.ChangeViewButton.tag = 1;
    }
    [self showSHAW:NO offsetVaule:0];
}

//增加阴影
-(void)showSHAW:(BOOL)value  offsetVaule:(double)offset
{
    if (value) {
        [_centerview.view.layer setCornerRadius:3];
        [_centerview.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_centerview.view.layer setShadowOpacity:0.6];
        [_centerview.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
    else
    {
        [_centerview.view.layer setCornerRadius:0];
        [_centerview.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
