//
//  RMModifyPassWordViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/28.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMModifyPassWordViewController.h"
#import "AppDelegate.h"
#import "FileMangerObject.h"
@interface RMModifyPassWordViewController ()

@end

@implementation RMModifyPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"修改密码"];
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    [_sureModifyBtn addTarget:self action:@selector(passwordModify) forControlEvents:UIControlEventTouchDown];
    
    
    _sureModifyBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"red_btn", @"png")];
    _sureModifyBtn.layer.cornerRadius = 5;
    _sureModifyBtn.clipsToBounds = YES;
    
    _oldTextField.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _oldTextField.layer.cornerRadius = 5;
    
    _twoTextField.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _twoTextField.layer.cornerRadius = 5;
    
}

- (void)passwordModify{
    if([_oldTextField.text length] == 0||![[FileMangerObject md5:_oldTextField.text] isEqualToString:[[RMUserLoginInfoManager loginmanager] pwd]]){
        [self showHint:@"请输入正确的旧密码"];
        return;
    }else if ([_twoTextField.text length] == 0){
        [self showHint:_twoTextField.placeholder];
        return;
    }else if ([_sureTextField.text length] == 0){
        [self showHint:_sureTextField.placeholder];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager passwordModifyWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] NewPass:[FileMangerObject md5:_twoTextField.text] andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * mdoel = object;
            if(mdoel.status){
                AppDelegate * dele = [[UIApplication sharedApplication] delegate];
                [dele loadMainViewControllersWithType:0];
                [dele tabSelectController:2];
                [self navgationBarButtonClick:nil];
            }else{
                
            }
            [self showHint:mdoel.msg];
        }else{
            [self showHint:object];
        }
    }];
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
