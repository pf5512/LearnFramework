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
//    self.backgroundColor = [UIColor clearColor];
//    collImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
//    [self addSubview:collImageView];
//    self.collImageView.backgroundColor = [UIColor redColor];
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
    }
    
    return self;
}

@end
