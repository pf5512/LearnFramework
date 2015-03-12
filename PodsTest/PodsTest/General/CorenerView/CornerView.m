//
//  CornerView.m
//  PodsTest
//
//  Created by chen on 15-3-12.
//  Copyright (c) 2015年 zichen0422. All rights reserved.
//

#import "CornerView.h"

@implementation CornerView

-(id)initWithFrame:(CGRect)frame withColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = color;
    }
    return self;
}

-(void)setCornerOnTopLeft:(CGSize)cornerRadii
{
    UIBezierPath *maskpath;
    maskpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:cornerRadii];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = maskpath.CGPath;
    self.layer.mask = masklayer;
}

-(void)setCornerOnTopRight:(CGSize)cornerRadii
{
    UIBezierPath *maskpath;
    maskpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:cornerRadii];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = maskpath.CGPath;
    self.layer.mask = masklayer;
}

-(void)setCornerOnBottomLeft:(CGSize)cornerRadii
{
    UIBezierPath *maskpath;
    maskpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:cornerRadii];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = maskpath.CGPath;
    self.layer.mask = masklayer;
}

-(void)setCornerOnBottomRight:(CGSize)cornerRadii
{
    UIBezierPath *maskpath;
    maskpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:cornerRadii];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = maskpath.CGPath;
    self.layer.mask = masklayer;
}

-(void)setCornerOnAllCorners:(CGSize)cornerRadii
{
    UIBezierPath *maskpath;
    maskpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:cornerRadii];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = maskpath.CGPath;
    self.layer.mask = masklayer;
}

- (void)setCornerOnTop:(CGSize)cornerRadii
{
    UIBezierPath *maskpath;
    maskpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:cornerRadii];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = maskpath.CGPath;
    self.layer.mask = masklayer;
}

-(void)setCornerOnLeft:(CGSize)cornerRadii
{
    UIBezierPath *maskpath;
    maskpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft) cornerRadii:cornerRadii];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = maskpath.CGPath;
    self.layer.mask = masklayer;
}

-(void)setCornerOnTopLeftBottomRight:(CGSize)cornerRadii
{
    UIBezierPath *maskpath;
    maskpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomRight) cornerRadii:cornerRadii];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = maskpath.CGPath;
    self.layer.mask = masklayer;
}

-(void)setCornerOnTopRightBottomLeft:(CGSize)cornerRadii
{
    UIBezierPath *maskpath;
    maskpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomLeft) cornerRadii:cornerRadii];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = maskpath.CGPath;
    self.layer.mask = masklayer;
}

-(void)setCornerOnRight:(CGSize)cornerRadii
{
    UIBezierPath *maskpath;
    maskpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight) cornerRadii:cornerRadii];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = maskpath.CGPath;
    self.layer.mask = masklayer;
}

-(void)setCornerOnBottom:(CGSize)cornerRadii
{
    UIBezierPath *maskpath;
    maskpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:cornerRadii];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = maskpath.CGPath;
    self.layer.mask = masklayer;
}

@end
