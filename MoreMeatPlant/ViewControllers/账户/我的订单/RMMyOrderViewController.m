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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    waitDeliveryController = [[RMOrderListViewController alloc]initWithNibName:@"RMOrderListViewController" bundle:nil];
    waitDeliveryController.view.frame = CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-40);
    waitDeliveryController.maintableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40);
    [self.view addSubview:waitDeliveryController.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
