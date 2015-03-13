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
#import "RMTableHeadView.h"
#import "RMBaseWebViewController.h"
#import "RMCommentsView.h"

@interface RMReleasePoisonDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,ReleasePoisonBottomDelegate,ReleasePoisonDetailsDelegate,TableHeadDelegate,CommentsViewDelegate>{
    BOOL isCanLoadWeb;
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) RMTableHeadView * tableHeadView;
@property (nonatomic, strong) RMCommentsView * commentsView;

@end

@implementation RMReleasePoisonDetailsViewController
@synthesize mTableView, dataArr, tableHeadView, commentsView;

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
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            NSLog(@"收藏");
            break;
        }
        case 2:{
            commentsView = [[RMCommentsView alloc] init];
            commentsView.delegate = self;
            commentsView.backgroundColor = [UIColor clearColor];
            commentsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [commentsView loadCommentsView];
            [self.view addSubview:commentsView];
            break;
        }
        case 3:{
            NSLog(@"分享");
            break;
        }
            
        default:
            break;
    }
}

- (void)loadTableHeadView {
    tableHeadView = [[[NSBundle mainBundle] loadNibNamed:@"RMTableHeadView" owner:nil options:nil] objectAtIndex:0];
    tableHeadView.detailsWebView.scrollView.bounces = NO;
    tableHeadView.detailsWebView.scrollView.showsVerticalScrollIndicator = NO;
    tableHeadView.detailsWebView.scrollView.showsHorizontalScrollIndicator = NO;
    tableHeadView.detailsWebView.scrollView.scrollEnabled = NO;
    [tableHeadView.detailsReportBtn.layer setCornerRadius:8.0f];
    [tableHeadView.detailsUserHead.layer setCornerRadius:20.0f];
    [tableHeadView.detailsUserHead addTarget:self WithSelector:@selector(userHeaderClick:)];
    tableHeadView.delegate = self;
    tableHeadView.detailsWebView.delegate = self;
    mTableView.tableHeaderView = tableHeadView;

    [tableHeadView.detailsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    tableHeadView.frame = CGRectMake(0, 0, kScreenWidth, 120 + height+50);
    tableHeadView.detailsWebView.frame = CGRectMake(0, 120, kScreenWidth, height+50);
    mTableView.tableHeaderView = tableHeadView;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"失败 error:%@",error);
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
    }else if (indexPath.row < 6){
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
    }else{
        static NSString * identifierStr = @"ReleasePoisonDetailsIdentifier_4";
        RMReleasePoisonDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_4" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        cell.comments_2_1.text = @"Kucyoung贝贝\n在哪里买的呀，给个链接呗！";
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:@"Kucyoung贝贝\n在哪里买的呀，给个链接呗！"];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:0.18 blue:0.45 alpha:1] range:NSMakeRange(0, 10)];
        cell.comments_2_1.attributedText = oneAttributeStr;
        
        //        [cell setFrame:cell.cellFrame];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 | indexPath.row == 1){
        return 50.0;
    }else if (indexPath.row < 6){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return 100.0;//cell.frame.size.height;
    }else{
        return 140.0;
    }
}

#pragma mark - 跳转到广告位置

- (void)jumpPromoteMethod:(RMImageView *)image {
    RMBaseWebViewController * baseWebCtl = [[RMBaseWebViewController alloc] init];
    [baseWebCtl loadRequestWithUrl:@"" withTitle: @"广告位置"];
    [self.navigationController pushViewController:baseWebCtl animated:YES];
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

#pragma mark - 回复帖子

- (void)replyMethod:(UIButton *)button {
    NSLog(@"回复帖子");
}

#pragma mark - 帖主头像

- (void)userHeaderClick:(RMImageView *)image {
    NSLog(@"帖主 👦");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
