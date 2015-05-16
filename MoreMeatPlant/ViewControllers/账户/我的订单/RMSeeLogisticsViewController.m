//
//  RMSeeLogisticsViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/6.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMSeeLogisticsViewController.h"

@interface RMSeeLogisticsViewController ()<UIWebViewDelegate>

@end

@implementation RMSeeLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"物流查询"];
    self.mainWebView.scalesPageToFit = NO;
    self.mainWebView.opaque = NO;
    self.mainWebView.backgroundColor = [UIColor clearColor];
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];

    NSString * url = [RMAFNRequestManager getWuliuUrlWithExpressName:[self.express_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] no:self.express_no];
    NSLog(@"物流:%@",url);
    
    
    _mainWebView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showHint:@"加载失败!"];
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
