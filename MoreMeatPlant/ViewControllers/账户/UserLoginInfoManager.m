//
//  UserLoginInfoManager.m
//  BuyBuyring
//
//  Created by elongtian on 14-1-16.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "UserLoginInfoManager.h"

static UserLoginInfoManager * manager;
@implementation UserLoginInfoManager
@synthesize user;
@synthesize pwd;//密码我在登录成功的时候存在单例中的是md5编码的
@synthesize state;


- (id)init
{
    if(self = [super init])
    {
        self.state = NO;
    }
    return self;
}

+ (UserLoginInfoManager *)loginmanager
{
    if(manager == nil)
    {
        manager = [[UserLoginInfoManager alloc] init];
    }
    return manager;//记得这里加同步锁
}
 


@end
