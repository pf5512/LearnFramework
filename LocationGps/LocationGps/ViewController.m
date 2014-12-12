//
//  ViewController.m
//  LocationGps
//
//  Created by chen on 14-9-16.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "OpenUDID.h"
#import <MediaPlayer/MediaPlayer.h>


@interface ViewController ()
{
    UISlider *slider;
}

@property (retain, nonatomic) IBOutlet MPVolumeView *voiceView;
@property (nonatomic, assign)CGPoint firstPoint;
@property (nonatomic, assign)CGPoint secondPoint;

@property (nonatomic, retain)AVAudioPlayer *audioPlayer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"locationGps";
    
    slider = [[UISlider alloc] init];
    slider.backgroundColor = [UIColor blueColor];
    for (UIControl *views in _voiceView.subviews) {
        DLog(@"class %@", [views class]);
        
        if ([views.superclass isSubclassOfClass:[UISlider class]]) {
            DLog(@"uislider class");
            slider = (UISlider *)views;
        }
    }
    
    slider.autoresizesSubviews = NO;
    slider.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:slider];
    slider.hidden = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        _firstPoint = [touch locationInView:self.view];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        _secondPoint = [touch locationInView:self.view];
    }
    
    DLog(@"__first %f %f", _firstPoint.x, _firstPoint.y);
    DLog(@"__secode %f %f", _secondPoint.x, _secondPoint.y);
    
    //屏幕左右滑动 左－>大  右->小
    
    if (fabs(_secondPoint.x - _firstPoint.x) > 5) {
        _audioPlayer.currentTime += (_secondPoint.x - _firstPoint.x)/30.0;
    }
    //slider.value += (_secondPoint.x - _firstPoint.x)/320.0;
    
    //屏幕的上下滑动  上-> 大 下->小
    if (fabs(_firstPoint.y - _secondPoint.y) > 5) {
        slider.value += ( _firstPoint.y - _secondPoint.y)/500.0;
    }
    
    _firstPoint = _secondPoint;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _firstPoint = _secondPoint = CGPointZero;
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
    
    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"shijianzhuyu" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:mp3Path];
    
    //用下列代码播放音乐，测试后台播放
    // 创建播放器
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [url release];
    [_audioPlayer prepareToPlay];
    //[player setVolume:1];
    _audioPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    [_audioPlayer play]; //播放
}

-(void)dealloc
{
    [_voiceView release];
    [_voiceView release];
    [super dealloc];
}

-(IBAction)OpenUDID:(id)sender
{
    NSString *UDIDstr = [OpenUDID value];
    DLog(@"UDID %@", UDIDstr);
}

@end
