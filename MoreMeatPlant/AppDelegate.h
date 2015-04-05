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
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RMCustomNavController *cusNav;
@property (retain, nonatomic) RMShareViewDelegate * viewdelegate;

/**
 *  @method
 *  @param      type        0没有登录       1已经登录
 */
- (void)loadMainViewControllersWithType:(NSInteger)type;

- (void)tabSelectController:(NSInteger)index;
@end

