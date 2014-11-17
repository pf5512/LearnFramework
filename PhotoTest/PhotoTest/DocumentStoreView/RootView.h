//
//  RootView.h
//  PhotoTest
//
//  Created by chen on 14-10-29.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+fixOrientation.h"
#import "CommDefine.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SingleAssetOperation.h"
#import "collectionCell.h"

@interface RootView : UIViewController<UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UIActionSheetDelegate,collectCellDelegate, UIAlertViewDelegate>
{
    NSDateFormatter *m_formatter;
}
@property(nonatomic, strong)IBOutlet UICollectionView *m_CollectionView;

//@property(nonatomic, strong)UIToolbar *toolbar;

@end
