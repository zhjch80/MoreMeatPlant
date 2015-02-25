//
//  CONST.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#define kScreenHeight       [UIScreen mainScreen].bounds.size.height
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width

#define isIOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7

#define IS_IPHONE_4_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_5_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_6_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_6p_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO) //1242, 2208   1080, 1920

#define FONT(_size) [UIFont fontWithName:@"Heiti TC" size:(_size)]  //HelveticaNeue-CondensedBlack

#define kImageTypePNG @"png"
//#define LOADIMAGE(file)   [UIImage imageNamed:[NSString stringWithFormat:@"%@",file]]
#define LOADIMAGE(file,ext)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
