//
//  collectionCell.h
//  PhotoTest
//
//  Created by chen on 14-10-29.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol collectCellDelegate <NSObject>

@optional
-(void)buttonSelect:(NSInteger)indexSelect;

@end


@interface collectionCell : UICollectionViewCell

@property(nonatomic, strong)id<collectCellDelegate> delegate;
@property(nonatomic, strong)UIImageView *collImageView;
@property(nonatomic, strong)UIButton *m_selectbButton;

-(void)setCellButtonSelected;

@end
