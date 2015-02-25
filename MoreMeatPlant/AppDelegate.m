//
//  AppDelegate.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "AppDelegate.h"
#import "RMHomeViewController.h"
#import "RMDaqoViewController.h"
#import "RMAccountViewController.h"
#import "RMTalkMoreViewController.h"
#import "RMCustomTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize cusNav;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [self loadMainViewControllers];
    
    return YES;
}

- (void)loadMainViewControllers {
    RMHomeViewController * homeCtl = [[RMHomeViewController alloc] init];
    RMDaqoViewController * daqoCtl = [[RMDaqoViewController alloc] init];
    RMAccountViewController * accountCtl = [[RMAccountViewController alloc] init];
    RMTalkMoreViewController * talkMoreCtl = [[RMTalkMoreViewController alloc] init];
    
    NSArray * controllers = [NSArray arrayWithObjects:homeCtl, daqoCtl, accountCtl, talkMoreCtl, nil];

    RMCustomTabBarController * customTabBarCtl = [[RMCustomTabBarController alloc] init];
    ((RMCustomTabBarController *)customTabBarCtl).tabbarHeight = 49;
    ((RMCustomTabBarController *)customTabBarCtl).TabarItemWidth = kScreenWidth/4.0f;
    ((RMCustomTabBarController *)customTabBarCtl).isInDeck = YES;
    ((UITabBarController *)customTabBarCtl).viewControllers = controllers;
    UIButton *button0 = [((RMCustomTabBarController *)customTabBarCtl) customTabbarItemWithIndex:0];
    UIButton *button1 = [((RMCustomTabBarController *)customTabBarCtl) customTabbarItemWithIndex:1];
    UIButton *button2 = [((RMCustomTabBarController *)customTabBarCtl) customTabbarItemWithIndex:2];
    UIButton *button3 = [((RMCustomTabBarController *)customTabBarCtl) customTabbarItemWithIndex:3];
    
    NSArray * imageName;
    if (IS_IPHONE_6_SCREEN){
        imageName = [NSArray arrayWithObjects:@"home_selected_6", @"ranking_unselected_6", @"myChannel_unselected_6", @"setUp_unselected_6", nil];
    }else if (IS_IPHONE_6p_SCREEN){
        imageName = [NSArray arrayWithObjects:@"home_selected_6p", @"ranking_unselected6_6p", @"myChannel_unselected_6p", @"setUp_unselected_6p", nil];
    }else{
        imageName = [NSArray arrayWithObjects:@"home_selected", @"ranking_unselected", @"myChannel_unselected", @"setUp_unselected", nil];
    }

    [button0 setBackgroundImage:LOADIMAGE([imageName objectAtIndex:0], kImageTypePNG) forState:UIControlStateNormal];
    button0.backgroundColor = [UIColor redColor];
    [button1 setBackgroundImage:LOADIMAGE([imageName objectAtIndex:1], kImageTypePNG) forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor orangeColor];
    [button2 setBackgroundImage:LOADIMAGE([imageName objectAtIndex:2], kImageTypePNG)  forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor yellowColor];
    [button3 setBackgroundImage:LOADIMAGE([imageName objectAtIndex:3], kImageTypePNG) forState:UIControlStateNormal];
    button3.backgroundColor = [UIColor blueColor];
    
    [((RMCustomTabBarController *)customTabBarCtl) clickButtonWithIndex:0];
    self.cusNav = [[RMCustomNavController alloc] initWithRootViewController:customTabBarCtl];
    self.cusNav.navigationBar.hidden = YES;
    [self.window setRootViewController:self.cusNav];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
