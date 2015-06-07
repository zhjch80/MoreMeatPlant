//
//  RMBaseViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMCorpModel.h"
#import "RMProductModel.h"
//#import "IQKeyboardManager.h"
#import "AppDelegate.h"

@interface RMBaseViewController (){
}
@property (nonatomic, strong) UIView * statusView;
@property (nonatomic, strong) UIView * customNav;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation RMBaseViewController
@synthesize statusView, customNav, titleLabel;

-(void)dealloc {
    returnKeyHandler = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NEWMESSAGE" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
    statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
    statusView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [self.view addSubview:statusView];
    
    customNav = [[UIView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 44)];
    customNav.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    customNav.userInteractionEnabled = YES;
    customNav.multipleTouchEnabled = YES;
    [self.view addSubview:customNav];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, customNav.frame.size.width, customNav.frame.size.height);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor,
                       (id)[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor,
                       nil];
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(0, 1);
    gradient.startPoint = startPoint;
    gradient.endPoint = endPoint;
    [customNav.layer insertSublayer:gradient atIndex:0];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, screenWidth - 80, 44)];
    titleLabel.userInteractionEnabled = YES;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = FONT_2(18.0);
    titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(screenWidth/2, 22);
    [customNav addSubview:titleLabel];
    
//    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 42, screenWidth, 2)];
//    line.backgroundColor = [UIColor colorWithRed:0.91 green:0.33 blue:0.22 alpha:1];
//    line.userInteractionEnabled = YES;
//    [customNav addSubview:line];
    
    leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(3, 0, 80, 44);
    leftBarButton.tag = 1;
    [leftBarButton addTarget:self action:@selector(navgationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    [customNav addSubview:leftBarButton];
    
    rightOneBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightOneBarButton.frame = CGRectMake(screenWidth - 50, 0, 44, 44);
    rightOneBarButton.tag = 2;
    [rightOneBarButton addTarget:self action:@selector(navgationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightOneBarButton setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    [customNav addSubview:rightOneBarButton];
    
    rightTwoBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightTwoBarButton.frame = CGRectMake(screenWidth - 50, 0, 44, 44);
    rightTwoBarButton.tag = 3;
    [rightTwoBarButton addTarget:self action:@selector(navgationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightTwoBarButton setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    [customNav addSubview:rightTwoBarButton];
    
    
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    [returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
    returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarByPosition;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviverNoti:) name:@"NEWMESSAGE" object:nil];
}


- (void)receviverNoti:(NSNotification *)noti{
    
}


- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    //Ignore this super method
}

- (void)setHideCustomNavigationBar:(BOOL)navigationBar withHideCustomStatusBar:(BOOL)statusBar {
    customNav.hidden = navigationBar;
    statusView.hidden = statusBar;
}

- (void)setCustomNavBackgroundColor:(UIColor *)navColor withStatusViewBackgroundColor:(UIColor *)statusColor {
    if ([navColor isKindOfClass:[UIColor class]]){
        customNav.backgroundColor = navColor;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, customNav.frame.size.width, customNav.frame.size.height);
        gradient.colors = [NSArray arrayWithObjects:
                           (id)navColor.CGColor,
                           (id)navColor.CGColor,
                           nil];
        CGPoint startPoint = CGPointMake(0, 0);
        CGPoint endPoint = CGPointMake(0, 1);
        gradient.startPoint = startPoint;
        gradient.endPoint = endPoint;
        [customNav.layer insertSublayer:gradient atIndex:0];
    }
    
    if ([statusColor isKindOfClass:[UIColor class]]){
        statusView.backgroundColor = statusColor;
    }
}

- (void)setCustomNavTitle:(NSString *)title {
    titleLabel.text = title;
    titleLabel.font = FONT_3(18.0);
}

- (void)setRightBarButtonNumber:(NSInteger)number {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    switch (number) {
        case 1:{
            rightOneBarButton.hidden = NO;
            rightTwoBarButton.hidden = YES;

            rightOneBarButton.frame = CGRectMake(screenWidth - 50, 0, 44, 44);
            break;
        }
        case 2:{
            rightOneBarButton.hidden = NO;
            rightTwoBarButton.hidden = NO;
            
            rightOneBarButton.frame = CGRectMake(screenWidth - 90, 0, 44, 44);
            rightTwoBarButton.frame = CGRectMake(screenWidth - 50, 0, 44, 44);
            break;
        }
            
        default:
            break;
    }
}


#pragma mark - 查询购物车数量

- (NSString *)queryShopCarNumber{
    
    NSInteger  num = 0;
    
    for(RMProductModel * product in [RMProductModel allDbObjects]){
        num += product.content_num;
    }
    
    if((num == 0)|![[RMUserLoginInfoManager loginmanager] state]|[[[RMUserLoginInfoManager loginmanager]isCorp] boolValue]){
        return nil;
    }else if (num > 99){
        return @"99";
    }else{
        return [NSString stringWithFormat:@"%ld",(long)num];
    }
}

- (NSString *)queryInfoNumber{
    AppDelegate * dele = [[UIApplication sharedApplication] delegate];
    if([dele.talkMoreCtl UnreadMessageCount] == 0){
        return nil;
    }else if ([dele.talkMoreCtl UnreadMessageCount] > 99){
        return @"99";
    }else{
        return [NSString stringWithFormat:@"%ld",(long)[dele.talkMoreCtl UnreadMessageCount]];
    }
}

@end
