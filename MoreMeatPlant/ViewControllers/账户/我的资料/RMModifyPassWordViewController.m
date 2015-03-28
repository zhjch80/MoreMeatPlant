//
//  RMModifyPassWordViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/28.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMModifyPassWordViewController.h"

@interface RMModifyPassWordViewController ()

@end

@implementation RMModifyPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"修改密码"];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
