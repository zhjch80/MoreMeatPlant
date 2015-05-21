//
//  RegularManager.h
//  BuyBuyringSeller
//
//  Created by elongtian on 14-4-16.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularManager : NSObject
+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) validateMobile:(NSString *)mobile;
+ (BOOL) validateCarNo:(NSString *)carNo;
+ (BOOL) validateCarType:(NSString *)CarType;
+ (BOOL) validateUserName:(NSString *)name;
+ (BOOL) validatePassword:(NSString *)passWord;
+ (BOOL) validateNickname:(NSString *)nickname;
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
@end
