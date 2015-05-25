//
//  CornerView.h
//  PodsTest
//
//  Created by chen on 15-3-12.
//  Copyright (c) 2015年 zichen0422. All rights reserved.
//

/*
 * uiview 设置圆角
 * 其他控件类似
 */
#import <UIKit/UIKit.h>

@interface CornerView : UIView

-(id)initWithFrame:(CGRect)frame withColor:(UIColor *)color;

/*
 UIRectCornerTopLeft     = 1 << 0,
 UIRectCornerTopRight    = 1 << 1,
 UIRectCornerBottomLeft  = 1 << 2,
 UIRectCornerBottomRight = 1 << 3,
 UIRectCornerAllCorners  = ~0UL
 */
//设置圆角 单个 多个组合
- (void)setCornerOnTopLeft:(CGSize)cornerRadii; //左上
- (void)setCornerOnTopRight:(CGSize)cornerRadii; //右上
- (void)setCornerOnBottomLeft:(CGSize)cornerRadii; //左下
- (void)setCornerOnBottomRight:(CGSize)cornerRadii; //右下
- (void)setCornerOnAllCorners:(CGSize)cornerRadii; //全部

- (void)setCornerOnTop:(CGSize)cornerRadii; //左上 右上
- (void)setCornerOnLeft:(CGSize)cornerRadii; //左上 左下
- (void)setCornerOnTopLeftBottomRight:(CGSize)cornerRadii; //左上 、右下
- (void)setCornerOnTopRightBottomLeft:(CGSize)cornerRadii; //右上, 左下
- (void)setCornerOnRight:(CGSize)cornerRadii; //右上 右下
- (void)setCornerOnBottom:(CGSize)cornerRadii; //左下 右下
@end
