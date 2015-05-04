//
//  CONST.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#define baseHeaderUrl       @"http://218.240.30.6/drzw/file/upload/"

#define kScreenHeight       [UIScreen mainScreen].bounds.size.height
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width

#define isIOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7

#define IS_IPHONE_4_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_5_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_6_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_6p_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO) //1242, 2208   1080, 1920

#define OBJC(v) (([v isEqual:[NSNull null]] | [v isEqual:@"(null)"] | [v isEqual:@"<null>"] | v== nil) ? @"" : v)
#define OBJC_Nil(v) (([v isEqual:[NSNull null]]) ? nil : v)

#define Str_Objc(v,replace) (([v length] == 0 | v == nil | [v isEqual:[NSNull null]]) ?replace:v)

#define FONT(_size) [UIFont systemFontOfSize:(_size)]
#define FONT_0(_size) [UIFont fontWithName:@"FZZXHJW--GB1-0" size:(_size)]
#define FONT_1(_size) [UIFont fontWithName:@"FZZHJW--GB1-0" size:(_size)]
#define FONT_2(_size) [UIFont fontWithName:@"FZZZHUNHJW--GB1-0" size:(_size)]
#define FONT_3(_size) [UIFont fontWithName:@"FZZZHONGJW--GB1-0" size:(_size)]
#define FONT_4(_size) [UIFont fontWithName:@"FZZCHJW--GB1-0" size:(_size)]
#define FONT_5(_size) [UIFont fontWithName:@"FZZDHJW--GB1-0" size:(_size)]

//FZZXHJW--GB1-0    方正正纤黑简体 0
//FZZHJW--GB1-0     方正正黑简体   1
//FZZZHUNHJW--GB1-0 方正正准黑简体 2
//FZZZHONGJW--GB1-0 方正正中黑简体 3
//FZZCHJW--GB1-0    方正正粗黑简体 4
//FZZDHJW--GB1-0    方正正大黑简体 5   0-5  表示越来越粗

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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


//
#define LoginState @"login_state"
#define UserName @"user_name"
#define UserPwd @"pwd"
#define UserType @"is_corp"
#define UserCoor @"coor"
#define UserYPWD @"HX_PWD"//环信密码
#define UserS_id @"s_id" //会员唯一标示


#import "RMProductModel.h"
#import "RMCorpModel.h"

#define PaymentCompletedNotification @"PaymentCompletedNotification" //支付完成
#define RMRequestMemberInfoAgainNotification @"RMRequestMemberInfoAgainNotification" //重新请求用户资料




