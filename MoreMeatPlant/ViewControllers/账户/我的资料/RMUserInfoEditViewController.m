//
//  RMUserInfoEditViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMUserInfoEditViewController.h"

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
    _signatureT.text = __model.contentQm?__model.contentQm:@"暂无";
    _mobileT.text = __model.contentMobile;
    _apliyT.text = __model.zfbNo;
}
//修改资料请求有问题
- (void)commit{
    [RMAFNRequestManager myInfoModifyRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Type:nil AlipayNo:_apliyT.text Signature:[_signatureT.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] Dic:nil andCallBack:^(NSError *error, BOOL success, id object) {
        
    }];
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
