//
//  RootView.m
//  PhotoTest
//
//  Created by chen on 14-10-29.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "RootView.h"
#import "collectionCell.h"

#import "zichenPhoto.h"
#import "zichenPhotoBrowser.h"

@interface RootView ()
{
    CGFloat _margin, _gutter;
    int selectedIndex; //选中的item
}
@property(nonatomic, assign)NSInteger ActionImageType;
@property(nonatomic, strong)UIImagePickerController *imageControl;
@property(nonatomic, strong)NSMutableDictionary *imageDic;
@property(nonatomic, strong)NSString *docDirPath;
@property(nonatomic, strong)ALAssetsLibrary *AssetsLibrary;
@property(nonatomic, strong)NSMutableArray *PhotoUrlArray;

@property(nonatomic, strong)UIActionSheet *sheet;
@property(nonatomic, strong)NSFileManager *m_fileManager;

@end

@implementation RootView

-(id)init
{
    self = [super init];
    if (self)
    {
        self.ActionImageType = ActionImageBrowser;
    }
    
    return self;
}

-(void)InitClassProperty
{
    selectedIndex = -1;
    _AssetsLibrary = [[ALAssetsLibrary alloc] init];
    _imageDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    _docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _PhotoUrlArray = [NSMutableArray new];
    
    m_formatter = [[NSDateFormatter alloc] init];
    [m_formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    self.m_fileManager = [NSFileManager defaultManager];
}

-(void)InitNavbar
{
    //选择
    UIButton *cambutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [cambutton setTitle:@"选取" forState:UIControlStateNormal];
    cambutton.tag = 1;
    [cambutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cambutton addTarget:self action:@selector(PhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:cambutton];
    self.navigationItem.rightBarButtonItem = item;
    
    //动作
    UIButton *photobutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [photobutton setTitle:@"动作" forState:UIControlStateNormal];
    photobutton.tag = 2;
    [photobutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [photobutton addTarget:self action:@selector(PhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *otheritem = [[UIBarButtonItem alloc] initWithCustomView:photobutton];
    self.navigationItem.leftBarButtonItem = otheritem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"PhotoDemo";
    //init navbar
    [self InitClassProperty];
    [self InitNavbar];
    //init class property
    [self InitClassProperty];
    //load Photo
    //[self loadAssertPhoto];
    //初始化显示表
    [self initCollectionView];
    //初始化摄像头
    [self InitCameraController];
    
    // Defaults
    _margin = 0, _gutter = 1;
    // For pixel perfection...
    if ([UIScreen mainScreen].bounds.size.height == 480)
    {   // iPhone 3.5 inch
        _margin = 0, _gutter = 1;
    }
    else
    {   // iPhone 4 inch
        _margin = 0, _gutter = 1;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark ==摄像头初始化==
-(void)InitCameraController
{
    _imageControl = [[UIImagePickerController alloc] init];
    _imageControl.delegate = (id)self;
}

-(void)UseCamera
{
    _imageControl.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imageControl.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    _imageControl.showsCameraControls = YES;
    [self presentViewController:_imageControl animated:YES completion:^{}];
}

#pragma mark ==代理返回==
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL storeFlag = NO;
    //NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //image size  3264.000000 2448.000000
        UIImage *ImageRetain = [info objectForKey:UIImagePickerControllerOriginalImage];
        //[self saveImage:ImageRetain];
        
        UIImage *newImage = [ImageRetain fixOrientation];
        NSData *imageData = UIImagePNGRepresentation(newImage);
        NSString *storeKeyPath = [[SingleAssetOperation ShareInstance] getDateKeyPath];
        storeFlag = [self storeImage:storeKeyPath :imageData];
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        DLog(@"打开的是相册 %@", info);
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *newImage = [image fixOrientation];
        NSString *storeKeyPath = [[SingleAssetOperation ShareInstance] getDateKeyPath];
        NSData *imageData = UIImagePNGRepresentation(newImage);
        storeFlag = [self storeImage:storeKeyPath :imageData];
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    //显示image
    if (storeFlag )
        [self ShowImageView];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark ==store image==
-(BOOL)storeImage:(NSString *)KeyPath :(NSData *)data
{
    BOOL storeBool = NO;
    if (![self.m_fileManager fileExistsAtPath:KeyPath])
    {
         storeBool = [data writeToFile:KeyPath atomically:YES];
        //[self.m_fileManager createDirectoryAtPath:KeyPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    //[self.m_fileManager createFileAtPath:KeyPath contents:data attributes:nil];
    
    return storeBool;
}

#pragma mark ==显示image==
-(void)ShowImageView
{
    NSError *error;
    NSArray *fileList = [self.m_fileManager contentsOfDirectoryAtPath:_docDirPath error:&error];
    
    DLog(@"fileList count %d", [fileList count]);
    /*
     *对显示图进行更新
     */
    [self.m_CollectionView performBatchUpdates:^{
        [self.m_CollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[fileList count]-1 inSection:0]]];
    } completion:^(BOOL finished){
        [self.m_CollectionView reloadData];
    }];
}

#pragma mark ==打开相册==
-(void)openPhoto
{
    _imageControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imageControl animated:YES completion:^{}];
}

#pragma mark ==初始化相关信息==
-(void)initCollectionView
{
    [self.m_CollectionView registerClass:[collectionCell class] forCellWithReuseIdentifier:@"staticCell"];
    self.m_CollectionView.dataSource = (id)self;
    self.m_CollectionView.delegate = (id)self;
    self.m_CollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.m_CollectionView];
}

#pragma mark ==UICollectionView==
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arrayList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_docDirPath error:nil];
    return [arrayList count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"staticCell";
    collectionCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[collectionCell alloc] init];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    NSArray *arrayList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_docDirPath error:nil];
    cell.m_selectbButton.tag = indexPath.row;
    cell.delegate = self;
    if(self.ActionImageType == ActionImageBrowser)
        cell.m_selectbButton.hidden = YES;
    NSString *stringPath = [arrayList objectAtIndex:indexPath.row];
    
    NSString *imageTaken = [_docDirPath stringByAppendingPathComponent:stringPath];
    NSData *data = [NSData dataWithContentsOfFile:imageTaken];
    UIImage *Image = [UIImage imageWithData:data];
    cell.collImageView.image = [[SingleAssetOperation ShareInstance] MakeImageView:Image];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ActionImageType == ActionImageBrowser)
    {
        [self ActionImageBrowser:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat value = floorf(((self.view.bounds.size.width - 3* _gutter - 2 * _margin) / 3));
    CGSize size = CGSizeMake(value, value);
    return size;
}

// 定义section的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

#pragma mark ==点击操作==
-(void)ActionImageBrowser:(NSIndexPath *)indexPath;
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
    zichenPhotoBrowser *browser = [[zichenPhotoBrowser alloc] init];
    NSArray *arrayList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_docDirPath error:nil];
    for (int i=0; i<[arrayList count]; i++)
    {
        NSString *stringPath = [arrayList objectAtIndex:i];
        NSString *imageTaken = [_docDirPath stringByAppendingPathComponent:stringPath];
        NSData *data = [NSData dataWithContentsOfFile:imageTaken];
        UIImage *Image = [UIImage imageWithData:data];
        
        if (Image)
        {
            zichenPhoto *photo = [[zichenPhoto alloc] init];
            photo.srcImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            CGSize size = CGSizeMake(320, 568);
            photo.srcImageView.image = [[SingleAssetOperation ShareInstance] MakeImageView:Image NewSize:size];
            photo.srcImageView.image = Image;
            [array addObject:photo];
        }
    }
    browser.photos = array;
    browser.currentPhotoIndex = indexPath.row;
    [self.navigationController pushViewController:browser animated:NO];
}

#pragma mark ==uiactionsheet==
-(void)PhotoAction:(id)sender
{
    if ([sender tag] == 1)
    {
        self.sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"打开相册", nil];
        self.sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        self.sheet.tag = 1;
        [self.sheet showInView:self.view];
    }
    else
    {
        self.sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"点击浏览" otherButtonTitles:@"点击删除", nil];
        self.sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        self.sheet.tag = 2;
        [self.sheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //动作选择
    if (actionSheet.tag == 1)
    {
        self.ActionImageType = ActionImageBrowser;
        if (buttonIndex == 0)
        {
            //拍照
            [self UseCamera];
        }
        if (buttonIndex == 1)
        {
            //相册
            [self openPhoto];
        }
    }
    
    //动作方式选择
    if (actionSheet.tag == 2)
    {
        if (buttonIndex == 0)
        {
            self.ActionImageType = ActionImageBrowser;
            [self allImageViewDelete:YES];
        }
        if (buttonIndex == 1)
        {
            self.ActionImageType = ActionImageDelete;
            [self allImageViewDelete:NO];
        }
    }
}

#pragma mark ==删除==
-(void)allImageViewDelete:(BOOL)hidden
{
    NSArray *array = [self.m_CollectionView visibleCells];
    for (collectionCell *cell in array)
    {
        cell.m_selectbButton.hidden = hidden;
    }
}

-(void)buttonSelect:(NSInteger)indexSelect
{
    selectedIndex = indexSelect;
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"你要删除这张照片吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [view show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        BOOL deleteFlag = NO;
        NSArray *arrayList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_docDirPath error:nil];
        NSString *stringPath = [arrayList objectAtIndex:selectedIndex];
        NSString *filePath = [_docDirPath stringByAppendingPathComponent:stringPath];
        if ([self.m_fileManager fileExistsAtPath:filePath])
        {
            deleteFlag = [self.m_fileManager removeItemAtPath:filePath error:nil];
        }
        if (deleteFlag)
        {
            [self.m_CollectionView performBatchUpdates:^{
                [self.m_CollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0]]];
            } completion:^(BOOL finished){
                [self.m_CollectionView reloadData];
            }];
        }
    }
}

#pragma mark ==裁剪之后保存相片==
-(void)saveImage:(UIImage *)image
{
    NSString *time1 = [m_formatter stringFromDate:[NSDate date]];
    NSString *imageStr = [NSString stringWithFormat:@"%@.png", time1];
    NSString *filePath =  [_docDirPath stringByAppendingPathComponent:imageStr];
    
    /*
     *开源类别,对图片进行旋转保存图片
     */
    UIImage *newImage = [image fixOrientation];
    
    /*
     *这里对图片进行裁剪了,没裁剪的话, 会直接把2448*3264的原始图片加载进内存,内存会增加40M+
     *但是对图片进行效果是失真,变模糊, notice by zichen0422
     */
    CGSize newSize = CGSizeMake(320, 568);
    UIGraphicsBeginImageContext(newSize);
    [newImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *xxImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    newImage = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        //NSLog(@"%@", filePath);
        NSData *data = UIImagePNGRepresentation(xxImage);
        [data writeToFile:filePath atomically:YES];
    }
}

#pragma mark ==读取系统相册==
-(void)loadAssertPhoto
{
    __block NSMutableArray *array = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
        NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
        
        // Process assets
        void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result != nil) {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                    NSURL *url = result.defaultRepresentation.url;
                    [_AssetsLibrary assetForURL:url
                                    resultBlock:^(ALAsset *asset) {
                                        if (asset) {
                                            @synchronized(array) {
                                                [array addObject:asset];
                                            }
                                        }
                                    }
                                   failureBlock:^(NSError *error){
                                       DLog(@"operation was not successfull!");
                                   }];
                    
                }
            }
        };
        
        // Process groups
        void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group != nil) {
                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                [assetGroups addObject:group];
            }
            
            if (group == nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DLog(@"get photo");
                    _PhotoUrlArray = [array copy];
                });
            }
        };
        
        // Process!
        [_AssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:assetGroupEnumerator
                                    failureBlock:^(NSError *error) {
                                        DLog(@"There is an error");
                                    }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
