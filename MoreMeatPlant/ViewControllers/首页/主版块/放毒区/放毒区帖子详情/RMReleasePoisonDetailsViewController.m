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
@property (nonatomic, strong) UIView * tableHeadView;

@end

@implementation RMReleasePoisonDetailsViewController
@synthesize mTableView, dataArr, tableHeadView;

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

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"-----start----");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    webView.frame = CGRectMake(0, 80, kScreenWidth, height);
    NSIndexPath * indexPath = [NSIndexPath indexPathWithIndex:0];
    UITableViewCell *cell = [self tableView:mTableView cellForRowAtIndexPath:indexPath];
    [cell setFrame:CGRectMake(0, 80, kScreenWidth, height + 80)];
    [mTableView reloadData];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"------Fail-----");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (!isCanLoadWeb){
        isCanLoadWeb = !isCanLoadWeb;
        return isCanLoadWeb;
    }
    return NO;
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        static NSString * identifierStr = @"ReleasePoisonDetailsIdentifier_0";
        RMReleasePoisonDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_0" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        cell.frame = CGRectMake(0, 0, kScreenWidth, 300);
        cell.mWebView.backgroundColor = [UIColor blackColor];
        cell.mWebView.frame = CGRectMake(0, 100, 320, 100);
        
#if 0
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [cell.mWebView loadHTMLString:html baseURL:baseURL];
 
#else
//        NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [cell.mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://news.baidu.com"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0]];
    
#endif
        
        return cell;
    }else if (indexPath.row == 1){
        static NSString * identifierStr = @"ReleasePoisonDetailsIdentifier_1";
        RMReleasePoisonDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_1" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        return cell;
    }else if (indexPath.row == 2){
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
    if (indexPath.row == 0){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else if (indexPath.row == 1 | indexPath.row == 2){
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

#pragma mark - 举报此帖

- (void)reportMethod:(UIButton *)button {
    NSLog(@"举报此帖");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
