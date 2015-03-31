//
//  RMPlantWithSaleDetailsViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantWithSaleDetailsViewController.h"
#import "RMPlantWithSaleHeaderView.h"
#import "RMBottomView.h"
#import "RMPlantWithSaleDetailsCell.h"
#import "CycleScrollView.h"
#import "RMBaseView.h"
#import "RMMerchantsShopViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface RMPlantWithSaleDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,BottomDelegate,PlantWithSaleHeaderViewDelegate,PlantWithSaleDetailsDelegate,NJKWebViewProgressDelegate>{
    BOOL isCanLoadWeb;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (nonatomic, strong) RMPlantWithSaleHeaderView * headerView;;
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) CycleScrollView * cycleView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) NSMutableArray * topDataArr;
@property (nonatomic, strong) RMBaseView * footerView;

@end

@implementation RMPlantWithSaleDetailsViewController
@synthesize headerView, mTableView, dataArr, cycleView, topDataArr, footerView, auto_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    topDataArr = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", nil];
    
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    [self loadHeaderView];
    
    [self loadBottomView];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 40) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    
    [self loadTableHeaderView];
    
    [self loadTableFooterView];
}

- (void)loadTableHeaderView {
    if ([topDataArr count] == 1){
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        image.userInteractionEnabled = YES;
        image.backgroundColor = [UIColor yellowColor];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
        title.backgroundColor = [UIColor clearColor];
        title.userInteractionEnabled = YES;
        title.numberOfLines = 1;
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont boldSystemFontOfSize:24.0];
        title.text = [NSString stringWithFormat:@"page index: %d",1];
        title.adjustsFontSizeToFitWidth = YES;
        [title sizeToFit];
        title.center = image.center;
        [image addSubview:title];
        
        mTableView.tableHeaderView = image;
    }else{
        NSMutableArray *displayArr = [@[] mutableCopy];
        
        for (NSInteger i=0; i<[topDataArr count]; i++) {
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
            image.userInteractionEnabled = YES;
            image.backgroundColor = [UIColor cyanColor];
            
            UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
            title.backgroundColor = [UIColor clearColor];
            title.userInteractionEnabled = YES;
            title.numberOfLines = 1;
            title.textColor = [UIColor whiteColor];
            title.font = [UIFont boldSystemFontOfSize:24.0];
            title.text = [NSString stringWithFormat:@"page index: %ld",(long)i];
            title.adjustsFontSizeToFitWidth = YES;
            [title sizeToFit];
            title.center = image.center;
            [image addSubview:title];
            
            [displayArr addObject:image];
        }
        
        __block RMPlantWithSaleDetailsViewController * blockSelf = self;
        
        cycleView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) animationDuration:3];
        cycleView.backgroundColor = [UIColor whiteColor];
        cycleView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return displayArr[pageIndex];
        };
        self.cycleView.totalPagesCount = ^NSInteger(void){
            return [blockSelf.topDataArr count];
        };
        self.cycleView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"select index %ld",(long)pageIndex);
        };
        mTableView.tableHeaderView = self.cycleView;
    }
}

- (void)loadTableFooterView {
    footerView = [[[NSBundle mainBundle] loadNibNamed:@"RMBaseView" owner:nil options:nil] objectAtIndex:0];
    footerView.mWebView.scrollView.bounces = NO;
    footerView.mWebView.scrollView.scrollEnabled = NO;
    footerView.mWebView.scrollView.showsHorizontalScrollIndicator = NO;
    footerView.mWebView.scrollView.showsVerticalScrollIndicator = NO;
    mTableView.tableFooterView = footerView;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    footerView.mWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    [footerView.mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
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

#pragma mark - NJKWebViewProgressDelegate

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        _progressView.progress = 0;
        [UIView animateWithDuration:0.27 animations:^{
            _progressView.alpha = 1.0;
        }];
    }
    
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:progress - _progressView.progress options:0 animations:^{
            _progressView.alpha = 0.0;
            
            // webView彻底加载完
            CGFloat height = [[footerView.mWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];//document.body.clientHeight
            footerView.frame = CGRectMake(0, 0, kScreenWidth, height+50);
            footerView.mWebView.frame = CGRectMake(0, 0, kScreenWidth, height+50);
            mTableView.tableFooterView= footerView;
        } completion:nil];
    }
    
    [_progressView setProgress:progress animated:NO];
}

#pragma mark -

- (void)loadHeaderView {
    headerView = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleHeaderView" owner:nil options:nil] objectAtIndex:0];
    headerView.delegate = self;
    [headerView.userHeader.layer setCornerRadius:20.0f];
    [self.view addSubview:headerView];
}

- (void)intoShopMethodWithBtn:(UIButton *)button {
    RMMerchantsShopViewController * merchantsShopCtl = [[RMMerchantsShopViewController alloc] init];
    [self.navigationController pushViewController:merchantsShopCtl animated:YES];
}

- (void)loadBottomView {
    RMBottomView * bottomView = [[RMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_backup", @"img_collectiom", @"img_buy", @"img_share", nil]];
    [self.view addSubview:bottomView];
}

- (void)bottomMethodWithTag:(NSInteger)tag {
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

#pragma mark - 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifierStr = @"plantWithSaleDetailsIdentifier";
    RMPlantWithSaleDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleDetailsCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0f;
}

- (void)plantWithSaleCellMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 101:{
            NSLog(@"减");
            break;
        }
        case 102:{
            NSLog(@"加");
            break;
        }
        case 103:{
            NSLog(@"立即购买");
            break;
        }
        case 104:{
            NSLog(@"加入购物车");
            break;
        }
        case 105:{
            NSLog(@"联系掌柜");
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
