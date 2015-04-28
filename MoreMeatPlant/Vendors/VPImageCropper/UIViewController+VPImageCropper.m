//
//  UIViewController+VPImageCropper.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/31.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "UIViewController+VPImageCropper.h"
#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "VPImageCropperViewController.h"
#define IOS7 [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7

#define IOS8 [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8

#define kPhotoName              @"content_license.png"
#define kImageCachePath         @"imagecache"

#define ORIGINAL_MAX_WIDTH  [UIScreen mainScreen].bounds.size.width*2

@implementation UIViewController (VPImageCropper)

//
//
//
//
//


@end
