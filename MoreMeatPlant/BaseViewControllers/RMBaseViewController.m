//
//  RMBaseViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMBaseViewController (){

}
@property (nonatomic, strong) UIView * statusView;
@property (nonatomic, strong) UIView * customNav;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation RMBaseViewController
@synthesize statusView, customNav, titleLabel;

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
    statusView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    [self.view addSubview:statusView];
    
    customNav = [[UIView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 44)];
    customNav.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    customNav.userInteractionEnabled = YES;
    customNav.multipleTouchEnabled = YES;
    [self.view addSubview:customNav];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, screenWidth - 80, 44)];
    titleLabel.userInteractionEnabled = YES;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = FONT(20.0);
    titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(screenWidth/2, 22);
    [customNav addSubview:titleLabel];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 42, screenWidth, 2)];
    line.backgroundColor = [UIColor colorWithRed:0.91 green:0.33 blue:0.22 alpha:1];
    line.userInteractionEnabled = YES;
//    [customNav addSubview:line];
    
    leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(7, 14, 43, 16);
    leftBarButton.tag = 1;
    [leftBarButton addTarget:self action:@selector(navgationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setEnlargeEdgeWithTop:25 right:25 bottom:25 left:25];
    [customNav addSubview:leftBarButton];
    
    rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.frame = CGRectMake(screenWidth - 50, 14, 43, 16);
    rightBarButton.tag = 2;
    [rightBarButton addTarget:self action:@selector(navgationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButton setEnlargeEdgeWithTop:25 right:25 bottom:25 left:25];
    [customNav addSubview:rightBarButton];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    //Ignore this super method
}

- (void)hideCustomNavigationBar:(BOOL)navigationBar withHideCustomStatusBar:(BOOL)statusBar {
    customNav.hidden = navigationBar;
    statusView.hidden = statusBar;
}

- (void)setCustomNavTitle:(NSString *)title {
    titleLabel.text = title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
