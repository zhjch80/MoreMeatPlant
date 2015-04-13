//
//  RMBaseWebViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseWebViewController.h"

@interface RMBaseWebViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    BOOL isFirstAppear;
    BOOL isLoad;
}
@property (nonatomic, copy) NSString * mTitle;
@property (nonatomic, copy) NSString * mUrl;

@property (nonatomic, strong) UITableView * mTableView;

@end

@implementation RMBaseWebViewController
@synthesize mWebView, mTitle, mUrl, mTableView;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isLoad){
        if (isFirstAppear){
            [self setCustomNavTitle:mTitle];
            [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0]];
            isFirstAppear = NO;
        }
    }else{
        [self setCustomNavTitle:mTitle];
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
    [self setCustomNavTitle:@"详情"];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    [self setCustomNavTitle:@""];
    isFirstAppear = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"baseWeb";
    UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - 方式一

/**
 *  @method 请求网络url 整个直接展示webView
 *  @param      url         请求的url
 *  @param      title       custom Title
 *  @param      load        是否请求网络
 */
- (void)loadRequestWithUrl:(NSString *)url
                 withTitle:(NSString *)title
         withisloadRequest:(BOOL)load {
    mTitle = title;
    mUrl = url;
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    
    self.mWebView = [[UIWebView alloc] init];
    self.mWebView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.mWebView.delegate = self;
    self.mWebView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:self.mWebView];
    
    mTableView.tableHeaderView = headerView;
    
    isLoad = load;
}

#pragma mark - 方式二

/**
 *  @method 加载html body
 *  @param      auto_id         标识
 *  @param      load            是否请求网络
 *  @param      title           custom Title
 */
- (void)loadHtmlWithAuto_id:(NSString *)auto_id
                  withTitle:(NSString *)title
          withisloadRequest:(BOOL)load {
    mTitle = title;
    [self requestHtmlBodyWithAuto_id:auto_id];
    isLoad = load;
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

- (void)requestHtmlBodyWithAuto_id:(NSString *)auto_id {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getNewsDetailsWithAuto_id:auto_id callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            UILabel * headerView = [[UILabel alloc] init];
            headerView.frame = CGRectMake(0, 0, kScreenHeight, 60);
            headerView.backgroundColor = [UIColor clearColor];
            headerView.numberOfLines = 2;
            headerView.font = FONT_1(15.0);
            
            NSString * _name = [NSString stringWithFormat:@"  %@",[[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_name"]];
            NSString * _time = [NSString stringWithFormat:@"  %@",[[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"create_time"]];
            
            headerView.text = [NSString stringWithFormat:@"%@\n%@",_name,_time];
            
            NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",_name,_time]];
            
            [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(_name.length, _time.length+1)];
            
            [oneAttributeStr addAttribute:NSFontAttributeName value:FONT_1(14.0) range:NSMakeRange(_name.length, _time.length+1)];
            
            headerView.attributedText = oneAttributeStr;
            
            mTableView.tableHeaderView = headerView;
            
            UIView * footerView = [[UIView alloc] init];
            self.mWebView = [[UIWebView alloc] init];
            self.mWebView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 124);
            self.mWebView.delegate = self;
            self.mWebView.backgroundColor = [UIColor redColor];
            [footerView addSubview:self.mWebView];
            
            [mWebView loadHTMLString:[[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_body"] baseURL:nil];
            
            mTableView.tableFooterView = footerView;

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
