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
@interface RMRegisterViewController ()

@end

@implementation RMRegisterViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc{
//    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
//    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];

    
    [_user_btn addTarget:self action:@selector(selectRegisterType:) forControlEvents:UIControlEventTouchDown];
    _user_btn.tag = 2014;
    [_corp_btn addTarget:self action:@selector(selectRegisterType:) forControlEvents:UIControlEventTouchDown];
    _corp_btn.tag = 2015;
    
    [_back_login_btn addTarget:self action:@selector(backLoginAction:) forControlEvents:UIControlEventTouchDown];
    
    [_send_code_btn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchDown];
    
    [_sure_btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchDown];
}

- (void)backLoginAction:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sureAction:(id)sender{
    //personal  corp
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * type = nil;
    if(isCorp){
        type = @"corp";
    }else{
        type = @"personal";
    }
    
    [RMAFNRequestManager registerRequestWithUser:_mobileTextField.text Pwd:[FileMangerObject md5:_passTextField.text] Code:_codeTextField.text Nick:_nickTextField.text Type:type Gps:[[RMUserLoginInfoManager loginmanager] coorStr] andCallBack:^(NSError *error, BOOL success, id object) {
        RMPublicModel * model = (RMPublicModel *)object;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(error){
            NSLog(@"%@",error);
        }
        if(success&&model.status){
            [[NSUserDefaults standardUserDefaults] setValue:_mobileTextField.text forKey:UserName];
            [[NSUserDefaults standardUserDefaults] setValue:[FileMangerObject md5:_passTextField.text] forKey:UserPwd];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LoginState];
            if(isCorp){//商家会员
                [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:UserType];
            }else{//用户会员
               [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:UserType];
            }
            
            
            NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
            NSString * pwd = [[NSUserDefaults standardUserDefaults] objectForKey:UserPwd];
            NSString * iscorp = [[NSUserDefaults standardUserDefaults] objectForKey:UserType];
            NSString * coorstr = [[NSUserDefaults standardUserDefaults] objectForKey:UserCoor];
            NSLog(@"登录用户类型：%@",iscorp);
            
            [[RMUserLoginInfoManager loginmanager] setState:YES];
            [[RMUserLoginInfoManager loginmanager] setUser:user];
            [[RMUserLoginInfoManager loginmanager] setPwd:pwd];
            [[RMUserLoginInfoManager loginmanager] setIsCorp:iscorp];
            [[RMUserLoginInfoManager loginmanager] setCoorStr:coorstr];
            
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager registerSendCodeWith:_mobileTextField.text andCallBack:^(NSError *error, BOOL success, id object) {
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
