//
//  RMHadBabyViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMHadBabyViewController.h"
#import "DaiDodgeKeyboard.h"
@interface RMHadBabyViewController ()

@end

@implementation RMHadBabyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self setCustomNavTitle:@"已出宝贝"];
    waitDeliveryCtl = [[RMHadBabyListViewController alloc]initWithNibName:@"RMHadBabyListViewController" bundle:nil];
    waitDeliveryCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64-40);
    waitDeliveryCtl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40);
    [self.view addSubview:waitDeliveryCtl.view];
}


- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    if(self.callback){
        _callback();
    }
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
