//
//  UserLoginInfoManager.h
//  BuyBuyring
//
//  Created by elongtian on 14-1-16.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RMUserLoginInfoManager : NSObject
@property (retain, nonatomic) NSString * user;//用户名称
@property (retain, nonatomic) NSString * pwd;//登陆密码
@property (assign, nonatomic) BOOL state;//登陆状态
@property (retain, nonatomic) NSString * coorStr;//经纬度（纬度，经度）
@property (retain, nonatomic) NSString * isCorp;//2 表示商家会员   1 表示用户会员
@property (retain, nonatomic) NSString * s_id;//会员的唯一标示
@property (retain, nonatomic) NSString * ypwd;//环信密码,明文

@property (retain, nonatomic) NSString * current_address;
+ (RMUserLoginInfoManager *)loginmanager;

@end
