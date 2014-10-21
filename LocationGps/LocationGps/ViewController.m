//
//  ViewController.m
//  LocationGps
//
//  Created by chen on 14-9-16.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*后台播放音乐文件*/
-(IBAction)buttonclick:(id)sender
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //以及设置app支持接受远程控制事件代码。设置app支持接受远程控制事件，
    //其实就是在dock中可以显示应用程序图标，同时点击该图片时，打开app。
    //或者锁屏时，双击home键，屏幕上方出现应用程序播放控制按钮。
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"43" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:mp3Path];
    
    //用下列代码播放音乐，测试后台播放
    // 创建播放器
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [url release];
    [player prepareToPlay];
    //[player setVolume:1];
    player.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    [player play]; //播放
}

-(void)dealloc
{
    //[super dealloc];
    //[_m_clickedButton release];
}

@end
