//
//  RMRegisterViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/21.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMRegisterViewController.h"
#import "FileMangerObject.h"
#import "AppDelegate.h"
#import "UIView+Expland.h"
#import "RegularManager.h"
@interface RMRegisterViewController ()

@end

@implementation RMRegisterViewController

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
    
    [_user_btn addTarget:self action:@selector(selectRegisterType:) forControlEvents:UIControlEventTouchDown];
    _user_btn.tag = 2014;
    [_corp_btn addTarget:self action:@selector(selectRegisterType:) forControlEvents:UIControlEventTouchDown];
    _corp_btn.tag = 2015;
    
    [_back_login_btn addTarget:self action:@selector(backLoginAction:) forControlEvents:UIControlEventTouchDown];
    
    [_send_code_btn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchDown];
    
    [_sure_btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchDown];
    
    
    _mobileTextField.backgroundColor = [UIColor whiteColor];
    _mobileTextField.backgroundColor = [_mobileTextField.backgroundColor colorWithAlphaComponent:0.6];
    [_mobileTextField drawCorner:UIRectCornerTopRight|UIRectCornerBottomRight withFrame:CGRectMake(0, 0, kScreenWidth-_mobileTextField.frame.origin.x-77, _mobileTextField.frame.size.height)];
    
    _codeTextField.backgroundColor = [UIColor whiteColor];
    _codeTextField.backgroundColor = [_codeTextField.backgroundColor colorWithAlphaComponent:0.6];
    [_codeTextField drawCorner:UIRectCornerTopRight|UIRectCornerBottomRight withFrame:CGRectMake(0, 0, kScreenWidth-_codeTextField.frame.origin.x-77, _codeTextField.frame.size.height)];
    
    _nickTextField.backgroundColor = [UIColor whiteColor];
    _nickTextField.backgroundColor = [_nickTextField.backgroundColor colorWithAlphaComponent:0.6];
    [_nickTextField drawCorner:UIRectCornerTopRight|UIRectCornerBottomRight withFrame:CGRectMake(0, 0, kScreenWidth-_nickTextField.frame.origin.x-77, _nickTextField.frame.size.height)];
    
    _passTextField.backgroundColor = [UIColor whiteColor];
    _passTextField.backgroundColor = [_passTextField.backgroundColor colorWithAlphaComponent:0.6];
    [_passTextField drawCorner:UIRectCornerTopRight|UIRectCornerBottomRight withFrame:CGRectMake(0, 0, kScreenWidth-_passTextField.frame.origin.x-77, _passTextField.frame.size.height)];
    
    [_sure_btn setBackgroundColor:[UIColor colorWithPatternImage:LOADIMAGE(@"red_btn",@"png")]];
    _sure_btn.layer.cornerRadius = 5;
    _sure_btn.clipsToBounds = YES;
    
    [_send_code_btn setBackgroundColor:[UIColor colorWithPatternImage:LOADIMAGE(@"red_btn",@"png")]];
    _send_code_btn.layer.cornerRadius = 5;
    _send_code_btn.clipsToBounds = YES;
    
    
}

- (void)backLoginAction:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sureAction:(id)sender{
    //personal  corp
    if(_mobileTextField.text.length==0 || ![RegularManager validateMobile:_mobileTextField.text]){
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }else if(_codeTextField.text.length == 0){
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }else if (_nickTextField.text.length == 0){
        [MBProgressHUD showError:@"请输入昵称" toView:self.view];
        return;
    }else if (_passTextField.text.length == 0){
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * type = nil;
    if(isCorp){
        type = @"corp";
    }else{
        type = @"personal";
    }
    
    [RMAFNRequestManager registerRequestWithUser:_mobileTextField.text Pwd:[FileMangerObject md5:_passTextField.text] Code:_codeTextField.text Nick:[_nickTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] Type:type Gps:[[RMUserLoginInfoManager loginmanager] coorStr] YPWD:_passTextField.text andCallBack:^(NSError *error, BOOL success, id object) {
        RMPublicModel * model = (RMPublicModel *)object;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(error){
            NSLog(@"%@",error);
        }
        if(success&&model.status){
            [[NSUserDefaults standardUserDefaults] setValue:_mobileTextField.text forKey:UserName];
            [[NSUserDefaults standardUserDefaults] setValue:[FileMangerObject md5:_passTextField.text] forKey:UserPwd];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LoginState];
            [[NSUserDefaults standardUserDefaults] setValue:_passTextField.text forKey:UserYPWD];
            if(isCorp){//商家会员
                [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:UserType];
            }else{//用户会员
               [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:UserType];
            }
            
            
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
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:model.msg toView:self.view];
    }];
}

- (void)selectRegisterType:(id)sender{
    UIButton * button = (UIButton *)sender;
    if(button.tag == 2014){//点击普通用户
        [_user_btn setBackgroundImage:[UIImage imageNamed:@"login_select_bg"] forState:UIControlStateNormal];
        [_corp_btn setBackgroundImage:[UIImage imageNamed:@"login_no_select_bg"] forState:UIControlStateNormal];
        isCorp = NO;
    }else{
        [_user_btn setBackgroundImage:[UIImage imageNamed:@"login_no_select_bg"] forState:UIControlStateNormal];
        [_corp_btn setBackgroundImage:[UIImage imageNamed:@"login_select_bg"] forState:UIControlStateNormal];
        isCorp = YES;
    }
}

- (void)sendCodeAction:(id)sender{
    if(_mobileTextField.text.length==0){
    
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager registerSendCodeWith:_mobileTextField.text andCallBack:^(NSError *error, BOOL success, id object) {
        RMPublicModel * model = (RMPublicModel *)object;
        if(error){
            NSLog(@"%@",error);
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success&&model.status){
            _send_code_btn.enabled = NO;
            //button type要 设置成custom 否则会闪动
            [_send_code_btn startWithSecond:60];
            
            [_send_code_btn didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                return title;
            }];
            [_send_code_btn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                return @"重新获取";
            }];
        }
        [MBProgressHUD showSuccess:model.msg toView:self.view];
    }];
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
