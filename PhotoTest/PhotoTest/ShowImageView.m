//
//  ShowImageView.m
//  PhotoTest
//
//  Created by chen on 14-10-29.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "ShowImageView.h"

@interface ShowImageView ()

@end

@implementation ShowImageView
@synthesize m_imagePath;
@synthesize m_imageView;
@synthesize m_scrollview;

/**
 *  @brief  原始图片大小为2448*3264, 最大放大2倍,最小保持原比例,setMaximumZoomScale,放大比例
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"ZoomImage";
    
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagePath = [docDirPath stringByAppendingPathComponent:m_imagePath];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    /*初始化imageview*/
    m_imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    m_imageView.image = [self MakeImageView:image];
    
    m_scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
    [m_scrollview setContentSize:m_imageView.frame.size];
    [m_scrollview setShowsHorizontalScrollIndicator:NO];
    [m_scrollview setShowsVerticalScrollIndicator:NO];
    [m_scrollview setMaximumZoomScale:2.0];
    [m_scrollview setBackgroundColor:[UIColor lightGrayColor]];
    [m_scrollview setDelegate:(id)self];
    [m_scrollview setMinimumZoomScale:1.0];
    [m_scrollview setZoomScale:[m_scrollview minimumZoomScale]];
    [m_scrollview addSubview:m_imageView];
    [[self view] addSubview:m_scrollview];
    
    // 手势隐藏上下导航栏
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doneButtonPressed:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGesture];
}

#pragma mark ==代理==
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return m_imageView;
}

#pragma mark ==裁剪图片==
-(UIImage *)MakeImageView:(UIImage *)image;
{
    UIImage *newImage;
    CGSize newSize=CGSizeMake(320,self.view.bounds.size.height-64);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
