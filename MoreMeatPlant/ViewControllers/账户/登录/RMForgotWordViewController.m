//
//  RMForgotWordViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/21.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMForgotWordViewController.h"
#import "DaiDodgeKeyboard.h"
#import "FileMangerObject.h"
@interface RMForgotWordViewController ()

@end

@implementation RMForgotWordViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc{
    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];

    [_back_login_btn addTarget:self action:@selector(backLoginAction:) forControlEvents:UIControlEventTouchDown];
    [_sendCodeBtn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchDown];
    [_sure_btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchDown];
}

- (void)backLoginAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)sureAction:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager resetPwdRequestWithUser:_mobileTextField.text Pwd:[FileMangerObject md5:_passTextField.text] Code:_codeTextField.text andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        RMPublicModel * model = (RMPublicModel *)object;
        if(error){
            NSLog(@"%@",error);
        }
        if(success&&model.status){
            
        }
        [MBProgressHUD showSuccess:model.msg toView:self.view];
        
        [self performSelector:@selector(afterLoad) withObject:nil afterDelay:0.5];
    }];
}

- (void)afterLoad{
    [self.navigationController popViewControllerAnimated:YES];
    //密码重新设置成功之后清除本地密码存储
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:UserName];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:UserPwd];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LoginState];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:UserType];
    
    NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
    NSString * pwd = [[NSUserDefaults standardUserDefaults] objectForKey:UserPwd];
    NSString * iscorp = [[NSUserDefaults standardUserDefaults] objectForKey:UserType];
    NSString * coorstr = [[NSUserDefaults standardUserDefaults] objectForKey:UserCoor];
    
    [[RMUserLoginInfoManager loginmanager] setState:NO];
    [[RMUserLoginInfoManager loginmanager] setUser:user];
    [[RMUserLoginInfoManager loginmanager] setPwd:pwd];
    [[RMUserLoginInfoManager loginmanager] setIsCorp:iscorp];
    [[RMUserLoginInfoManager loginmanager] setCoorStr:coorstr];
}

- (void)sendCodeAction:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager forgotPwdSendCodeWith:_mobileTextField.text andCallBack:^(NSError *error, BOOL success, id object) {
        RMPublicModel * model = (RMPublicModel *)object;
        if(error){
            NSLog(@"%@",error);
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success&&model.status){
            
        }
        [MBProgressHUD showSuccess:model.msg toView:self.view];
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
