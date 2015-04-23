//
//  RMReleasePoisonDetailsViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMReleasePoisonDetailsViewController.h"
#import "RMBottomView.h"
#import "RMReleasePoisonDetailsCell.h"
#import "RMTableHeadView.h"
#import "RMBaseWebViewController.h"
#import "RMCommentsView.h"
#import "NSString+TimeInterval.h"
#import "UIImage+LK.h"
#import "RefreshControl.h"
#import "RefreshView.h"

//#import "NJKWebViewProgress.h"
//#import "NJKWebViewProgressView.h"

@interface RMReleasePoisonDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,BottomDelegate,ReleasePoisonDetailsDelegate,TableHeadDelegate,CommentsViewDelegate,RefreshControlDelegate>{
    BOOL isCanLoadWeb;
//    NJKWebViewProgressView *_progressView;
//    NJKWebViewProgress *_progressProxy;
    
    BOOL isFirstViewDidAppear;
    BOOL isRefresh;
    NSInteger pageCount;
    BOOL isLoadComplete;
    NSInteger praiseCellCount;
    CGFloat offsetY;
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataCommentArr;
@property (nonatomic, strong) RMTableHeadView * tableHeadView;
@property (nonatomic, strong) RMPublicModel * dataModel;
@property (nonatomic, strong) NSMutableArray * advertisingArr;
@property (nonatomic, strong) RefreshControl * refreshControl;
@property (nonatomic, strong) RMBottomView * bottomView;

@end

@implementation RMReleasePoisonDetailsViewController
@synthesize mTableView, tableHeadView, dataCommentArr, dataModel, advertisingArr,refreshControl, bottomView;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isFirstViewDidAppear) {
        [self requestDetatils];
        isFirstViewDidAppear = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[RMReleasePoisonDetailsViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[RMReleasePoisonDetailsViewController class]];
    
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    dataModel = [[RMPublicModel alloc] init];
    
    dataCommentArr = [[NSMutableArray alloc] init];
    advertisingArr = [[NSMutableArray alloc] init];

    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 40) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:mTableView delegate:self];
    refreshControl.topEnabled = NO;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    
    pageCount = 1;
    isRefresh = YES;
    
    praiseCellCount = 0;
    
    [self loadBottomView];
}

#pragma mark - 加载底部View

- (void)loadBottomView {
    bottomView = [[RMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_backup", @"img_collectiom", @"img_postMessage@2x", nil]];
    [self.view addSubview:bottomView];
}

- (void)bottomMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 0:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:{
            if (![RMUserLoginInfoManager loginmanager].state){
                NSLog(@"去登录.....");
                return;
            }
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [RMAFNRequestManager getMembersCollectWithCollect_id:dataModel.auto_id withContent_type:@"1" withID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd callBack:^(NSError *error, BOOL success, id object) {
                if (error){
                    NSLog(@"error:%@",error);
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    return ;
                }
                
                if (success){
                    [self showHint:[object objectForKey:@"msg"]];
                    UIButton * btn = (UIButton *)[bottomView viewWithTag:1];
                    [btn setBackgroundImage:LOADIMAGE(@"img_asced", kImageTypePNG) forState:UIControlStateNormal];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }else{
                    [self showHint:[object objectForKey:@"msg"]];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            }];
            break;
        }
        case 2:{
            if (![RMUserLoginInfoManager loginmanager].state){
                NSLog(@"去登录.....");
                return;
            }
            
            RMCommentsView * commentsView = [[RMCommentsView alloc] init];
            commentsView.delegate = self;
            commentsView.backgroundColor = [UIColor clearColor];
            commentsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            commentsView.requestType = kRMReleasePoisonListComment;
            commentsView.code = dataModel.auto_id;
            [commentsView loadCommentsViewWithReceiver:[NSString stringWithFormat:@"  评论:%@",[dataModel.members objectForKey:@"member_name"]] withImage:nil];
            [self.view addSubview:commentsView];
            break;
        }
            
        default:
            break;
    }
}

- (void)loadTableHeadView {
    tableHeadView = [[[NSBundle mainBundle] loadNibNamed:@"RMTableHeadView" owner:nil options:nil] objectAtIndex:0];
    tableHeadView.frame = CGRectMake(0, 0, kScreenWidth, 120);
    tableHeadView.detailsPointLine.frame = CGRectMake(10, 60, kScreenWidth - 20, 1);
    tableHeadView.detailsReportBtn.frame = CGRectMake(kScreenWidth - 50, 50, 40, 21);
    [tableHeadView.detailsReportBtn.layer setCornerRadius:8.0f];
    [tableHeadView.detailsUserHead.layer setCornerRadius:20.0f];
    tableHeadView.detailsUserHead.clipsToBounds = YES;
    [tableHeadView.detailsUserHead addTarget:self withSelector:@selector(userHeaderClick:)];
    tableHeadView.delegate = self;
    
    tableHeadView.detailsTitle.text = dataModel.content_name;
    tableHeadView.detailsTime.text = dataModel.create_time;
    tableHeadView.detailsUserNameTime.text = [NSString stringWithFormat:@"%@ %@",[dataModel.members objectForKey:@"member_name"],[[NSString stringWithFormat:@"%@:00",dataModel.create_time] intervalSinceNow]];
    tableHeadView.detailsLocation.text = @"正在定位. . .";
    [tableHeadView.detailsUserHead sd_setImageWithURL:[NSURL URLWithString:[dataModel.members objectForKey:@"content_face"]] placeholderImage:nil];

    offsetY = 0;
    offsetY = offsetY + 120;
    
    if ([dataModel.body isKindOfClass:[NSNull class]]){
        
    }else{
        NSInteger count = [dataModel.body count];
        
        for (NSInteger i=0; i<count; i++) {
            UILabel * bodyStr = [[UILabel alloc] init];
            CGFloat bodyHeight = 0;
            
            if ([[[dataModel.body objectAtIndex:i] objectForKey:@"content_body"] isEqualToString:@""]){
                bodyStr.frame = CGRectMake(0, 0, 0, 0);
            }else{
                bodyHeight = [UtilityFunc boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 0) font:[UIFont systemFontOfSize:15.0] text:[[dataModel.body objectAtIndex:i] objectForKey:@"content_body"]].height;
                
                bodyStr.backgroundColor = [UIColor clearColor];
                bodyStr.text = [[dataModel.body objectAtIndex:i] objectForKey:@"content_body"];
                bodyStr.numberOfLines = 0;
                bodyStr.font = [UIFont systemFontOfSize:15.0];
                bodyStr.frame = CGRectMake(10, offsetY + 10, kScreenWidth - 20, bodyHeight);
                [tableHeadView addSubview:bodyStr];
            }
         
            offsetY = offsetY + bodyStr.frame.size.height + 10;
            
            UIImageView * imageView = [[UIImageView alloc] init];
            
            NSRange substr = [[[dataModel.body objectAtIndex:i] objectForKey:@"content_img"] rangeOfString:@".gif"];
            if (substr.location != NSNotFound) {

            }else{
                CGSize size = [UIImage downloadImageSizeWithURL:[[dataModel.body objectAtIndex:i] objectForKey:@"content_img"]];
                CGFloat height = size.height/size.width * kScreenWidth;
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:[[dataModel.body objectAtIndex:i] objectForKey:@"content_img"]] placeholderImage:nil];
                
                [imageView setFrame:CGRectMake(0, 10 + offsetY, kScreenWidth, height)];
                
                [tableHeadView addSubview:imageView];
                
                offsetY = offsetY + imageView.frame.size.height + 10;
            }
        }
    }

    tableHeadView.frame = CGRectMake(0, 0, kScreenWidth, offsetY);
    mTableView.tableHeaderView = tableHeadView;
    
    praiseCellCount = 1;
    [mTableView reloadData];

//    tableHeadView.detailsWebView.scrollView.bounces = NO;
//    tableHeadView.detailsWebView.scrollView.showsVerticalScrollIndicator = NO;
//    tableHeadView.detailsWebView.scrollView.showsHorizontalScrollIndicator = NO;
//    tableHeadView.detailsWebView.scrollView.scrollEnabled = NO;
//    tableHeadView.detailsWebView.delegate = self;
    
//    _progressProxy = [[NJKWebViewProgress alloc] init];
//    tableHeadView.detailsWebView.delegate = _progressProxy;
//    _progressProxy.webViewProxyDelegate = self;
//    _progressProxy.progressDelegate = self;
//    
//    [tableHeadView.detailsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0]];
}

//- (void)webViewDidStartLoad:(UIWebView *)webView{
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    NSLog(@"失败 error:%@",error);
//}
//
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    if (!isCanLoadWeb){
//        isCanLoadWeb = !isCanLoadWeb;
//        return isCanLoadWeb;
//    }
//    return NO;
//}
//
//#pragma mark - NJKWebViewProgressDelegate
//
//-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
//    if (progress == 0.0) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        _progressView.progress = 0;
//        [UIView animateWithDuration:0.27 animations:^{
//            _progressView.alpha = 1.0;
//        }];
//    }
//    
//    if (progress == 1.0) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        [UIView animateWithDuration:0.27 delay:progress - _progressView.progress options:0 animations:^{
//            _progressView.alpha = 0.0;
//            
//            // webView彻底加载完
//            CGFloat height = [[tableHeadView.detailsWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]; //document.body.clientHeight
//            tableHeadView.frame = CGRectMake(0, 0, kScreenWidth, 120 + height);
//            tableHeadView.detailsWebView.frame = CGRectMake(0, 120, kScreenWidth, height);
//            mTableView.tableHeaderView = tableHeadView;
//        } completion:nil];
//    }
//    
//    [_progressView setProgress:progress animated:NO];
//}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataCommentArr count] + [advertisingArr count] + praiseCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        //赞
        static NSString * identifierStr = @"ReleasePoisonDetailsIdentifier_1";
        RMReleasePoisonDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        if (!cell){
            if (IS_IPHONE_6p_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_1_6p" owner:self options:nil] lastObject];
            }else if (IS_IPHONE_6_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_1_6" owner:self options:nil] lastObject];
            }else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_1" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        if ([dataModel.is_top isEqualToString:@"1"]){
            cell.addPraiseImg.image = LOADIMAGE(@"img_zaned", kImageTypePNG);
        }else{
            cell.addPraiseImg.image = LOADIMAGE(@"img_zan", kImageTypePNG);
        }
        cell.praiseCount.text = dataModel.content_top;
        cell.addPraiseImg.indexPath = indexPath;
        return cell;
    }else if (indexPath.row > 0 && indexPath.row <= [advertisingArr count]){
        //广告
        static NSString * identifierStr = @"ReleasePoisonDetailsIdentifier_2";
        RMReleasePoisonDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        if (!cell){
            if (IS_IPHONE_6p_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_2_6p" owner:self options:nil] lastObject];
            }else if (IS_IPHONE_6_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_2_6" owner:self options:nil] lastObject];
            }else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_2" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        RMPublicModel * model = [advertisingArr objectAtIndex:indexPath.row - 1];
        
        [cell.toPromoteImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        cell.toPromoteImg.identifierString = model.member_id;
        return cell;
    }else{
        RMPublicModel * model = [dataCommentArr objectAtIndex:indexPath.row - 1];
        if ([model.returns isKindOfClass:[NSNull class]]){
            //评论
            static NSString * identifierStr = @"ReleasePoisonDetailsIdentifier_3";
            RMReleasePoisonDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
            if (!cell){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_3" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                cell.delegate = self;
            }
            
            [cell.userHead_1 sd_setImageWithURL:[NSURL URLWithString:[dataModel.members objectForKey:@"content_face"]] placeholderImage:nil];

            cell.replyBtn_1.tag = indexPath.row;
            cell.replyBtn_1.parameter_1 = @"评论";
            cell.userName_1.text = [model.members objectForKey:@"member_name"];
            cell.userLocatiom_1.text = @"正在定位...";
            cell.userPostTime_1.text = model.create_time;
            cell.comments_1.text = model.content_body;
            
            CGRect rect = [cell boundingRectCommentWith:model.content_body];
            
            cell.comments_1.frame = CGRectMake(cell.comments_1.frame.origin.x, cell.comments_1.frame.origin.y, rect.size.width, rect.size.height);
            
            [cell setFrame:CGRectMake(0, 0, kScreenWidth, cell.comments_1.frame.origin.y + cell.comments_1.frame.size.height + 5)];

            cell.line_1.frame = CGRectMake(0, cell.frame.size.height-1, kScreenWidth, 1);
            return cell;
        }else{
            //回复
            static NSString * identifierStr = @"ReleasePoisonDetailsIdentifier_4";
            RMReleasePoisonDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
            if (!cell){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonDetailsCell_4" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                cell.delegate = self;
            }
            cell.replyBtn_2.tag = indexPath.row;
            cell.replyBtn_2.parameter_1 = @"回复";
            [cell.userHead_2 sd_setImageWithURL:[NSURL URLWithString:[[[model.returns objectAtIndex:0] objectForKey:@"member"] objectForKey:@"content_face"]] placeholderImage:nil];
            cell.userName_2.text = [[[model.returns objectAtIndex:0] objectForKey:@"member"] objectForKey:@"member_name"];
            cell.userLocatiom_2.text = @"正在定位...";
            cell.userPostTime_2.text = model.create_time;
            
            CGRect rect_1 = [cell boundingRectCommentWith:[NSString stringWithFormat:@"%@",model.content_body]];

            cell.comments_2_1_bgView.frame = CGRectMake(cell.comments_2_1_bgView.frame.origin.x, cell.comments_2_1_bgView.frame.origin.y, kScreenWidth - 95, rect_1.size.height + 20);
            
            cell.comments_2_1.frame = CGRectMake(cell.comments_2_1.frame.origin.x, cell.comments_2_1.frame.origin.y, kScreenWidth - 105, rect_1.size.height + 20);
            
            cell.comments_2_1.text = [NSString stringWithFormat:@"%@\n%@",model.content_name,model.content_body];
            
            NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",model.content_name,model.content_body]];
            [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:0.18 blue:0.45 alpha:1] range:NSMakeRange(0, [NSString stringWithFormat:@"%@",model.content_name].length)];
            cell.comments_2_1.attributedText = oneAttributeStr;
            
            /**********分割线**********/

            NSString * returns = [[model.returns objectAtIndex:0] objectForKey:@"content_body"];

            CGRect rect_2 = [cell boundingRectCommentWith:[NSString stringWithFormat:@"%@",returns]];
            
            cell.comments_2_2.frame = CGRectMake(cell.comments_2_2.frame.origin.x, cell.comments_2_1.frame.origin.y + cell.comments_2_1.frame.size.height + 5, kScreenWidth - 105, rect_2.size.height);

            cell.comments_2_2.text = returns;
            
            [cell setFrame:CGRectMake(0, 0, kScreenWidth, 45 + cell.comments_2_1.frame.size.height + cell.comments_2_2.frame.size.height + 20)];
            
            cell.line_2.frame = CGRectMake(0, cell.frame.size.height-1, kScreenWidth, 1);

            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - 跳转到广告位置

- (void)jumpPromoteMethod:(RMImageView *)image {
    NSLog(@"member_id:%@",image.identifierString);
    RMBaseWebViewController * baseWebCtl = [[RMBaseWebViewController alloc] init];
    [baseWebCtl loadRequestWithUrl:@"" withTitle: @"广告位置" withisloadRequest:YES];
    [self.navigationController pushViewController:baseWebCtl animated:YES];
}

#pragma mark - 给此帖点赞

- (void)addPraiseMethod:(RMImageView *)image {
    if (![RMUserLoginInfoManager loginmanager].state){
        NSLog(@"去登录.....");
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPostsAddPraiseWithAuto_id:dataModel.auto_id withID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            [self showHint:[object objectForKey:@"msg"]];
            
            RMReleasePoisonDetailsCell * cell = (RMReleasePoisonDetailsCell *)[mTableView cellForRowAtIndexPath:image.indexPath];

            cell.addPraiseImg.image = LOADIMAGE(@"img_zaned", kImageTypePNG);
            
            dataModel.is_top = @"1";
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }else{
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

#pragma mark - 点击评论人的头像

- (void)userHeadMethod:(RMImageView *)image {
    NSLog(@"点击头像事件");
}

#pragma mark - 举报此帖

- (void)reportMethod:(UIButton *)button {
    if (![[RMUserLoginInfoManager loginmanager] state]){
        NSLog(@"去登录");
        return;
    }
    
    RMCommentsView * commentsView = [[RMCommentsView alloc] init];
    commentsView.delegate = self;
    commentsView.requestType = kRMReleasePoisonToReport;
    commentsView.code = dataModel.auto_id;
    commentsView.backgroundColor = [UIColor clearColor];
    commentsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [commentsView loadCommentsViewWithReceiver:[NSString stringWithFormat:@"   举报:%@",[dataModel.members objectForKey:@"member_name"]] withImage:nil];
    [self.view addSubview:commentsView];
}

- (void)commentMethodWithType:(NSInteger)type withError:(NSError *)error withState:(BOOL)success withObject:(id)object withImage:(RMImageView *)image {
    if (error){
        NSLog(@"error:%@",error);
        return;
    }
    
    if (success){
        [self showHint:[object objectForKey:@"msg"]];
    }else{
        [self showHint:[object objectForKey:@"msg"]];
    }
}

#pragma mark - 回复帖子

- (void)replyMethod:(RMBaseButton *)button {
    if (![[RMUserLoginInfoManager loginmanager] state]){
        NSLog(@"去登录");
        return;
    }
    
    RMPublicModel * model = [dataCommentArr objectAtIndex:button.tag - 1];

    NSString * name;
    
    RMCommentsView * commentsView = [[RMCommentsView alloc] init];
    commentsView.delegate = self;
    commentsView.requestType = kRMReleasePoisonListReplyOrComment;
    if ([button.parameter_1 isEqualToString:@"评论"]){
        name = model.content_name;
        commentsView.code = model.auto_id;
    }else{
        name = [[[model.returns objectAtIndex:0] objectForKey:@"member"] objectForKey:@"member_name"];
        commentsView.code = [[model.returns objectAtIndex:0] objectForKey:@"auto_id"];
    }
    commentsView.commentType = button.parameter_1;
    commentsView.backgroundColor = [UIColor clearColor];
    commentsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [commentsView loadCommentsViewWithReceiver:[NSString stringWithFormat:@"   回复:%@",name] withImage:nil];
    [self.view addSubview:commentsView];
}

#pragma mark - 帖主头像

- (void)userHeaderClick:(RMImageView *)image {
    NSLog(@"帖主 👦");
}

#pragma 数据请求

- (void)requestDetatils {
    NSString * user_id = [RMUserLoginInfoManager loginmanager].user;
    NSString * user_password = [RMUserLoginInfoManager loginmanager].pwd;
    user_id = ([user_id length] > 0 ? user_id : @"");
    user_password = ([user_password length] > 0 ? user_password : @"");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPostsListDetailsWithAuto_id:self.auto_id withUser_id:user_id withUser_password:user_password callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            dataModel.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"auto_id"]);
            dataModel.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_name"]);
            dataModel.content_type = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_type"]);
            dataModel.content_class = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_class"]);
            dataModel.content_course = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_course"]);
            dataModel.content_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_top"]);
            dataModel.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"create_time"]);
            dataModel.member_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"member_id"]);
            dataModel.body = [[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"body"];
            dataModel.content_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_collect"]);
            dataModel.is_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"is_collect"]);
            dataModel.content_review = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_review"]);
            dataModel.is_review = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"is_review"]);
            dataModel.is_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"is_top"]);
            dataModel.members = [[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"member"];
            
            if ([dataModel.is_collect isEqualToString:@"1"]){
                UIButton * btn = (UIButton *)[bottomView viewWithTag:1];
                [btn setBackgroundImage:LOADIMAGE(@"img_asced", kImageTypePNG) forState:UIControlStateNormal];
            }
            
            [self loadTableHeadView];

            [self requestAdvertisingQuery];
            
            [self requestCommentListsWithPageCount:1];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

/**
 获取评论的list
 */
- (void)requestCommentListsWithPageCount:(NSInteger)pc {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPostsCommentsListWithReview_id:OBJC(dataModel.auto_id) withPageCount:pc callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            if (self.refreshControl.refreshingDirection == RefreshingDirectionTop) {
            }else if(self.refreshControl.refreshingDirection==RefreshingDirectionBottom) {
                if ([[object objectForKey:@"data"] count] == 0){
                    [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    isLoadComplete = YES;
                    return;
                }
                
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.member_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member_id"]);
                    model.content_body = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_body"]);
                    model.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"create_time"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.members = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member"];
                    model.returns = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"return"];
                    [dataCommentArr addObject:model];
                }
                
                [mTableView reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            }
            
            if (isRefresh){
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.member_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member_id"]);
                    model.content_body = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_body"]);
                    model.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"create_time"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.members = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member"];
                    model.returns = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"return"];
                    [dataCommentArr addObject:model];
                }
                
                [mTableView reloadData];
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        if (isLoadComplete){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.44 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showHint:@"没有更多评论啦"];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            });
        }else{
            pageCount ++;
            isRefresh = NO;
            [self requestCommentListsWithPageCount:pageCount];
        }
    }
}

/**
 *  @method     广告
 */
- (void)requestAdvertisingQuery {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getAdvertisingQueryWithType:3 callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error::%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                model.member_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member_id"]);
                [advertisingArr addObject:model];
            }

            [mTableView reloadData];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
