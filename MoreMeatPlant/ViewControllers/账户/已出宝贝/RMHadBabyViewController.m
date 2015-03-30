//
//  RMHadBabyViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMHadBabyViewController.h"
@interface RMHadBabyViewController ()

@end

@implementation RMHadBabyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor = [UIColor clearColor];
    [self setCustomNavTitle:@"已出宝贝"];
    waitDeliveryCtl = [[RMHadBabyListViewController alloc]initWithNibName:@"RMHadBabyListViewController" bundle:nil];
    waitDeliveryCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64 - 40 - 40);
    waitDeliveryCtl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40 - 40);
    [self.view addSubview:waitDeliveryCtl.view];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
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
