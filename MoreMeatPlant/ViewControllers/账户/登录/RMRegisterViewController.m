//
//  RMRegisterViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/21.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMRegisterViewController.h"
#import "DaiDodgeKeyboard.h"
@interface RMRegisterViewController ()

@end

@implementation RMRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
     [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
    
    [_user_btn addTarget:self action:@selector(selectRegisterType:) forControlEvents:UIControlEventTouchDown];
    [_corp_btn addTarget:self action:@selector(selectRegisterType:) forControlEvents:UIControlEventTouchDown];
    
    [_back_login_btn addTarget:self action:@selector(backLoginAction:) forControlEvents:UIControlEventTouchDown];
    
    [_send_code_btn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchDown];
    
    [_sure_btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchDown];
}

- (void)backLoginAction:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sureAction:(id)sender{

}

- (void)selectRegisterType:(id)sender{

}

- (void)sendCodeAction:(id)sender{

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
