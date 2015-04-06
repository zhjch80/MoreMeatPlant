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
#import "FileMangerObject.h"

#import "AppDelegate.h"



@interface RMLoginViewController ()

@end

@implementation RMLoginViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];

    [_forgotPassBtn addTarget:self action:@selector(forgotAction:) forControlEvents:UIControlEventTouchDown];
    [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchDown];
    [_registBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchDown];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)loginAction:(id)sender{
    if(_userTextField.text.length==0){
        [MBProgressHUD showError:@"请输入手机号或者昵称" toView:self.view];
        return;
    }else if (_passTextField.text.length == 0){
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager loginRequestWithUser:_userTextField.text Pwd:[FileMangerObject md5:_passTextField.text] andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        RMPublicModel * model = (RMPublicModel *)object;
        if(error){
            NSLog(@"error:%@",error);
        }
        if(success&&model.status){//登录成功
            [[NSUserDefaults standardUserDefaults] setValue:_userTextField.text forKey:UserName];
            [[NSUserDefaults standardUserDefaults] setValue:[FileMangerObject md5:_passTextField.text] forKey:UserPwd];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LoginState];
            [[NSUserDefaults standardUserDefaults] setValue:model.s_type forKey:UserType];
            [[NSUserDefaults standardUserDefaults] setValue:_passTextField.text forKey:UserYPWD];
            
            NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
            NSString * pwd = [[NSUserDefaults standardUserDefaults] objectForKey:UserPwd];
            NSString * iscorp = [[NSUserDefaults standardUserDefaults] objectForKey:UserType];
            NSString * coorstr = [[NSUserDefaults standardUserDefaults] objectForKey:UserCoor];
            NSString * ypwd = [[NSUserDefaults standardUserDefaults] objectForKey:UserYPWD];
            NSLog(@"登录用户类型：%@",iscorp);
            
            [[RMUserLoginInfoManager loginmanager] setState:YES];
            [[RMUserLoginInfoManager loginmanager] setUser:user];
            [[RMUserLoginInfoManager loginmanager] setPwd:pwd];
            [[RMUserLoginInfoManager loginmanager] setIsCorp:iscorp];
            [[RMUserLoginInfoManager loginmanager] setCoorStr:coorstr];
            [[RMUserLoginInfoManager loginmanager] setYpwd:ypwd];

            
            AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
            
            [delegate loadMainViewControllersWithType:[[RMUserLoginInfoManager loginmanager] state]];
            [delegate tabSelectController:2];
            
        }else{
            
        }
        [MBProgressHUD showSuccess:model.msg toView:self.view];
    }];
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
