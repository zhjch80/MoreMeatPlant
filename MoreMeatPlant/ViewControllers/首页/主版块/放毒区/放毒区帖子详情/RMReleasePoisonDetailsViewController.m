//
//  RMReleasePoisonDetailsViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMReleasePoisonDetailsViewController.h"
#import "RMReleasePoisonBottomView.h"
#import "RMReleasePoisonDetailsCell.h"

@interface RMReleasePoisonDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,ReleasePoisonBottomDelegate,ReleasePoisonDetailsDelegate>{
    BOOL isCanLoadWeb;
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) UIWebView * mWebView;

@end

@implementation RMReleasePoisonDetailsViewController
@synthesize mTableView, dataArr, mWebView;

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    dataArr = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 40) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [self.view addSubview:mTableView];
    
    [self loadBottomView];
    
    [self loadTableHeadView];
}

#pragma mark - 加载底部View

- (void)loadBottomView {
    RMReleasePoisonBottomView * releasePoisonBottomView = [[RMReleasePoisonBottomView alloc] init];
    releasePoisonBottomView.delegate = self;
    releasePoisonBottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    [releasePoisonBottomView loadReleasePoisonDetailsBottom];
    [self.view addSubview:releasePoisonBottomView];
}

- (void)releasePoisonDetailsBottomMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 0:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - tableView headView

- (void)loadTableHeadView {
    mWebView = [[UIWebView alloc] init];
    mWebView.frame = CGRectMake(0, 0, kScreenWidth, 80);
    mWebView.userInteractionEnabled = YES;
    mWebView.scrollView.bounces = YES;
    mWebView.delegate = self;
    [mWebView setBackgroundColor:[UIColor clearColor]];
    [mWebView setOpaque:NO];
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    mWebView.frame = CGRectMake(0, 0, kScreenWidth, height);
    mTableView.tableHeaderView = mWebView;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"------Fail-----");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (!isCanLoadWeb){
        isCanLoadWeb = !isCanLoadWeb;
        return isCanLoadWeb;
    }else
    return NO;
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        static NSString * identifierStr = @"ReleasePoisonDetailsIdentifier_1";
        RMReleasePoisonDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_1" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        return cell;

    }else if (indexPath.row == 1){
        static NSString * identifierStr = @"ReleasePoisonDetailsIdentifier_2";
        RMReleasePoisonDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_2" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        return cell;

    }else {
        static NSString * identifierStr = @"ReleasePoisonDetailsIdentifier_3";
        RMReleasePoisonDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_3" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
//        [cell setFrame:cell.cellFrame];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 | indexPath.row == 1){
        return 50.0;
    }else{
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return 100.0;//cell.frame.size.height;
    }
}

#pragma mark - 跳转到广告位置

- (void)jumpPromoteMethod:(RMImageView *)image {
    NSLog(@"跳到广告位置");
}

#pragma mark - 给此帖点赞

- (void)addPraiseMethod:(RMImageView *)image {
    NSLog(@"点赞👍");
}

#pragma mark - 点击评论人的头像

- (void)userHeadMethod:(RMImageView *)image {
    NSLog(@"点击头像事件");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
