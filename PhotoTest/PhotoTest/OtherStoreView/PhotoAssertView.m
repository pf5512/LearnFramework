//
//  PhotoAssertView.m
//  PhotoTest
//
//  Created by chen on 14-11-14.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "PhotoAssertView.h"
#import "collectionCell.h"

#import "zichenPhoto.h"
#import "zichenPhotoBrowser.h"

@interface PhotoAssertView ()
{
    CGFloat _margin, _gutter;
    int selectedIndex; //选中的item
}
@property(nonatomic, assign)NSInteger ActionImageType;
@property(nonatomic, strong)NSString *docDirPath;
@property(nonatomic, strong)ALAssetsLibrary *AssetsLibrary;
@property(nonatomic, strong)NSMutableArray *PhotoUrlArray;
@property(nonatomic, strong)UIActionSheet *sheet;
@property(nonatomic, strong)NSFileManager *m_fileManager;
@property(nonatomic, strong)UIImagePickerController *imageControl;
@property(nonatomic, strong)NSMutableDictionary *imageDic;

@end

@implementation PhotoAssertView

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
    [self DataSourceCollectionView];
    [self.m_CollectionView reloadData];
}

#pragma mark ==摄像头初始化==
-(void)InitCameraController
{
    _imageControl = [[UIImagePickerController alloc] init];
    //imageControl.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    //_imageControl.showsCameraControls = YES;
    //imageControl.allowsEditing = YES;
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
        //保存到相册
                __block NSURL *resultURL=nil;
                __weak id weakself = self;
                [_AssetsLibrary writeImageToSavedPhotosAlbum:[ImageRetain CGImage]
                                          orientation:(ALAssetOrientation)[ImageRetain imageOrientation]
                                             completionBlock:^(NSURL *assetURL, NSError *error){
                                                 resultURL = assetURL;
                                                 NSString *resultStr = [resultURL absoluteString];
                                                 [weakself SaveImageAndShow: resultStr];
                }];
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        DLog(@"打开的是相册 %@", info);
        
        NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
        NSString *imagePath = [url absoluteString];
        [self SaveImageAndShow:imagePath];
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

#pragma mark ==显示image==
-(void)ShowImageView
{
    //获取目录下所有文件
        NSArray *fileList = [[NSArray alloc] init];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        fileList = [fileManager contentsOfDirectoryAtPath:_docDirPath error:&error];
    
        DLog(@"... count %d", [_imageDic count]);
        for (int i=0; i<[fileList count]; i++)
        {
            NSString *imagePath = [_docDirPath stringByAppendingPathComponent:[fileList objectAtIndex:i]];
            [_imageDic setObject:imagePath forKey:[fileList objectAtIndex:i]];
        }
        DLog(@"... count %d", [_imageDic count]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.m_CollectionView reloadData];
        });
}

#pragma mark ==打开相册==
-(void)openPhoto
{
    _imageControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //_imageControl.allowsEditing = YES;
    
    [self presentViewController:_imageControl animated:YES completion:^{}];
}

#pragma mark ==初始化相关信息==
-(void)initCollectionView
{
    //[self DataSourceCollectionView];
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
    DLog(@"count %d", [self DataSourceCollectionView]);
    return [self DataSourceCollectionView];
//    NSArray *arrayList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_docDirPath error:nil];
//    DLog(@"count %d", [arrayList count]);
//    return [arrayList count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"staticCell";
    collectionCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
    if (cell == nil)
    {
        //cell = [[collectionCell alloc] init];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    NSArray *arrayList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_docDirPath error:nil];
    NSString *stringPath = [arrayList objectAtIndex:indexPath.row];
    cell.m_selectbButton.tag = indexPath.row;
    cell.delegate = (id)self;
    if(self.ActionImageType == ActionImageBrowser)
        cell.m_selectbButton.hidden = YES;
    NSString *ImageTaken = [[SingleAssetOperation ShareInstance] GetUrlByPath:stringPath];
    cell.collImageView.image = nil;
    if (cell.collImageView.image == nil)
    {
        UIImage *image = [self getPhotoByUrl:ImageTaken];
        cell.collImageView.image = [[SingleAssetOperation ShareInstance] MakeImageView:image];
    }
    
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
        NSString *urlPath = [arrayList objectAtIndex:i];
        NSString *stringPath = [[SingleAssetOperation ShareInstance] GetUrlByPath:urlPath];
        UIImage *Image = [self getPhotoByUrl:stringPath];
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
        NSArray *arrayList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_docDirPath error:nil];
        NSString *urlPath = [arrayList objectAtIndex:selectedIndex];
        DLog(@"file %d", [arrayList count]);
        NSString *stringPath = [_docDirPath stringByAppendingPathComponent:urlPath];
        
        BOOL deleteFlag = NO;
        if ([self.m_fileManager fileExistsAtPath:stringPath])
        {
            deleteFlag = [[NSFileManager defaultManager] removeItemAtPath:stringPath error:nil];
        }
        NSArray *arrayList1 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_docDirPath error:nil];
        DLog(@"file %d",[arrayList1 count]);
        
        if (deleteFlag)
        {
            [self.m_CollectionView reloadData];
        }
    }
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

#pragma mark ==获取数据,保存数据==
-(void)SaveImageAndShow:(NSString *)resultURL
{
    DLog(@"URL %@",resultURL);
    __weak PhotoAssertView *weakself = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *fileName = [[SingleAssetOperation ShareInstance] getFileName:resultURL];
        NSString *filePath =  [_docDirPath stringByAppendingPathComponent:fileName];
        NSString *dateString = [m_formatter stringFromDate:[NSDate date]];
        NSData *data = [dateString dataUsingEncoding:NSASCIIStringEncoding];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            DLog(@"write to file %@",filePath);
            [data writeToFile:filePath atomically:YES];
        }
        __strong PhotoAssertView *strongself = weakself;
        [strongself ShowImageView];
    });
}

-(NSInteger)DataSourceCollectionView
{
    [_imageDic removeAllObjects];
    NSArray *arrayList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_docDirPath error:nil];
    for (int i=0; i<[arrayList count]; i++)
    {
        NSString *urlPath = [arrayList objectAtIndex:i];
        NSString *stringPath = [[SingleAssetOperation ShareInstance] GetUrlByPath:urlPath];
        UIImage *image = [self getPhotoByUrl:stringPath];
        if (image == nil)
        {
            DLog(@"can not find a image");
            //这里应该要删除对应的沙盒文件
            NSString *DeleteString = [_docDirPath stringByAppendingPathComponent:urlPath];
            if ([[NSFileManager defaultManager] fileExistsAtPath:DeleteString])
            {
                DLog(@"file delete");
                [[NSFileManager defaultManager] removeItemAtPath:DeleteString error:nil];
            }
            continue ;
        }
        
        [_imageDic setObject:stringPath forKey:[arrayList objectAtIndex:i]];
    }
    
    return [_imageDic count];
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

#pragma mark ==根据url 获取照片==
-(UIImage *)getPhotoByUrl:(NSString *)urlStr
{
    __block ALAsset *result = nil;
    __block NSError *assetError = nil;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSURL *url=[NSURL URLWithString:urlStr];
    __block BOOL ImageExist = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_AssetsLibrary assetForURL:url resultBlock:^(ALAsset *asset){
            if (asset)
            {
                result = asset;
                dispatch_semaphore_signal(sema);
            }
            else
            {
                DLog(@"can not find asset image");
                ImageExist = NO;
                dispatch_semaphore_signal(sema);
            }
        } failureBlock:^(NSError *error) {
            DLog(@"error ... %@", error);
            assetError = error;
            dispatch_semaphore_signal(sema);
        }];
    });
    
    if ([NSThread isMainThread])
    {
        while (!result && !assetError)
        {
            DLog(@"NSThread mainThread");
            if (ImageExist == NO)
            {
                DLog(@"image not exist, wait now, return nil");
                dispatch_semaphore_wait(sema, DISPATCH_TIME_NOW);
                //[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                return nil;
            }
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    else
    {
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    if (result.defaultRepresentation.url == nil || result.thumbnail == nil)
    {
        DLog(@"return image nil ");
        return nil;
    }
    
    //获取全屏相片：
    CGImageRef ref = [[result  defaultRepresentation] fullScreenImage];
    UIImage *image = [[UIImage alloc] initWithCGImage:ref];
    //    //获取缩略图：
    //    CGImageRef  ref = [result thumbnail];
    //    UIImage *image = [[UIImage alloc] initWithCGImage:ref];
    //    //获取高清相片：
    //    CGImageRef ref = [[result  defaultRepresentation] fullResolutionImage];
    //    UIImage *image = [[UIImage alloc] initWithCGImage:ref];
    
    //    DLog(@"... %f %f", image.size.height, image.size.width);
    return image;
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
