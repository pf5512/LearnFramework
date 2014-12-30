//
//  DemoWindowLabel.m
//  DemoWindowLevel
//
//  Created by chen on 14-12-30.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "DemoWindowLabel.h"

@implementation DemoWindowLabel

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self TapHandler];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self TapHandler];
    }
    return self;
}

//设置点击方法
-(void)TapHandler
{
    self.userInteractionEnabled = YES; //用户交互
    
    //双击
    UITapGestureRecognizer *reco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    reco.numberOfTapsRequired = 2;
    [self addGestureRecognizer:reco];

    //长按
    UILongPressGestureRecognizer *reco1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapHandler:)];
    reco1.minimumPressDuration = 1.0;
    [self addGestureRecognizer:reco1];
}

-(void)handleTap:(UITapGestureRecognizer *)Recognizer
{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

-(void)longTapHandler:(UILongPressGestureRecognizer *)recognizer
{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(LongCopy:)];
    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"粘贴" action:@selector(LongPaste:)];
    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"剪切" action:@selector(LongDeny:)];
    
    [menu setMenuItems:[NSArray arrayWithObjects:item,item1,item2,nil]];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

-(void)LongCopy:(id)sender
{
    UIPasteboard *pasted = [UIPasteboard generalPasteboard];
    pasted.string = self.text;
}

-(void)LongPaste:(id)sender
{
    NSLog(@"粘贴");
//    self.text = @"haha";
//    [self setNeedsDisplay];
}

-(void)LongDeny:(id)sender
{
    NSLog(@"剪切");
}

//重写响应
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

//查看响应方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:)||action == @selector(LongPaste:)||action == @selector(LongCopy:)||action ==@selector(LongDeny:));
}

//复制
-(void)copy:(id)sender
{
    UIPasteboard *pasted = [UIPasteboard generalPasteboard];
    pasted.string = self.text;
}

@end
