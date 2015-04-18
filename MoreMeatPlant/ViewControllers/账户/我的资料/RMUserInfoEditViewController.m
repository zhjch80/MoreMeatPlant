//
//  RMUserInfoEditViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMUserInfoEditViewController.h"
#import "UIAlertView+Expland.h"
@interface RMUserInfoEditViewController ()

@end

@implementation RMUserInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"资料编辑"];
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    _nickT.text = __model.contentName;
    _signatureT.text = Str_Objc(__model.contentQm, @"什么也没写...");
    _mobileT.text = __model.contentMobile;
    _apliyT.text = __model.zfbNo;
    [_sureModifyBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchDown];
}
//修改资料请求有问题
- (void)commit{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager myInfoModifyRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Type:nil AlipayNo:_apliyT.text Signature:[_signatureT.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] Dic:nil andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * model = object;
            if(model.status){
                __model.contentQm = _signatureT.text;
                __model.zfbNo = _apliyT.text;
                [[NSNotificationCenter defaultCenter] postNotificationName:RMRequestMemberInfoAgainNotification object:__model];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:model.msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
                [alert handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
                    [self navgationBarButtonClick:nil];
                }];
                [alert show];

            }else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:model.msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];

            }
            
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
