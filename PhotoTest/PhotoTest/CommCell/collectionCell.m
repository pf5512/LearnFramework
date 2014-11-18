//
//  collectionCell.m
//  PhotoTest
//
//  Created by chen on 14-10-29.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "collectionCell.h"

@implementation collectionCell
@synthesize collImageView;

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        collImageView = [UIImageView new];
        collImageView.frame = self.bounds;
        collImageView.contentMode = UIViewContentModeScaleAspectFill;
        collImageView.clipsToBounds = YES;
        collImageView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:collImageView];
        
        self.m_selectbButton = [UIButton new];
        self.m_selectbButton.frame = CGRectMake(61, 0, 44, 44);
        [self.m_selectbButton setBackgroundImage:[UIImage imageNamed:@"ImageSelectedOff"] forState:UIControlStateNormal];
        [self.m_selectbButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.m_selectbButton];
    }
    
    return self;
}

-(void)buttonClick:(id)sender
{
    if (!self.m_selectbButton.selected)
    {
        self.m_selectbButton.selected = YES;
        [self.m_selectbButton setBackgroundImage:[UIImage imageNamed:@"ImageSelectedOn"] forState:UIControlStateNormal];
        [_delegate buttonSelect:self.m_selectbButton.tag];
    }
    else
    {
        self.m_selectbButton.selected = NO;
        [self.m_selectbButton setBackgroundImage:[UIImage imageNamed:@"ImageSelectedOff"] forState:UIControlStateNormal];
    }
}

//手动设置无选中状态
-(void)setCellButtonSelected
{
    self.m_selectbButton.selected = NO;
    [self.m_selectbButton setBackgroundImage:[UIImage imageNamed:@"ImageSelectedOff"] forState:UIControlStateNormal];
}

@end
