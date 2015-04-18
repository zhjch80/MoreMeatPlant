//
//  AppDelegate.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCustomNavController.h"
#import "RMShareViewDelegate.h"
#import "RMLocationManager.h"
#import "RMAccountViewController.h"
#import "RMMoreChatViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>{

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RMCustomNavController *cusNav;
@property (retain, nonatomic) RMShareViewDelegate * viewdelegate;
@property (retain, nonatomic) RMLocationManager * locationManager;
@property (nonatomic, strong) RMAccountViewController * accountCtl;
@property (nonatomic, retain) RMMoreChatViewController * talkMoreCtl;

/**
 *  @method
 *  @param      type        0没有登录       1已经登录
 */
- (void)loadMainViewControllersWithType:(NSInteger)type;

- (void)tabSelectController:(NSInteger)index;

- (void)loginEaseMobWithUserName:(NSString *)userName
                        passWord:(NSString *)passWord
                         success:(void(^)(id arg))success
                         failure:(void(^)(id arg))failure;
- (void)logoutEaseMobWithSuccess:(void(^)(id arg))success
                         failure:(void(^)(id arg))failure;
@end

