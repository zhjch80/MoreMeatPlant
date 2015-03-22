//
//  UserLoginInfoManager.h
//  BuyBuyring
//
//  Created by elongtian on 14-1-16.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserLoginInfoManager : NSObject
@property (retain, nonatomic) NSString * user;//用户名称
@property (retain, nonatomic) NSString * pwd;//登陆密码
@property (assign, nonatomic) BOOL state;//登陆状态

+ (UserLoginInfoManager *)loginmanager;

@end
