//
//  RMBaseWebViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseWebViewController.h"

@interface RMBaseWebViewController ()<UIWebViewDelegate>{
    BOOL isFirstAppear;
}
@property (nonatomic, copy) NSString * mTitle;
@property (nonatomic, copy) NSString * mUrl;

@end

@implementation RMBaseWebViewController
@synthesize mWebView, mTitle, mUrl;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstAppear){
        [self setCustomNavTitle:mTitle];
        [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0]];
        isFirstAppear = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mWebView = [[UIWebView alloc] init];
    self.mWebView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    self.mWebView.delegate = self;
    [self.view addSubview:self.mWebView];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    [self setCustomNavTitle:@""];
    isFirstAppear = YES;
}

- (void)loadRequestWithUrl:(NSString *)url withTitle:(NSString *)title{
    mTitle = title;
    mUrl = url;
}

#pragma mark -

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

#pragma mark -

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 2:{
            
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
