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

@interface PhotoAssertView : UIViewController<UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UIActionSheetDelegate>
{
    NSDateFormatter *m_formatter;
}
@property(nonatomic, strong)UIImagePickerController *imageControl;
@property(nonatomic, strong)NSMutableDictionary *imageDic;
@property(nonatomic, strong)IBOutlet UICollectionView *m_CollectionView;
@property(nonatomic, strong)NSString *docDirPath;
@property(nonatomic, strong)ALAssetsLibrary *AssetsLibrary;
@property(nonatomic, strong)NSMutableArray *PhotoUrlArray;

@property(nonatomic, strong)UIActionSheet *sheet;
@property(nonatomic, strong)NSFileManager *m_fileManager;

@end
