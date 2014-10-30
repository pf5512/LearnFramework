//
//  RootView.m
//  PhotoTest
//
//  Created by chen on 14-10-29.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#import "RootView.h"
#import "collectionCell.h"
#import "ShowImageView.h"

@interface RootView ()

@end

@implementation RootView
@synthesize imageControl;
@synthesize imageDic;
@synthesize docDirPath;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Photo";
    
    UIButton *cambutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [cambutton setTitle:@"拍照" forState:UIControlStateNormal];
    [cambutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cambutton addTarget:self action:@selector(UseCamera:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:cambutton];
    self.navigationItem.rightBarButtonItem = item;
    
    imageDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //初始化显示表
    [self initCollectionView];
    //初始化摄像头
    [self InitCameraController];
    
    m_formatter = [[NSDateFormatter alloc] init];
    [m_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark ==摄像头初始化==
-(void)InitCameraController
{
    imageControl = [[UIImagePickerController alloc] init];
    imageControl.sourceType = UIImagePickerControllerSourceTypeCamera;
    imageControl.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    //imageControl.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    imageControl.showsCameraControls = YES;
    //imageControl.allowsEditing = YES;
    imageControl.delegate = (id)self;
}

-(void)UseCamera:(id)sender
{
    [self presentViewController:imageControl animated:YES completion:^{}];
}

#pragma mark ==代理返回==
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [imageControl dismissViewControllerAnimated:YES completion:^{}];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    if ([mediaType isEqualToString:@"public.image"])
    {
        NSLog(@"%@",mediaType);
        //UIImage *ImageRetain = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *ImageRetain = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self saveImage:ImageRetain];
    }
    //显示image
    [self ShowImageView];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imageControl dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark ==裁剪之后保存相片==
-(void)saveImage:(UIImage *)image
{
    NSString *time1 = [m_formatter stringFromDate:[NSDate date]];
    NSString *imageStr = [NSString stringWithFormat:@"%@.png", time1];
    NSString *filePath =  [docDirPath stringByAppendingPathComponent:imageStr];
    
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

#pragma mark ==显示image==
-(void)ShowImageView
{
    //获取目录下所有文件
    NSArray *fileList = [[NSArray alloc] init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    fileList = [fileManager contentsOfDirectoryAtPath:docDirPath error:&error];
    
    for (int i=0; i<[fileList count]; i++)
    {
        NSString *imagePath = [docDirPath stringByAppendingPathComponent:[fileList objectAtIndex:i]];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [imageDic setObject:image forKey:[fileList objectAtIndex:i]];
    }
    
    /*
     *对显示图进行更新
     */
    [self.m_CollectionView performBatchUpdates:^{
        [self.m_CollectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[imageDic count]-1 inSection:0]]];
    }completion:nil];
}

#pragma mark ==裁剪小图,用来显示==
-(UIImage *)MakeImageView:(UIImage *)image;
{
    UIImage *newImage;
    CGSize newSize=CGSizeMake(60, 60);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark ==UICollectionView==
-(void)initCollectionView
{
    NSArray *arrayList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docDirPath error:nil];
    for (int i=0; i<[arrayList count]; i++)
    {
        NSString *imagePath = [docDirPath stringByAppendingPathComponent:[arrayList objectAtIndex:i]];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [imageDic setObject:image forKey:[arrayList objectAtIndex:i]];
    }

    [self.m_CollectionView registerClass:[collectionCell class] forCellWithReuseIdentifier:@"staticCell"];
    [self.m_CollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    self.m_CollectionView.dataSource = (id)self;
    self.m_CollectionView.delegate = (id)self;
    self.m_CollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.m_CollectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arrayList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docDirPath error:nil];
    return [arrayList count];
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
    NSArray *arrayList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docDirPath error:nil];
    NSString *stringPath = [arrayList objectAtIndex:indexPath.row];
    
    cell.collImageView.image = nil;
    if (cell.collImageView.image == nil)
    {
        cell.collImageView.image = [self MakeImageView:[imageDic objectForKey:stringPath]];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShowImageView *vc = [[ShowImageView alloc] init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arrayList = [fileManager contentsOfDirectoryAtPath:docDirPath error:nil];
    NSString *imagePath = [arrayList objectAtIndex:indexPath.row];
    vc.m_imagePath = imagePath;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
    return headView;
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(60, 60);
    return size;
}

// 定义section的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 10, 10, 10);
}

// 定义headview的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(320, 0);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
