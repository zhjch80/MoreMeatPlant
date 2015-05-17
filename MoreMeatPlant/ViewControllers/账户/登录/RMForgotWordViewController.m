//
//  RMForgotWordViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/21.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMForgotWordViewController.h"
#import "FileMangerObject.h"
#import "UIView+Expland.h"
@interface RMForgotWordViewController ()

@end

@implementation RMForgotWordViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self backgroundRequest];
}

- (void)backgroundRequest{
    [RMAFNRequestManager loginBackgroundImageRequestWithBlock:^(NSError *error, BOOL success, id object) {
        if(success){
            RMPublicModel * model = object;
            if(model.status){
                [_login_bg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:LOADIMAGE(@"login_bg", @"jpg")];
            }else{
                
            }
        }else{
            
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];

    [_back_login_btn addTarget:self action:@selector(backLoginAction:) forControlEvents:UIControlEventTouchDown];
    [_sendCodeBtn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchDown];
    [_sure_btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchDown];
    
    _mobileTextField.backgroundColor = [UIColor whiteColor];
    _mobileTextField.backgroundColor = [_mobileTextField.backgroundColor colorWithAlphaComponent:0.6];
    [_mobileTextField drawCorner:UIRectCornerTopRight|UIRectCornerBottomRight withFrame:CGRectMake(0, 0, kScreenWidth-_mobileTextField.frame.origin.x-77, _mobileTextField.frame.size.height)];
    
    _codeTextField.backgroundColor = [UIColor whiteColor];
    _codeTextField.backgroundColor = [_codeTextField.backgroundColor colorWithAlphaComponent:0.6];
    [_codeTextField drawCorner:UIRectCornerTopRight|UIRectCornerBottomRight withFrame:CGRectMake(0, 0, kScreenWidth-_codeTextField.frame.origin.x-77, _codeTextField.frame.size.height)];
    
    _passTextField.backgroundColor = [UIColor whiteColor];
    _passTextField.backgroundColor = [_passTextField.backgroundColor colorWithAlphaComponent:0.6];
    [_passTextField drawCorner:UIRectCornerTopRight|UIRectCornerBottomRight withFrame:CGRectMake(0, 0, kScreenWidth-_passTextField.frame.origin.x-77, _passTextField.frame.size.height)];
    
    [_sendCodeBtn setBackgroundColor:[UIColor colorWithPatternImage:LOADIMAGE(@"red_btn",@"png")]];
    _sendCodeBtn.layer.cornerRadius = 5;
    _sendCodeBtn.clipsToBounds = YES;
    
    [_sure_btn setBackgroundColor:[UIColor colorWithPatternImage:LOADIMAGE(@"red_btn",@"png")]];
    _sure_btn.layer.cornerRadius = 5;
    _sure_btn.clipsToBounds = YES;
}

- (void)backLoginAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)sureAction:(id)sender{
    if(_mobileTextField.text.length==0){
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }else if(_codeTextField.text.length == 0){
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }else if (_passTextField.text.length == 0){
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    
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
    if(_mobileTextField.text.length==0){
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager forgotPwdSendCodeWith:_mobileTextField.text andCallBack:^(NSError *error, BOOL success, id object) {
        RMPublicModel * model = (RMPublicModel *)object;
        if(error){
            NSLog(@"%@",error);
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success&&model.status){
            _sendCodeBtn.enabled = NO;
            //button type要 设置成custom 否则会闪动
            [_sendCodeBtn startWithSecond:60];
            
            [_sendCodeBtn didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                return title;
            }];
            [_sendCodeBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                return @"重新获取";
            }];
            [MBProgressHUD showSuccess:model.msg toView:self.view];
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
