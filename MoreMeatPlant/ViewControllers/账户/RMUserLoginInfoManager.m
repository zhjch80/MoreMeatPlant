//
//  UserLoginInfoManager.m
//  BuyBuyring
//
//  Created by elongtian on 14-1-16.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "RMUserLoginInfoManager.h"

static RMUserLoginInfoManager * manager;
@implementation RMUserLoginInfoManager
@synthesize user;
@synthesize pwd;//密码我在登录成功的时候存在单例中的是md5编码的
@synthesize state;
@synthesize coorStr;
@synthesize isCorp;
@synthesize ypwd;
@synthesize s_id;

- (id)init
{
    if(self = [super init])
    {
        self.state = NO;
    }
    return self;
}

+ (RMUserLoginInfoManager *)loginmanager
{
    if(manager == nil)
    {
        manager = [[RMUserLoginInfoManager alloc] init];
    }
    return manager;//记得这里加同步锁
}
 


@end
