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
#import "RMLoginViewController.h"
#import "RMUserLoginInfoManager.h"
#import "EaseMob.h"
#import "BMapKit.h"

@interface AppDelegate ()<EMChatManagerDelegate>{
    RMHomeViewController * homeCtl;
    RMDaqoViewController * daqoCtl;
    RMAccountViewController * accountCtl;
    RMTalkMoreViewController * talkMoreCtl;
    RMLoginViewController * loginCtl;
    RMCustomTabBarController * customTabBarCtl;
    BMKMapManager* _mapManager;
}

@end


@implementation AppDelegate
@synthesize cusNav;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    homeCtl = [[RMHomeViewController alloc] init];
    daqoCtl = [[RMDaqoViewController alloc] init];
    accountCtl = [[RMAccountViewController alloc] init];
    talkMoreCtl = [[RMTalkMoreViewController alloc] init];
    loginCtl = [[RMLoginViewController alloc] init];
    
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"M1hyZjTBO3V9nEX0tvFSVoZ2"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [self validate];
    
    //TODO:判断是否登录
    [self loadMainViewControllersWithType:[[RMUserLoginInfoManager loginmanager] state]];
    
#pragma mark - 环信配置
#warning  修改一 注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应，该证书用来在有新消息时给用户推送通知
    NSString *apnsCertName = @"";
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"snowyshell#moremeatplant" apnsCertName:apnsCertName];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self registerRemoteNotification];
    
#warning 修改二 登录环信账号，该部分代码需要移到登录界面登录自己本身的账号成功后
    //登录时候的账号和密码是在环信后台设置好的，以后需要自己的服务器在接口返回 密码都是111111 
    [self loginEaseMobWithUserName:@"zhangbeibei"
                          passWord:@"111111"
                           success:^(id arg) {
                               //登录成功s
                           }
                           failure:^(id arg) {
                               //登录失败
                           }];
    
    return YES;
}
/**
 *  @method 验证是否登录
 */
- (void)validate{
    if([[NSUserDefaults standardUserDefaults] objectForKey:LoginState]){//已经登录
        NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
        NSString * pwd = [[NSUserDefaults standardUserDefaults] objectForKey:UserPwd];
        NSString * iscorp = [[NSUserDefaults standardUserDefaults] objectForKey:UserType];
        NSString * coorstr = [[NSUserDefaults standardUserDefaults] objectForKey:UserCoor];
        
        [[RMUserLoginInfoManager loginmanager] setState:YES];
        [[RMUserLoginInfoManager loginmanager] setUser:user];
        [[RMUserLoginInfoManager loginmanager] setPwd:pwd];
        [[RMUserLoginInfoManager loginmanager] setIsCorp:iscorp];
        [[RMUserLoginInfoManager loginmanager] setCoorStr:coorstr];
    }else{
        
    }
}
/**
 *  @method 
 *  @param      type        0没有登录 1已经登录
 */
- (void)loadMainViewControllersWithType:(NSInteger)type {
    NSArray * controllers;
    switch (type) {
        case 0:{
            //没有登录
            controllers = [NSArray arrayWithObjects:homeCtl, daqoCtl, loginCtl, talkMoreCtl, nil];
            break;
        }
        case 1:{
            //已经登录
            controllers = [NSArray arrayWithObjects:homeCtl, daqoCtl, accountCtl, talkMoreCtl, nil];
            break;
        }
            
        default:
            break;
    }
    
    if (!customTabBarCtl){
        customTabBarCtl = [[RMCustomTabBarController alloc] init];
    }
    ((RMCustomTabBarController *)customTabBarCtl).tabbarHeight = 49;
    ((RMCustomTabBarController *)customTabBarCtl).TabarItemWidth = kScreenWidth/4.0f;
    ((RMCustomTabBarController *)customTabBarCtl).isInDeck = YES;
    ((UITabBarController *)customTabBarCtl).viewControllers = controllers;
    UIButton *button0 = [((RMCustomTabBarController *)customTabBarCtl) customTabbarItemWithIndex:0];
    UIButton *button1 = [((RMCustomTabBarController *)customTabBarCtl) customTabbarItemWithIndex:1];
    UIButton *button2 = [((RMCustomTabBarController *)customTabBarCtl) customTabbarItemWithIndex:2];
    UIButton *button3 = [((RMCustomTabBarController *)customTabBarCtl) customTabbarItemWithIndex:3];
    
    NSArray * imageName = [NSArray arrayWithObjects:@"home", @"daquan", @"zhanghu", @"duoliao", nil];

    [button0 setImage:LOADIMAGE([imageName objectAtIndex:0], kImageTypePNG) forState:UIControlStateNormal];
    [button1 setImage:LOADIMAGE([imageName objectAtIndex:1], kImageTypePNG) forState:UIControlStateNormal];
    [button2 setImage:LOADIMAGE([imageName objectAtIndex:2], kImageTypePNG)  forState:UIControlStateNormal];
    [button3 setImage:LOADIMAGE([imageName objectAtIndex:3], kImageTypePNG) forState:UIControlStateNormal];
    
    [((RMCustomTabBarController *)customTabBarCtl) clickButtonWithIndex:0];
    self.cusNav = [[RMCustomNavController alloc] initWithRootViewController:customTabBarCtl];
    self.cusNav.navigationBar.hidden = YES;
    [self.window setRootViewController:self.cusNav];
}

#pragma mark - 外面调用select tab的控制器

- (void)tabSelectController:(NSInteger)index {
    [customTabBarCtl clickButtonWithIndex:index];
}

#pragma mark - EMChatManagerDelegate

- (void)didLoginFromOtherDevice {
    //账号在其他设备登陆，登出
    EMError *error;
    [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:&error];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"你的账号已在其他地方登录"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
    [alertView show];
    //TODO:检测到账号在其他设备登录后要做的操作，如：退出该账号到登录界面等，根据项目需求来做
}

#pragma mark - 登录和退出环信方法

- (void)loginEaseMobWithUserName:(NSString *)userName
                        passWord:(NSString *)passWord
                         success:(void(^)(id arg))success
                         failure:(void(^)(id arg))failure
{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName
                                                        password:passWord
                                                      completion:^(NSDictionary *loginInfo, EMError *error)
     {
         if (loginInfo && !error) {
             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             if (!error) {
                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             }
             NSLog(@"环信账号登录成功");
             if (success) success(loginInfo);
         }else {
             
             NSString *errorMessage = @"";
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                 {
                     errorMessage = @"连接服务器失败!";
                 }
                     break;
                 case EMErrorServerAuthenticationFailure:
                 {
                     errorMessage = error.description;
                 }
                     break;
                 case EMErrorServerTimeout:
                 {
                     errorMessage = @"连接服务器失败!";
                 }
                     break;
                 default:
                 {
                     errorMessage = @"登录失败!";
                 }
                     break;
             }
             NSLog(@"login error %@",errorMessage);
             if (failure) {
                 failure(errorMessage);
             }
         }
     } onQueue:nil];
    
}


- (void)logoutEaseMobWithSuccess:(void(^)(id arg))success
                         failure:(void(^)(id arg))failure
{
    EMError *error;
    NSDictionary *logOutResult = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:&error];
    if (error) {
        if (failure) failure(error);
    }else{
        if (success) success(logOutResult);
    }
}


#pragma mark - application

- (void)applicationWillResignActive:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

#pragma mark - 

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

@end
