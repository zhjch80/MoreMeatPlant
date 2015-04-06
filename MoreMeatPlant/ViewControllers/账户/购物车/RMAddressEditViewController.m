//
//  RMAddressEditViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/11.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMAddressEditViewController.h"

@interface RMAddressEditViewController ()

@end

@implementation RMAddressEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"新建地址"];
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    if(__model){
        _content_name.text = __model.contentName;
        _content_mobile.text = __model.contentMobile;
        _content_detail.text = __model.contentAddress;
    }
    
    [_sureBtn addTarget:self action:@selector(sureCommit) forControlEvents:UIControlEventTouchDown];
}

- (void)sureCommit{
    if(_content_name.text.length == 0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入联系人姓名" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }else if(_content_mobile.text.length == 0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入联系人手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }else if (_content_detail.text.length == 0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入联系人地址" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager addressEditOrNewPostWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Autoid:__model.auto_id ContactName:[_content_name.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] Mobile:_content_mobile.text Address:[_content_detail.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * model = object;
            [MBProgressHUD showSuccess:model.msg toView:self.view];
//            if(self.completedCallback){
//                _completedCallback();
//            }
            if(self.delegate){
                [self.delegate RMAddressEditViewCompleted];
                [self.navigationController popViewControllerAnimated:YES];
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
