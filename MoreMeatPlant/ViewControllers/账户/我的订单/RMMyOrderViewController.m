//
//  RMMyOrderViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMMyOrderViewController.h"

@interface RMMyOrderViewController ()

@end

@implementation RMMyOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kHideCustomTabbar" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowCustomTabbar" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    [self setCustomNavTitle:@"我的订单"];
    waitDeliveryCtl = [[RMOrderListViewController alloc]initWithNibName:@"RMOrderListViewController" bundle:nil];
    waitDeliveryCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64-40);
    waitDeliveryCtl.maintableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40);
    [self.view addSubview:waitDeliveryCtl.view];
    
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    if (self.callback){
        _callback();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
