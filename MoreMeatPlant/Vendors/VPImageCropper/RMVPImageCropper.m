//
//  RMVPImageCropper.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/31.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMVPImageCropper.h"
#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#define IOS7 [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7

#define IOS8 [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8

//#define kPhotoName              @"content_license.png"
#define kImageCachePath         @"imagecache"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface RMVPImageCropper ()
@property (retain, nonatomic) NSString * filePath;
@end

static RMVPImageCropper * _imageCropper = nil;

@implementation RMVPImageCropper
+ (id)shareImageCropper{
    if(_imageCropper == nil){
        _imageCropper = [[RMVPImageCropper alloc]init];
    }
    return _imageCropper;
}

- (void)showActionSheet{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"获取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册获取", nil];
    [sheet showInView:[(UIViewController *)self.ctl view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        
        //拍照
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            [self openCamera];
        }else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的设备没有摄像头，无法通过拍照获取图片!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            [alert show];
        }

    }else if (buttonIndex == 1){
        //打开相册
        [self openPics];
        
    }else{
        //取消
    }
}

// 打开相机
- (void)openCamera {
    // UIImagePickerControllerCameraDeviceRear 后置摄像头
    // UIImagePickerControllerCameraDeviceFront 前置摄像头
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        NSLog(@"没有摄像头");
        [MBProgressHUD showError:@"抱歉,您的设备不具备摄像功能!" toView:[(UIViewController *)self.ctl view]];
        return ;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    // 编辑模式
    imagePicker.allowsEditing = YES;
    
    [(UIViewController *)self.ctl  presentViewController:imagePicker animated:YES completion:^{
    }];
}

// 打开相册
- (void)openPics {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [(UIViewController *)self.ctl  presentViewController:imagePicker animated:YES completion:^{
    }];
}


// 选中照片

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (IOS7) { // 判断是否是IOS7
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
    }
    [picker dismissViewControllerAnimated:YES completion:^() {
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@", info);
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, [(UIViewController *)self.ctl view].frame.size.width, [(UIViewController *)self.ctl view].frame.size.width*self._scale) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [(UIViewController *)self.ctl presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
            
//            if(self.selfimage == nil)
//            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择图片！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
//                [alert show];
//                return;
//            }
        }];
    }];
    
    
}


#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 保存图片至沙盒

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *path = [[FileUtil getCachePathFor:kImageCachePath] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:path atomically:NO];
    _filePath = path;
    NSLog(@"%@",path);
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    self.selfimage = editedImage;
    [self saveImage:editedImage withName:_fileName];
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        if (IOS7) { // 判断是否是IOS7
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
            
        }
        
        if([self.ctl respondsToSelector:@selector(RMimageCropper: didFinished: andfilePath:)]){
            [self.ctl RMimageCropper:cropperViewController didFinished:self.selfimage andfilePath:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",_filePath]]];
        }
        
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        if (IOS7) { // 判断是否是IOS7
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
            
        }
        if([self.ctl respondsToSelector:@selector(RMimageCropperDidCancel:)]){
            [self.ctl RMimageCropperDidCancel:cropperViewController];
        }
        
    }];
}


@end
