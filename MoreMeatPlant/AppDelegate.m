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
#import "RMCustomTabBarController.h"
#import "RMLoginViewController.h"
#import "RMUserLoginInfoManager.h"
#import "EaseMob.h"
#import "BMapKit.h"



#import <ShareSDK/ShareSDK.h>

#import "WXApi.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "UIAlertView+Expland.h"

#import "AppDelegate+EaseMob.h"

#import "BBRGuideViewController.h"

#import "Harpy.h"
@interface AppDelegate ()<EMChatManagerDelegate>{
    RMHomeViewController * homeCtl;
    RMDaqoViewController * daqoCtl;
    
    RMLoginViewController * loginCtl;
    RMCustomTabBarController * customTabBarCtl;
    BMKMapManager* _mapManager;
    EMConnectionState _connectionState;
    
    RKNotificationHub * chat_badge;
}

@end


@implementation AppDelegate
@synthesize cusNav;
@synthesize locationManager, accountCtl,talkMoreCtl;

- (id)init
{
    self = [super init];
    if(self)
    {
        _viewdelegate = [[RMShareViewDelegate alloc] init];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
    [Harpy home_checkVersion];
    
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    homeCtl = [[RMHomeViewController alloc] init];
    daqoCtl = [[RMDaqoViewController alloc] init];
    accountCtl = [[RMAccountViewController alloc] init];
    talkMoreCtl = [[RMMoreChatViewController alloc] init];
    loginCtl = [[RMLoginViewController alloc] init];
    
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"PmToYIG4c7uTjtpOwnX1QhLD"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [self validate];
    
    [self initializePlat];
    
    //TODO:判断是否登录
    [self loadMainViewControllersWithType:[[RMUserLoginInfoManager loginmanager] state]];
    
    
    return YES;
}
/**
 *  @method 验证是否登录
 */
- (void)validate{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:LoginState] boolValue]){//已经登录
        NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
        NSString * pwd = [[NSUserDefaults standardUserDefaults] objectForKey:UserPwd];
        NSString * iscorp = [[NSUserDefaults standardUserDefaults] objectForKey:UserType];
        NSString * coorstr = [[NSUserDefaults standardUserDefaults] objectForKey:UserCoor];
        NSString * ypwd = [[NSUserDefaults standardUserDefaults] objectForKey:UserYPWD];
        NSString * s_id = [[NSUserDefaults standardUserDefaults] objectForKey:UserS_id];
        NSLog(@"appdelegate用户类型：%@",iscorp);
        [[RMUserLoginInfoManager loginmanager] setState:YES];
        [[RMUserLoginInfoManager loginmanager] setUser:user];
        [[RMUserLoginInfoManager loginmanager] setPwd:pwd];
        [[RMUserLoginInfoManager loginmanager] setIsCorp:iscorp];
        [[RMUserLoginInfoManager loginmanager] setCoorStr:coorstr];
        [[RMUserLoginInfoManager loginmanager] setYpwd:ypwd];
        [[RMUserLoginInfoManager loginmanager] setS_id:s_id];
        
        
        [self loginEaseMobWithUserName:[[RMUserLoginInfoManager loginmanager]user]
                              passWord:[[RMUserLoginInfoManager loginmanager] ypwd] success:^(id arg) {
                                  NSLog(@"登录成功！");
                              } failure:^(id arg) {
                                  NSLog(@"登录失败！");
                              }];
        
    }else{
        [[RMUserLoginInfoManager loginmanager] setState:NO];
        [[RMUserLoginInfoManager loginmanager] setUser:@""];
        [[RMUserLoginInfoManager loginmanager] setPwd:@""];
        [[RMUserLoginInfoManager loginmanager] setYpwd:@""];
    }
}
/**
 *  @method 
 *  @param      type        0没有登录 1已经登录
 */
- (void)loadMainViewControllersWithType:(NSInteger)type {
    
    
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        //程序第一次启动，进入引导页面
        BBRGuideViewController *appStartController = [[BBRGuideViewController alloc] init];
        self.window.rootViewController = appStartController;
    }else {
        //程序不是第一次启动，进入主页面
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:talkMoreCtl];
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
                [accountCtl initPlat];
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
        
        
        
        
        chat_badge = [[RKNotificationHub alloc]initWithView:button3];
        [chat_badge scaleCircleSizeBy:0.5];
        [chat_badge setCount:[[talkMoreCtl queryInfoNumber] intValue]];

        
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
}



- (void)queryInfoNumber{
    [chat_badge setCount:[[talkMoreCtl queryInfoNumber] intValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWMESSAGE" object:nil];
}

#pragma mark - 外面调用select tab的控制器

- (void)tabSelectController:(NSInteger)index {
    [customTabBarCtl clickButtonWithIndex:index];
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    __block AppDelegate * dele = self;
    if(locationManager == nil){
        locationManager = [[RMLocationManager alloc]init];
    }
    [locationManager startLocation];
        locationManager.callback = ^(BMKUserLocation * userLocation){
            if(userLocation){
                [dele->locationManager stopLocation];
                NSString * coor = [NSString stringWithFormat:@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude];
                [[RMUserLoginInfoManager loginmanager] setCoorStr:coor];
                [[NSUserDefaults standardUserDefaults] setValue:coor forKey:UserCoor];
                NSLog(@"%@",[[RMUserLoginInfoManager loginmanager] coorStr]);
            }
        };
}



#pragma mark - 推送处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您有新消息推送，是否立即查看？" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"稍后查看",@"立即查看", nil];
    [alert handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
        if(btnIndex == 0){
        
        }else{
            [self tabSelectController:3];
        }
    }];
    [alert show];
}


#pragma mark -----

- (void)initializePlat
{
    //------------------------------------
    /** 连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
//    [ShareSDK connectSinaWeiboWithAppKey:@"306649366"
//                               appSecret:@"81f5a6b6f1173d7d58b19f58049c610b"
//                             redirectUri:@"http://dj.7-hotel.com/"];
//    
//    /**
//     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
//     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
//     
//     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
//     **/
//    [ShareSDK connectTencentWeiboWithAppKey:@"1101736043"
//                                  appSecret:@"TNNrnim5dEF4u1SH"
//                                redirectUri:@"http://dj.7-hotel.com/download/"
//                                   wbApiCls:[WeiboApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"1101736043"
                           appSecret:@"TNNrnim5dEF4u1SH"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx5354085a0152c131" wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"1101736043"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    
    //连接邮件
    [ShareSDK connectMail];
//
//    //连接拷贝
//    [ShareSDK connectCopy];
}


- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}


@end
