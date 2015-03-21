//
//  RMLoginViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/21.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMLoginViewController.h"
#import "RMRegisterViewController.h"
#import "RMForgotWordViewController.h"
#import "DaiDodgeKeyboard.h"
@interface RMLoginViewController ()

@end

@implementation RMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
    
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    [_forgotPassBtn addTarget:self action:@selector(forgotAction:) forControlEvents:UIControlEventTouchDown];
    [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchDown];
    [_registBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchDown];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)loginAction:(id)sender{

}
- (void)forgotAction:(id)sender{
    RMForgotWordViewController * forgot = [[RMForgotWordViewController alloc]initWithNibName:@"RMForgotWordViewController" bundle:nil];
    [self.navigationController pushViewController:forgot animated:YES];
}
- (void)registerAction:(id)sender{
    RMRegisterViewController * regist = [[RMRegisterViewController alloc]initWithNibName:@"RMRegisterViewController" bundle:nil];
    [self.navigationController pushViewController:regist animated:YES];
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
