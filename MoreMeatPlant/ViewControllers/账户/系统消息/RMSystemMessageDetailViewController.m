//
//  RMSystemMessageDetailViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/1.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMSystemMessageDetailViewController.h"

@interface RMSystemMessageDetailViewController ()

@end

@implementation RMSystemMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self setCustomNavTitle:@"消息详情"];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    [self request];
}

- (void)request{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager systemMessageDetailWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Auto_id:self.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
        if(success){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            RMPublicModel * model = object;
            _titleL.text = model.msg_title;
            [_mwebView loadHTMLString:model.msg_text baseURL:nil];
            _timeL.text = model.create_time;
        }else{
            [self showHint:object];
        }
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

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
