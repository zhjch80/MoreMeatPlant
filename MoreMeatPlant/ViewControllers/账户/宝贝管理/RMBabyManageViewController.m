//
//  RMBabyManageViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBabyManageViewController.h"

@interface RMBabyManageViewController ()

@end

@implementation RMBabyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"宝贝管理"];
    
    all_Ctl = [[RMBabyListViewController alloc]initWithNibName:@"RMBabyListViewController" bundle:nil];
    all_Ctl.view.frame = CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-44);
    all_Ctl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44);
    [self.view addSubview:all_Ctl.view];
    
    
    ware_Ctl = [[RMBabyListViewController alloc]initWithNibName:@"RMBabyListViewController" bundle:nil];
    ware_Ctl.view.frame = CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-44);
    ware_Ctl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44);
    
    class_Ctl = [[RMBabyListViewController alloc]initWithNibName:@"RMBabyListViewController" bundle:nil];
    class_Ctl.view.frame = CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-44);
    class_Ctl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44);
    
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
