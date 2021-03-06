//
//  RMVPImageCropper.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/31.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FileUtil.h"
#import "VPImageCropperViewController.h"

@protocol RMVPImageCropperDelegate <NSObject>

- (void)RMimageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage andfilePath:(NSURL *)filePath;
- (void)RMimageCropperDidCancel:(VPImageCropperViewController *)cropperViewController;

@optional

@end

@interface RMVPImageCropper : NSObject<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>
@property (assign, nonatomic) id<RMVPImageCropperDelegate>ctl;
@property (assign, nonatomic) CGFloat _scale;
@property (retain, nonatomic) UIImage * selfimage;
@property (retain, nonatomic) NSString * fileName;

+ (id)shareImageCropper;
- (void)showActionSheet;
- (void)openPics;
- (void)openCamera;
@end
