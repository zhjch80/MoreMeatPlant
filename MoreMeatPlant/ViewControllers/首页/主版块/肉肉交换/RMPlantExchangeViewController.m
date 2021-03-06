//
//  RMPlantExchangeViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantExchangeViewController.h"
#import "RMImageView.h"
#import "RMNearbyMerchantViewController.h"
#import "RMReleasePoisonCell.h"
#import "RMStickView.h"
#import "RMPlantTypeView.h"
#import "RMBottomView.h"
#import "RMPostMessageView.h"
#import "RMReleasePoisonDetailsViewController.h"
#import "RMBaseWebViewController.h"
#import "RMStartPostingViewController.h"
#import "ZFModalTransitionAnimator.h"
#import "RMPostClassificationView.h"
#import "RMSearchViewController.h"
#import "RefreshControl.h"
#import "RefreshView.h"
#import "NSString+TimeInterval.h"
#import "RMCommentsView.h"
#import "KxMenu.h"
#import "AppDelegate.h"
#import "RMPlantWithSaleViewController.h"
#import "RMFreshPlantMarketViewController.h"
#import "RMMyCorpViewController.h"
#import "RMMyHomeViewController.h"
#import "RMStartLongPostingViewController.h"
#import "UIImage+LK.h"

@interface RMPlantExchangeViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,StickDelegate,SelectedPlantTypeMethodDelegate,PostMessageSelectedPlantDelegate,PostDetatilsDelegate,BottomDelegate,PostClassificationDelegate,RefreshControlDelegate,CommentsViewDelegate>{
    BOOL isFirstViewDidAppear;
    BOOL isRefresh;
    NSInteger pageCount;
    BOOL isLoadComplete;
    
    BOOL isLoadAdver;       //是否已经加载广告
    BOOL isLoadNews;        //是否已经加载置顶
    BOOL isSubsPlant;       //是否已经加载科目
    
    RKNotificationHub * chat_badge;
    RKNotificationHub * badge;
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;         //列表数据
@property (nonatomic, strong) NSMutableArray * advertisingArr;  //广告数据
@property (nonatomic, strong) NSMutableArray * plantTypeArr;    //植物分类
@property (nonatomic, strong) NSMutableArray * subsPlantArr;    //植物科目
@property (nonatomic, strong) NSMutableArray * newsArr;         //新闻

@property (nonatomic, assign) NSInteger plantRequestValue;       //请求list数据 默认传空 用户可以选择植物分类
@property (nonatomic, assign) NSInteger subsPlantRequestValue;   //请求list数据 默认传空 用户可以选择科目

@property (nonatomic, strong) RMPostClassificationView * fenleiAction;
@property (nonatomic, strong) RMPostMessageView *action;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (nonatomic, strong) RefreshControl * refreshControl;
@property (nonatomic, strong) RMPlantTypeView * plantTypeView;
@property (nonatomic, strong) RMBottomView * bottomView;
@property (nonatomic, strong) RMPublicModel * actionModel_1;
@property (nonatomic, strong) RMPublicModel * actionModel_2;

@end

@implementation RMPlantExchangeViewController
@synthesize mTableView, dataArr, fenleiAction, action, animator, plantTypeArr, advertisingArr, subsPlantArr, newsArr, plantRequestValue, subsPlantRequestValue, refreshControl,plantTypeView, bottomView, actionModel_1, actionModel_2;




- (void)viewWillAppear:(BOOL)animated{
    [badge setCount:[[self queryInfoNumber] intValue]];
    [chat_badge setCount:[[self queryInfoNumber] intValue]];

}

- (void)receviverNoti:(NSNotification *)noti{
    [badge setCount:[[self queryInfoNumber] intValue]];
    [chat_badge setCount:[[self queryInfoNumber] intValue]];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isFirstViewDidAppear){
        [self requestAdvertisingQuery];
        [self requestNews];
        [self requestPlantSubjects];
        [self reqestPlantClassification];
        isFirstViewDidAppear = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[RMPlantExchangeViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[RMPlantExchangeViewController class]];
    
    [self setRightBarButtonNumber:2];
    [leftBarButton setImage:[UIImage imageNamed:@"Nav_LeftBack"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"分类" forState:UIControlStateNormal];
    leftBarButton.titleLabel.font = FONT_2(18.0);
    leftBarButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    [rightOneBarButton setImage:[UIImage imageNamed:@"img_search"] forState:UIControlStateNormal];
    [rightTwoBarButton setImage:[UIImage imageNamed:@"img_postMessage"] forState:UIControlStateNormal];
    [self setCustomNavTitle:@"肉肉交换"];
    
    advertisingArr = [[NSMutableArray alloc] init];
    plantTypeArr = [[NSMutableArray alloc] init];
    
    newsArr = [[NSMutableArray alloc] init];
    
    plantRequestValue = -9999;
    subsPlantRequestValue = -9999;
    
    dataArr = [[NSMutableArray alloc] init];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 38) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:mTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    
    pageCount = 1;
    isRefresh = YES;
    isFirstViewDidAppear = NO;
    
    [self loadBottomView];
    
    UIButton * chat_btn = (UIButton *)[bottomView viewWithTag:2];
    chat_badge = [[RKNotificationHub alloc]initWithView:chat_btn];
    [chat_badge setCount:[[self queryShopCarNumber] intValue]];
    [chat_badge scaleCircleSizeBy:0.5];
}

#pragma mark - 加载底部View

- (void)loadBottomView {
    bottomView = [[RMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_backup", @"img_up", @"img_moreChat", nil]];
    [self.view addSubview:bottomView];
}

#pragma mark - 加载tableViewHead

- (void)loadTableViewHead {
    mTableView.tableHeaderView = nil;
    
    UIView * headView = [[UIView alloc] init];
    
    CGFloat versionValue = 0;
    if (IS_IPHONE_5_SCREEN | IS_IPHONE_4_SCREEN){
        versionValue = 45;
    }else{
        versionValue = 60;
    }
    
    RMImageView * rmImage = [[RMImageView alloc] init];
    rmImage.frame = CGRectMake(0, 0, kScreenWidth, versionValue);
    rmImage.image = LOADIMAGE(@"img_02", kImageTypePNG);
    [rmImage addTarget:self withSelector:@selector(jumpPoisonNearbyMerchant)];
    [headView addSubview:rmImage];
    
    CGFloat changeHeight = 0;
    NSInteger value = 1;
    for (NSInteger i=0; i<[advertisingArr count]; i++) {
        RMImageView * popularizeView = [[RMImageView alloc] init];
        RMPublicModel * model = [advertisingArr objectAtIndex:i];
        popularizeView.identifierString = model.member_id;
        popularizeView.content_type = model.note_id;
        [popularizeView sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        
//        CGSize size = [UIImage downloadImageSizeWithURL:[NSURL URLWithString:model.content_img]];
        CGFloat _height = 150.0/1080.0 * kScreenWidth;
        popularizeView.frame = CGRectMake(0, rmImage.frame.size.height + changeHeight + value * 2, kScreenWidth, _height);
        
        [popularizeView addTarget:self withSelector:@selector(jumpPopularize:)];
        [headView addSubview:popularizeView];
        changeHeight = changeHeight + _height;
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, popularizeView.frame.origin.y + popularizeView.frame.size.height, kScreenWidth, 2)];
        line.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        [headView addSubview:line];
        
        if (i==0){
            UIView * _line = [[UIView alloc] initWithFrame:CGRectMake(0, rmImage.frame.size.height, kScreenWidth, 2)];
            _line.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
            [headView addSubview:_line];
        }
        value ++;
    }
    
    CGFloat height = rmImage.frame.size.height + changeHeight + value * 2;
    
    for (NSInteger i=0; i<[newsArr count]; i++) {
        RMPublicModel * model = [newsArr objectAtIndex:i];
        RMStickView * stickView = [[RMStickView alloc] init];
        stickView.frame = CGRectMake(0, height + i*30, kScreenWidth, 30);
        [headView addSubview:stickView];
        stickView.delegate = self;
        [stickView loadStickViewWithTitle:model.content_name withOrder:i];
    }
    
    for (NSInteger i=0; i<[newsArr count]; i++) {
        height = height + 30;
    }
    
    plantTypeView = [[RMPlantTypeView alloc] init];
    plantTypeView.frame = CGRectMake(0, height, kScreenWidth, kScreenWidth/7.0 + 5);
    plantTypeView.delegate = self;
    [plantTypeView loadPlantTypeWithImageArr:subsPlantArr];
    [headView addSubview:plantTypeView];
    
    height = height + kScreenWidth/7.0 + 5;
    
    headView.frame = CGRectMake(0, 0, kScreenWidth, height);
    mTableView.tableHeaderView = headView;
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self loadIndexPath:indexPath withTableView:tableView];
}

- (UITableViewCell *)loadIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView {
    RMPublicModel * model = [dataArr objectAtIndex:indexPath.row];
    NSInteger value = 0;
    if ([model.imgs isKindOfClass:[NSNull class]]){
        value = 0;
    }else{
        value = [model.imgs count];
    }
    
    if (value >= 3){
        static NSString * identifierStr = @"releasePoisonIdentifier_2";
        RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        
        if (!cell){
            if (IS_IPHONE_6p_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_2_6p" owner:self options:nil] lastObject];
            }else if (IS_IPHONE_6_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_2_6" owner:self options:nil] lastObject];
            }else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_2" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
            cell.delegate = self;
        }
        
        NSString * readStr;
        
        if ([model.isRead isEqualToString:@"已读"]){
            readStr = @"已读";
        }else{
            readStr = @"未读";
        }
        
        cell.plantTitle.text = [NSString  stringWithFormat:@"%@ %@ %@",readStr,model.content_class,model.content_name];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString  stringWithFormat:@"%@ %@ %@",readStr,model.content_class,model.content_name]];
        
        if ([readStr isEqualToString:@"已读"]){
            [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1] range:NSMakeRange(0, 2)];
        }else{
            [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.31 blue:0.4 alpha:1] range:NSMakeRange(0, 2)];
        }
        
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] range:NSMakeRange(3, 4)];
        
        cell.plantTitle.attributedText = oneAttributeStr;
        [cell.userHeadImg sd_setImageWithURL:[NSURL URLWithString:[model.members objectForKey:@"content_face"]] placeholderImage:nil];
        
        NSString * _name;
        if ([[model.members objectForKey:@"member_name"] length] > 5){
            _name = [[model.members objectForKey:@"member_name"] substringToIndex:5];
            _name = [NSString stringWithFormat:@"%@...",_name];
        }else{
            _name = [model.members objectForKey:@"member_name"];
        }
        
        cell.userName.text = [NSString stringWithFormat:@"%@ %@",_name,[[NSString stringWithFormat:@"%@:00",model.create_time] intervalSinceNow]];
        
        [cell.rightImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:0] objectForKey:@"content_img"]] placeholderImage:nil];
        [cell.rightUpTwoImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:1] objectForKey:@"content_img"]] placeholderImage:nil];
        [cell.rightDownTwoImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:2] objectForKey:@"content_img"]] placeholderImage:nil];
        
        cell.leftTwoImg.identifierString = model.auto_id;
        cell.rightUpTwoImg.identifierString = model.auto_id;
        cell.rightDownTwoImg.identifierString = model.auto_id;
        
        cell.likeImg.identifierString = model.auto_id;
        cell.likeImg.indexPath = indexPath;
        cell.chatImg.identifierString = model.auto_id;
        cell.chatImg.indexPath = indexPath;
        cell.praiseImg.identifierString = model.auto_id;
        cell.praiseImg.indexPath = indexPath;

        if (model.is_collect){
            cell.likeImg.image = [UIImage imageNamed:@"img_asced.png"];
        }else{
            cell.likeImg.image = LOADIMAGE(@"img_asc", kImageTypePNG);
        }
        
        cell.chatImg.image = LOADIMAGE(@"img_chat", kImageTypePNG);
        
        if (model.is_top){
            cell.praiseImg.image = LOADIMAGE(@"img_zaned", kImageTypePNG);
        }else{
            cell.praiseImg.image = LOADIMAGE(@"img_zan", kImageTypePNG);
        }
        
        cell.likeTitle.text = [self getLargeNumbersToSpecificStr:model.content_collect];
        cell.chatTitle.text = [self getLargeNumbersToSpecificStr:model.content_review];
        cell.praiseTitle.text = [self getLargeNumbersToSpecificStr:model.content_top];
        return cell;
    }else if (value == 2){
        static NSString * identifierStr = @"releasePoisonIdentifier_1";
        RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        
        if (!cell){
            if (IS_IPHONE_6p_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_1_6p" owner:self options:nil] lastObject];
            }else if (IS_IPHONE_6_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_1_6" owner:self options:nil] lastObject];
            }else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_1" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
            cell.delegate = self;
        }
        
        NSString * readStr;
        
        if ([model.isRead isEqualToString:@"已读"]){
            readStr = @"已读";
        }else{
            readStr = @"未读";
        }
        
        cell.plantTitle.text = [NSString  stringWithFormat:@"%@ %@ %@",readStr,model.content_class,model.content_name];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString  stringWithFormat:@"%@ %@ %@",readStr,model.content_class,model.content_name]];
        
        if ([readStr isEqualToString:@"已读"]){
            [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1] range:NSMakeRange(0, 2)];
        }else{
            [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.31 blue:0.4 alpha:1] range:NSMakeRange(0, 2)];
        }
        
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] range:NSMakeRange(3, 4)];
        
        cell.plantTitle.attributedText = oneAttributeStr;
        [cell.userHeadImg sd_setImageWithURL:[NSURL URLWithString:[model.members objectForKey:@"content_face"]] placeholderImage:nil];
        
        NSString * _name;
        if ([[model.members objectForKey:@"member_name"] length] > 5){
            _name = [[model.members objectForKey:@"member_name"] substringToIndex:5];
            _name = [NSString stringWithFormat:@"%@...",_name];
        }else{
            _name = [model.members objectForKey:@"member_name"];
        }
        
        cell.userName.text = [NSString stringWithFormat:@"%@ %@",_name,[[NSString stringWithFormat:@"%@:00",model.create_time] intervalSinceNow]];
        
        [cell.leftImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:0] objectForKey:@"content_img"]] placeholderImage:nil];
        [cell.rightImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:1] objectForKey:@"content_img"]] placeholderImage:nil];
        
        cell.leftImg.identifierString = model.auto_id;
        cell.rightImg.identifierString = model.auto_id;
        cell.likeImg.identifierString = model.auto_id;
        cell.likeImg.indexPath = indexPath;
        cell.chatImg.identifierString = model.auto_id;
        cell.chatImg.indexPath = indexPath;
        cell.praiseImg.identifierString = model.auto_id;
        cell.praiseImg.indexPath = indexPath;
        
        if (model.is_collect){
            cell.likeImg.image = LOADIMAGE(@"img_asced", kImageTypePNG);
        }else{
            cell.likeImg.image = LOADIMAGE(@"img_asc", kImageTypePNG);
        }
        cell.chatImg.image = LOADIMAGE(@"img_chat", kImageTypePNG);
        if (model.is_top){
            cell.praiseImg.image = LOADIMAGE(@"img_zaned", kImageTypePNG);
        }else{
            cell.praiseImg.image = LOADIMAGE(@"img_zan", kImageTypePNG);
        }
        
        cell.likeTitle.text = [self getLargeNumbersToSpecificStr:model.content_collect];
        cell.chatTitle.text = [self getLargeNumbersToSpecificStr:model.content_review];
        cell.praiseTitle.text = [self getLargeNumbersToSpecificStr:model.content_top];
        return cell;
    } else {
        static NSString * identifierStr = @"releasePoisonIdentifier_3";
        RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        
        if (!cell){
            if (IS_IPHONE_6p_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_3_6p" owner:self options:nil] lastObject];
            }else if (IS_IPHONE_6_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_3_6" owner:self options:nil] lastObject];
            }else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_3" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
            cell.delegate = self;
        }
        
        NSString * readStr;
        
        if ([model.isRead isEqualToString:@"已读"]){
            readStr = @"已读";
        }else{
            readStr = @"未读";
        }
        
        cell.plantTitle.text = [NSString  stringWithFormat:@"%@ %@ %@",readStr,model.content_class,model.content_name];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString  stringWithFormat:@"%@ %@ %@",readStr,model.content_class,model.content_name]];
        
        if ([readStr isEqualToString:@"已读"]){
            [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1] range:NSMakeRange(0, 2)];
        }else{
            [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.31 blue:0.4 alpha:1] range:NSMakeRange(0, 2)];
        }
        
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] range:NSMakeRange(3, 4)];
        
        cell.plantTitle.attributedText = oneAttributeStr;
        [cell.userHeadImg sd_setImageWithURL:[NSURL URLWithString:[model.members objectForKey:@"content_face"]] placeholderImage:nil];
        
        NSString * _name;
        if ([[model.members objectForKey:@"member_name"] length] > 5){
            _name = [[model.members objectForKey:@"member_name"] substringToIndex:5];
            _name = [NSString stringWithFormat:@"%@...",_name];
        }else{
            _name = [model.members objectForKey:@"member_name"];
        }
        
        cell.userName.text = [NSString stringWithFormat:@"%@ %@",_name,[[NSString stringWithFormat:@"%@:00",model.create_time] intervalSinceNow]];
        
        if ([model.imgs isKindOfClass:[NSNull class]]){
            [cell.threeImg sd_setImageWithURL:[NSURL URLWithString:@"http://lady.southcn.com/6/images/attachement/jpg/site4/20110524/90fba609e4270f45626e36.jpg"] placeholderImage:nil];
        }else{
            [cell.threeImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:0] objectForKey:@"content_img"]] placeholderImage:nil];
        }
        
        cell.threeImg.identifierString = model.auto_id;
        cell.likeImg.identifierString = model.auto_id;
        cell.likeImg.indexPath = indexPath;
        cell.chatImg.identifierString = model.auto_id;
        cell.chatImg.indexPath = indexPath;
        cell.praiseImg.identifierString = model.auto_id;
        cell.praiseImg.indexPath = indexPath;
        
        if (model.is_collect){
            cell.likeImg.image = LOADIMAGE(@"img_asced", kImageTypePNG);
        }else{
            cell.likeImg.image = LOADIMAGE(@"img_asc", kImageTypePNG);
        }
        cell.chatImg.image = LOADIMAGE(@"img_chat", kImageTypePNG);
        if (model.is_top){
            cell.praiseImg.image = LOADIMAGE(@"img_zaned", kImageTypePNG);
        }else{
            cell.praiseImg.image = LOADIMAGE(@"img_zan", kImageTypePNG);
        }
        
        cell.likeTitle.text = [self getLargeNumbersToSpecificStr:model.content_collect];
        cell.chatTitle.text = [self getLargeNumbersToSpecificStr:model.content_review];
        cell.praiseTitle.text = [self getLargeNumbersToSpecificStr:model.content_top];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - 添加收藏 赞 评论

- (void)addLikeWithImage:(RMImageView *)image {
    if (![RMUserLoginInfoManager loginmanager].state){
        NSLog(@"去登录.....");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getMembersCollectWithCollect_id:image.identifierString withContent_type:@"1" withID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            [self showHint:[object objectForKey:@"msg"]];
            //做UI收藏操作
            RMReleasePoisonCell * cell = (RMReleasePoisonCell *)[mTableView cellForRowAtIndexPath:image.indexPath];
            cell.likeImg.image = [UIImage imageNamed:@"img_asced"];
            
            NSString * num = cell.likeTitle.text;
            NSRange range = [num rangeOfString:@"+"];
            if (range.location != NSNotFound){
                for (NSInteger i=0; i<[dataArr count]; i++) {
                    RMPublicModel * model = [dataArr objectAtIndex:i];
                    if ([model.auto_id isEqualToString:image.identifierString]){
                        [dataArr removeObjectAtIndex:i];
                        
                        RMPublicModel * newModel = [[RMPublicModel alloc] init];
                        newModel.auto_id = model.auto_id;
                        newModel.content_name = model.content_name;
                        newModel.content_type = model.content_type;
                        newModel.content_class = model.content_class;
                        newModel.content_course = model.content_course;
                        newModel.content_top = model.content_top;
                        newModel.content_collect = @"99+";
                        newModel.content_review = model.content_review;
                        newModel.create_time = model.create_time;
                        newModel.is_top = model.is_top;
                        newModel.is_collect = @"1";
                        newModel.is_review =  model.is_review;
                        newModel.imgs = model.imgs;
                        newModel.members = model.members;
                        [dataArr insertObject:newModel atIndex:i];
                        break;
                    }else{
                        continue;
                    }
                }
            }else{
                NSInteger _num = num.integerValue;
                _num ++;
                cell.likeTitle.text = [self getLargeNumbersToSpecificStr:[NSString stringWithFormat:@"%ld",(long)_num]];
                
                for (NSInteger i=0; i<[dataArr count]; i++) {
                    RMPublicModel * model = [dataArr objectAtIndex:i];
                    if ([model.auto_id isEqualToString:image.identifierString]){
                        [dataArr removeObjectAtIndex:i];
                        
                        RMPublicModel * newModel = [[RMPublicModel alloc] init];
                        newModel.auto_id = model.auto_id;
                        newModel.content_name = model.content_name;
                        newModel.content_type = model.content_type;
                        newModel.content_class = model.content_class;
                        newModel.content_course = model.content_course;
                        newModel.content_top = model.content_top;
                        newModel.content_collect = [self getLargeNumbersToSpecificStr:[NSString stringWithFormat:@"%ld",(long)_num]];
                        newModel.content_review = model.content_review;
                        newModel.create_time = model.create_time;
                        newModel.is_top = model.is_top;
                        newModel.is_collect = @"1";
                        newModel.is_review =  model.is_review;
                        newModel.imgs = model.imgs;
                        newModel.members = model.members;
                        [dataArr insertObject:newModel atIndex:i];
                        break;
                    }else{
                        continue;
                    }
                }
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }else{
            //不做UI收藏操作
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)addChatWithImage:(RMImageView *)image {
    if (![RMUserLoginInfoManager loginmanager].state){
        NSLog(@"去登录.....");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    for (NSInteger i=0; i<[dataArr count]; i++){
        RMPublicModel * model = [dataArr objectAtIndex:i];
        if ([model.auto_id isEqualToString:image.identifierString]){
            RMCommentsView * commentsView = [[RMCommentsView alloc] init];
            commentsView.delegate = self;
            commentsView.requestType = kRMReleasePoisonListComment;
            commentsView.code = image.identifierString;
            commentsView.backgroundColor = [UIColor clearColor];
            commentsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [commentsView loadCommentsViewWithReceiver:[NSString stringWithFormat:@"  评论:%@",[model.members objectForKey:@"member_name"]] withImage:image];
            [self.view addSubview:commentsView];
            break;
        }
    }
}

- (void)commentMethodWithType:(NSInteger)type withError:(NSError *)error withState:(BOOL)success withObject:(id)object withImage:(RMImageView *)image {
    if (error){
        NSLog(@"errot%@",error);
        [self showHint:@"帖子评论失败！"];
        return;
    }
    
    if (success){
        //做UI上的数据处理
        RMReleasePoisonCell * cell = (RMReleasePoisonCell *)[mTableView cellForRowAtIndexPath:image.indexPath];
        NSString * num = cell.chatTitle.text;
        
        NSRange range = [num rangeOfString:@"+"];
        if (range.location != NSNotFound){
            for (NSInteger i=0; i<[dataArr count]; i++) {
                RMPublicModel * model = [dataArr objectAtIndex:i];
                if ([model.auto_id isEqualToString:image.identifierString]){
                    [dataArr removeObjectAtIndex:i];
                    
                    RMPublicModel * newModel = [[RMPublicModel alloc] init];
                    newModel.auto_id = model.auto_id;
                    newModel.content_name = model.content_name;
                    newModel.content_type = model.content_type;
                    newModel.content_class = model.content_class;
                    newModel.content_course = model.content_course;
                    newModel.content_top = model.content_top;
                    newModel.content_collect = model.content_collect;
                    newModel.content_review = @"99+";
                    newModel.create_time = model.create_time;
                    newModel.is_top = model.is_top;
                    newModel.is_collect = model.is_collect;
                    newModel.is_review =  @"1";
                    newModel.imgs = model.imgs;
                    newModel.members = model.members;
                    [dataArr insertObject:newModel atIndex:i];
                    break;
                }else{
                    continue;
                }
            }
        }else{
            NSInteger _num = num.integerValue;
            _num ++;
            cell.chatTitle.text = [self getLargeNumbersToSpecificStr:[NSString stringWithFormat:@"%ld",(long)_num]];
            
            for (NSInteger i=0; i<[dataArr count]; i++) {
                RMPublicModel * model = [dataArr objectAtIndex:i];
                if ([model.auto_id isEqualToString:image.identifierString]){
                    [dataArr removeObjectAtIndex:i];
                    
                    RMPublicModel * newModel = [[RMPublicModel alloc] init];
                    newModel.auto_id = model.auto_id;
                    newModel.content_name = model.content_name;
                    newModel.content_type = model.content_type;
                    newModel.content_class = model.content_class;
                    newModel.content_course = model.content_course;
                    newModel.content_top = model.content_top;
                    newModel.content_collect = model.content_collect;
                    newModel.content_review = [self getLargeNumbersToSpecificStr:[NSString stringWithFormat:@"%ld",(long)_num]];
                    newModel.create_time = model.create_time;
                    newModel.is_top = model.is_top;
                    newModel.is_collect = model.is_collect;
                    newModel.is_review =  @"1";
                    newModel.imgs = model.imgs;
                    newModel.members = model.members;
                    [dataArr insertObject:newModel atIndex:i];
                    break;
                }else{
                    continue;
                }
            }
        }
        
        [self showHint:[object objectForKey:@"msg"]];
    }else{
        //不做UI上的数据处理
        [self showHint:[object objectForKey:@"msg"]];
    }
}

- (void)addPraiseWithImage:(RMImageView *)image {
    if (![RMUserLoginInfoManager loginmanager].state){
        NSLog(@"去登录.....");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPostsAddPraiseWithAuto_id:image.identifierString withID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            //做UI收藏操作
            RMReleasePoisonCell * cell = (RMReleasePoisonCell *)[mTableView cellForRowAtIndexPath:image.indexPath];
            cell.praiseImg.image = [UIImage imageNamed:@"img_zaned"];
            
            NSString * num = cell.praiseTitle.text;
            NSRange range = [num rangeOfString:@"+"];
            if (range.location != NSNotFound){
                for (NSInteger i=0; i<[dataArr count]; i++) {
                    RMPublicModel * model = [dataArr objectAtIndex:i];
                    if ([model.auto_id isEqualToString:image.identifierString]){
                        [dataArr removeObjectAtIndex:i];
                        
                        RMPublicModel * newModel = [[RMPublicModel alloc] init];
                        newModel.auto_id = model.auto_id;
                        newModel.content_name = model.content_name;
                        newModel.content_type = model.content_type;
                        newModel.content_class = model.content_class;
                        newModel.content_course = model.content_course;
                        newModel.content_top = @"99+";
                        newModel.content_collect = model.content_collect;
                        newModel.content_review = model.content_review;
                        newModel.create_time = model.create_time;
                        newModel.is_top = @"1";
                        newModel.is_collect = model.is_collect;
                        newModel.is_review =  model.is_review;
                        newModel.imgs = model.imgs;
                        newModel.members = model.members;
                        [dataArr insertObject:newModel atIndex:i];
                        break;
                    }else{
                        continue;
                    }
                }
            }else{
                NSInteger _num = num.integerValue;
                _num ++;
                cell.praiseTitle.text = [self getLargeNumbersToSpecificStr:[NSString stringWithFormat:@"%ld",(long)_num]];
                
                for (NSInteger i=0; i<[dataArr count]; i++) {
                    RMPublicModel * model = [dataArr objectAtIndex:i];
                    if ([model.auto_id isEqualToString:image.identifierString]){
                        [dataArr removeObjectAtIndex:i];
                        
                        RMPublicModel * newModel = [[RMPublicModel alloc] init];
                        newModel.auto_id = model.auto_id;
                        newModel.content_name = model.content_name;
                        newModel.content_type = model.content_type;
                        newModel.content_class = model.content_class;
                        newModel.content_course = model.content_course;
                        newModel.content_top = [self getLargeNumbersToSpecificStr:[NSString stringWithFormat:@"%ld",(long)_num]];
                        newModel.content_collect = model.content_collect;
                        newModel.content_review = model.content_review;
                        newModel.create_time = model.create_time;
                        newModel.is_top = @"1";
                        newModel.is_collect = model.is_collect;
                        newModel.is_review =  model.is_review;
                        newModel.imgs = model.imgs;
                        newModel.members = model.members;
                        [dataArr insertObject:newModel atIndex:i];
                        break;
                    }else{
                        continue;
                    }
                }
            }
            
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }else{
            //不做UI收藏操作
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

#pragma mark - 帖子详情

- (void)jumpPostDetailsWithImage:(RMImageView *)image {
    for (NSInteger i=0; i<[dataArr count]; i++) {
        RMPublicModel * _model = [dataArr objectAtIndex:i];
        if (_model.auto_id == image.identifierString){
            _model.isRead = @"已读";
            if([RMPublicModel existDbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",_model.auto_id]]){
                [_model updatetoDb];
            }else{
                [_model insertToDb];
            }
            [dataArr removeObjectAtIndex:i];
            [dataArr insertObject:_model atIndex:i];
            [mTableView reloadData];
            break;
        }else{
            continue;
        }
    }
    
    RMReleasePoisonDetailsViewController * releasePoisonDetailsCtl = [[RMReleasePoisonDetailsViewController alloc] init];
    releasePoisonDetailsCtl.auto_id = image.identifierString;
    [self.navigationController pushViewController:releasePoisonDetailsCtl animated:YES];
}

#pragma mark - 选择类型 开始发帖

- (void)selectedPostMessageWithPostsType:(NSInteger)type_1 withPlantType:(NSInteger)type_2 {
    
    [action dismiss];
    actionModel_1 = [plantTypeArr objectAtIndex:type_1-401];
    actionModel_2 = [subsPlantArr objectAtIndex:type_2-407+1];
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"快速发帖", @"发长贴子", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:{
            RMStartPostingViewController * startPostingCtl = [[RMStartPostingViewController alloc] init];
            startPostingCtl.modalPresentationStyle = UIModalPresentationCustom;
            
            animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:startPostingCtl];
            animator.dragable = NO;
            animator.bounces = NO;
            animator.behindViewAlpha = 0.5f;
            animator.behindViewScale = 0.5f;
            animator.transitionDuration = 0.7f;
            animator.direction = ZFModalTransitonDirectionBottom;
            startPostingCtl.transitioningDelegate = animator;
            startPostingCtl.model_1 = actionModel_1;
            startPostingCtl.model_2 = actionModel_2;
            startPostingCtl.postWhere = @"2";
            [self presentViewController:startPostingCtl animated:YES completion:nil];
            break;
        }
        case 1:{
            RMStartLongPostingViewController * startLongPostingCtl = [[RMStartLongPostingViewController alloc] init];
            startLongPostingCtl.modalPresentationStyle = UIModalPresentationCustom;
            
            animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:startLongPostingCtl];
            animator.dragable = NO;
            animator.bounces = NO;
            animator.behindViewAlpha = 0.5f;
            animator.behindViewScale = 0.5f;
            animator.transitionDuration = 0.7f;
            animator.direction = ZFModalTransitonDirectionBottom;
            startLongPostingCtl.transitioningDelegate = animator;
            startLongPostingCtl.model_1 = actionModel_1;
            startLongPostingCtl.model_2 = actionModel_2;
            startLongPostingCtl.postWhere = @"2";
            [self presentViewController:startLongPostingCtl animated:YES completion:nil];
            break;
        }
        case 2:{
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 选择肉肉类型

- (void)selectedPlantWithType:(NSString *)type {
    if ([type isEqualToString:@"0"]){
        //全部
        subsPlantRequestValue = 10000;
        isRefresh = YES;
        plantRequestValue = -9999;
        [self requestListWithPageCount:1];
    }else{
        //分类
        subsPlantRequestValue = type.integerValue;
        plantRequestValue = -9999;
        [fenleiAction updataPlantClassificationSelectStateWith:type.integerValue];
        isRefresh = YES;
        [self requestListWithPageCount:1];
    }
}

- (void)selectedPlantType:(NSInteger)type_1 withType:(NSInteger)type_2 {
    plantRequestValue = type_1;
    subsPlantRequestValue = type_2-6;
    [plantTypeView updataSelectState:type_2 - 6];
    
    isRefresh = YES;
    [self requestListWithPageCount:1];
}

#pragma mark - 跳转到置顶详情界面

- (void)stickJumpDetailsWithOrder:(NSInteger)order {
    RMPublicModel * model = [newsArr objectAtIndex:order];
    RMBaseWebViewController * baseWebCtl = [[RMBaseWebViewController alloc] init];
    [baseWebCtl loadHtmlWithAuto_id:model.auto_id withTitle:@"详情" withisloadRequest:NO];
    [self.navigationController pushViewController:baseWebCtl animated:YES];
}

#pragma mark - 跳转到附近商家

- (void)jumpPoisonNearbyMerchant {
    RMNearbyMerchantViewController * nearbyMerchantCtl = [[RMNearbyMerchantViewController alloc] init];
    [self.navigationController pushViewController:nearbyMerchantCtl animated:YES];
}

#pragma mark - 跳转到广告

- (void)jumpPopularize:(RMImageView *)image {
    if([image.content_type isEqualToString:@"0"]){
        RMMyCorpViewController * corp = [[RMMyCorpViewController alloc]initWithNibName:@"RMMyCorpViewController" bundle:nil];
        corp.auto_id = image.identifierString;
        [self.navigationController pushViewController:corp animated:YES];
    }else{
        RMReleasePoisonDetailsViewController * ReleasePoisonDetails = [[RMReleasePoisonDetailsViewController alloc]initWithNibName:@"RMReleasePoisonDetailsViewController" bundle:nil];
        ReleasePoisonDetails.auto_id = image.identifierString;
        [self.navigationController pushViewController:ReleasePoisonDetails animated:YES];
    }

}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            if (!fenleiAction){
                fenleiAction = [[RMPostClassificationView alloc] init];
                fenleiAction.delegate = self;
                fenleiAction.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                fenleiAction.backgroundColor = [UIColor clearColor];
                [fenleiAction initWithPostClassificationViewWithPlantArr:plantTypeArr withSubsPlant:subsPlantArr];
            }
            [self.view addSubview:fenleiAction];
            [fenleiAction show];
            break;
        }
        case 2:{
            RMSearchViewController * searchCtl = [[RMSearchViewController alloc] init];
            searchCtl.searchType = @"帖子";
            searchCtl.searchWhere = @"肉肉交换";
            [self.navigationController pushViewController:searchCtl animated:YES];
            break;
        }
        case 3:{
            
            if(![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            
            action = [[RMPostMessageView alloc] init];
            action.delegate = self;
            action.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            action.backgroundColor = [UIColor clearColor];
            [action initWithPostMessageViewWithPlantArr:plantTypeArr withSubsPlant:subsPlantArr];
            [self.view addSubview:action];
            [action show];
            break;
        }
    }
}

#pragma mark - 底部栏回调方法

- (void)bottomMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 0:{
            //返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:{
            //滚到置顶
            [mTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
        case 2:{
            //多聊
            KxMenuItem * item1 = [KxMenuItem menuItem:@"多聊消息" image:nil target:self action:@selector(menuSelected:) index:201];
            item1.foreColor = UIColorFromRGB(0x585858);
            KxMenuItem * item2 = [KxMenuItem menuItem:@"一物一拍" image:nil target:self action:@selector(menuSelected:) index:202];
            item2.foreColor = UIColorFromRGB(0x585858);
            KxMenuItem * item3 = [KxMenuItem menuItem:@"鲜肉市场" image:nil target:self action:@selector(menuSelected:) index:203];
            item3.foreColor = UIColorFromRGB(0x585858);
            NSArray * arr = [[NSArray alloc]initWithObjects:item1,item2,item3, nil];
            
            [KxMenu setTintColor:[UIColor whiteColor]];
            
            [KxMenu showMenuInView:self.view fromRect:CGRectMake(kScreenWidth - 100, bottomView.frame.origin.y, 100, 100) menuItems:arr];
            
            for(UIView * v in self.view.subviews){
                if([v isKindOfClass:[KxMenuOverlay class]]){
                    KxMenuView * menuView = (KxMenuView *)[v.subviews lastObject];
                    UIView * targetView = [menuView viewWithTag:201];
                    
                    UILabel * targetlabel = (UILabel *)[targetView viewWithTag:1];
                    badge = [[RKNotificationHub alloc]initWithView:targetlabel];
                    [badge scaleCircleSizeBy:0.5];
                    [badge setCount:[[self queryInfoNumber] intValue]];
                    break;
                }
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (void)menuSelected:(KxMenuItem *)sender {
    switch (sender.tag) {
        case 201:{
            if (![[RMUserLoginInfoManager loginmanager] state]){
                return ;
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            AppDelegate * shareApp = [UIApplication sharedApplication].delegate;
            [shareApp tabSelectController:3];
            break;
        }
        case 202:{
            RMPlantWithSaleViewController * plantWithSaleCtl = [[RMPlantWithSaleViewController alloc] init];
            [self.navigationController pushViewController:plantWithSaleCtl animated:YES];
            break;
        }
        case 203:{
            RMFreshPlantMarketViewController * freshPlantMarketCtl = [[RMFreshPlantMarketViewController alloc] init];
            [self.navigationController pushViewController:freshPlantMarketCtl animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 数据请求

/**
 *  请求广告查询
 */
- (void)requestAdvertisingQuery {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getAdvertisingQueryWithType:2 callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"广告查询error::%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            for (NSInteger i=0; i<[(NSArray*)[object objectForKey:@"data"] count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                model.member_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member_id"]);
                model.note_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"note_id"]);

                [advertisingArr addObject:model];
            }
            
            [self loadTableViewHead];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

/**
 *  请求置顶数据
 */
- (void)requestNews {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getNewsWithOptionid:973 withPageCount:1 callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            [newsArr removeAllObjects];
            for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++) {
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                model.content_title = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_title"]);
                model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                model.view_link = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"view_link"]);
                [newsArr addObject:model];
            }
            [self loadTableViewHead];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

/**
 *  请求植物分类  (家有鲜肉，播种育苗...)
 */
- (void)reqestPlantClassification {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPlantClassificationWithxCallBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"植物分类error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            [plantTypeArr removeAllObjects];
            for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++) {
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.label = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"label"]);
                model.value = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"value"]);
                [plantTypeArr addObject:model];
            }
            
            fenleiAction = [[RMPostClassificationView alloc] init];
            fenleiAction.delegate = self;
            fenleiAction.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            fenleiAction.backgroundColor = [UIColor clearColor];
            
            [fenleiAction initWithPostClassificationViewWithPlantArr:plantTypeArr withSubsPlant:subsPlantArr];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

/**
 *  请求植物科目  (景天科，番杏科，仙人球...)
 */
- (void)requestPlantSubjects {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPlantSubjectsListWithLevel:1 callBack:^(NSError *error, BOOL success, id object) {
        if (error) {
            NSLog(@"植物科目error:%@",error);
            [self requestListWithPageCount:1];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success) {
            subsPlantArr = [[NSMutableArray alloc] init];
            
            RMPublicModel * model = [[RMPublicModel alloc] init];
            [subsPlantArr addObject:model];
            
            for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.auto_code = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_code"]);
                model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                model.change_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"change_img"]);
                model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                model.modules_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"modules_name"]);
                [subsPlantArr addObject:model];
            }
            
            [self loadTableViewHead];
            
            [self requestListWithPageCount:1];
            
            fenleiAction = [[RMPostClassificationView alloc] init];
            fenleiAction.delegate = self;
            fenleiAction.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            fenleiAction.backgroundColor = [UIColor clearColor];
            
            [fenleiAction initWithPostClassificationViewWithPlantArr:plantTypeArr withSubsPlant:subsPlantArr];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

/**
 *  请求List数据
 */
- (void)requestListWithPageCount:(NSInteger)pc {
    NSString * plantType = @"";
    NSString * subjectsType = @"";
    
    if (plantRequestValue == -9999 | plantRequestValue == 10000){
        plantType = @"";
    }else{
        RMPublicModel * model_1 = [plantTypeArr objectAtIndex:plantRequestValue];
        plantType = model_1.value;
    }
    
    if (subsPlantRequestValue == -9999 | subsPlantRequestValue == 10000){
        subjectsType = @"";
    }else{
        RMPublicModel * model_2 = [subsPlantArr objectAtIndex:subsPlantRequestValue];
        subjectsType = model_2.auto_code;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPostsListWithPostsType:@"2" withPlantType:plantType withPlantSubjects:subjectsType withPageCount:pc withUser_id:@"" withUser_password:@"" withMemberId:nil callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            if (self.refreshControl.refreshingDirection == RefreshingDirectionTop) {
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++){
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_type = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_type"]);
                    model.content_class = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_class"]);
                    model.content_course = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_course"]);
                    model.content_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_top"]);
                    model.content_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_collect"]);
                    model.content_review = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_review"]);
                    model.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"create_time"]);
                    model.is_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_top"]);
                    model.is_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_collect"]);
                    model.is_review =  OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_review"]);
                    model.imgs = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"imgs"];
                    model.members = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member"];
                    
                    //已读 未读
                    RMPublicModel * _model = [[RMPublicModel dbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",model.auto_id] orderby:nil] lastObject];
                    model.isRead = _model.isRead;
                    
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
                
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
            }else if(self.refreshControl.refreshingDirection==RefreshingDirectionBottom) {
                if ([(NSArray *)[object objectForKey:@"data"] count] == 0){
                    [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    isLoadComplete = YES;
                    return;
                }
                for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++){
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_type = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_type"]);
                    model.content_class = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_class"]);
                    model.content_course = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_course"]);
                    model.content_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_top"]);
                    model.content_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_collect"]);
                    model.content_review = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_review"]);
                    model.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"create_time"]);
                    model.is_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_top"]);
                    model.is_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_collect"]);
                    model.is_review =  OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_review"]);
                    model.imgs = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"imgs"];
                    model.members = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member"];
                    
                    //已读 未读
                    RMPublicModel * _model = [[RMPublicModel dbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",model.auto_id] orderby:nil] lastObject];
                    model.isRead = _model.isRead;
                    
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            }
            
            if (isRefresh){
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++){
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_type = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_type"]);
                    model.content_class = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_class"]);
                    model.content_course = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_course"]);
                    model.content_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_top"]);
                    model.content_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_collect"]);
                    model.content_review = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_review"]);
                    model.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"create_time"]);
                    model.is_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_top"]);
                    model.is_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_collect"]);
                    model.is_review =  OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_review"]);
                    model.imgs = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"imgs"];
                    model.members = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member"];
                    
                    //已读 未读
                    RMPublicModel * _model = [[RMPublicModel dbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",model.auto_id] orderby:nil] lastObject];
                    model.isRead = _model.isRead;
                    
                    [dataArr addObject:model];
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
        pageCount = 1;
        isRefresh = YES;
        isLoadComplete = NO;
        [self requestListWithPageCount:1];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        if (isLoadComplete){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.44 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showHint:@"没有更多帖子啦"];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            });
        }else{
            pageCount ++;
            isRefresh = NO;
            [self requestListWithPageCount:pageCount];
        }
    }
}

#pragma mark - 工具

- (NSString *)getLargeNumbersToSpecificStr:(NSString *)str {
    if (str.length >= 3){
        return @"99+";
    }else{
        return str;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
