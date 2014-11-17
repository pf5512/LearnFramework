//
//  PhotoAssertView.h
//  PhotoTest
//
//  Created by chen on 14-11-14.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+fixOrientation.h"
#import "CommDefine.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SingleAssetOperation.h"

@interface PhotoAssertView : UIViewController<UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    NSDateFormatter *m_formatter;
}

@property(nonatomic, strong)IBOutlet UICollectionView *m_CollectionView;


@end
