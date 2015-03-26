//
//  RMHomeViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMHomeViewController.h"
#import "RMImageView.h"
#import "RMNearbyMerchantViewController.h"
#import "RMHomeCell.h"
#import "RMBaseWebViewController.h"

//主版块
#import "RMReleasePoisonViewController.h"
#import "RMPlantWithSaleViewController.h"
#import "RMFreshPlantMarketViewController.h"
#import "RMPlantExchangeViewController.h"
#import "RMActivityWithGroupPurchaseViewController.h"
//副版块
#import "RMFreshManCourseOfStudyViewController.h"
#import "RMUpgradeSuggestViewController.h"

typedef enum{
    kRMDefault = 100,
    kRMReleasePoison = 1,
    kRMPlantWithSale = 2,
    kRMFreshPlantMarket = 3,
    kRMPlantExchange = 4,
    kRMActivityWithGroupPurchase = 5,
    kRMFreshManCourseOfStudy = 7,
    kRMUpgradeSuggest = 8,
}GotoViewControllerName;

typedef enum{
    requestAdvertising = 501,
    requestColumns
}RequestType;

@interface RMHomeViewController ()<UITableViewDataSource,UITableViewDelegate,RMAFNRequestManagerDelegate>{
    BOOL isFirstViewDidAppear;
    RequestType requestType;
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;             //本地标题
@property (nonatomic, strong) NSMutableArray * dataImgArr;          //本地标题对应图片资源
@property (nonatomic, strong) NSMutableArray * advertisingArr;      //广告数据
@property (nonatomic, strong) NSMutableArray * columnsArr;          //栏目数量
@property (nonatomic, strong) RMAFNRequestManager * adManager;
@property (nonatomic, strong) RMAFNRequestManager * manager;

@end

@implementation RMHomeViewController
@synthesize mTableView, adManager, advertisingArr, manager, columnsArr, dataImgArr;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isFirstViewDidAppear){
        adManager = [[RMAFNRequestManager alloc] init];
        adManager.delegate = self;
        requestType = requestAdvertising;
        [adManager getAdvertisingQueryWithType:1];
        isFirstViewDidAppear = YES;
    }
    
    if (!manager){
        manager = [[RMAFNRequestManager alloc] init];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    advertisingArr = [[NSMutableArray alloc] init];
    columnsArr = [[NSMutableArray alloc] init];
    dataImgArr = [NSMutableArray arrayWithObjects:
                  @"",
                  @"img_home_1",
                  @"img_home_2",
                  @"img_home_3",
                  @"img_home_4",
                  @"img_home_5",
                  @"",
                  @"img_home_6",
                  @"img_home_7",
                  nil];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 44 - 20) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
}

- (void)loadTableHeaderView {
    UIView * headerView = [[UIView alloc] init];
    
    RMImageView * rmImage = [[RMImageView alloc] init];
    rmImage.frame = CGRectMake(0, 0, kScreenWidth, 45);
    rmImage.backgroundColor = [UIColor greenColor];
    rmImage.image = LOADIMAGE(@"img_02", kImageTypePNG);
    [rmImage addTarget:self withSelector:@selector(jumpHomeNearbyMerchant)];
    [headerView addSubview:rmImage];
    
    NSInteger value = 0;
    for (NSInteger i=0; i<[advertisingArr count]; i++) {
        RMImageView * popularizeView = [[RMImageView alloc] init];
        RMPublicModel * model = [advertisingArr objectAtIndex:i];
        popularizeView.frame = CGRectMake(0, rmImage.frame.size.height + i*40, kScreenWidth, 40);
        popularizeView.identifierString = model.member_id;
        [popularizeView sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        [popularizeView addTarget:self withSelector:@selector(jumpPopularize:)];
        [headerView addSubview:popularizeView];
        value ++;
    }

    headerView.frame = CGRectMake(0, 0, kScreenWidth, rmImage.frame.size.height + value * 40);
    
    mTableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [columnsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifierStr = @"homeIdentifier";
    RMHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    
    if (indexPath.row == 0 || indexPath.row == 6){
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMHomeCell_sub" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.sub_title.text = (indexPath.row==0 ? @"主版块": @"副版块");
    }else{
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMHomeCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        if (indexPath.row%2 == 0){
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = CGRectMake(0, 0, cell.bgImg.frame.size.width, cell.bgImg.frame.size.height);
            gradient.colors = [NSArray arrayWithObjects:
                               (id)[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor,
                               (id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor,
                               nil];
            CGPoint startPoint = CGPointMake(1, 1);
            CGPoint endPoint = CGPointMake(0, 1);
            gradient.startPoint = startPoint;
            gradient.endPoint = endPoint;
            [cell.bgImg.layer insertSublayer:gradient atIndex:0];
        }else{
            cell.bgImg.backgroundColor = [UIColor clearColor];
        }
        
        RMPublicModel * model = [columnsArr objectAtIndex:indexPath.row];
        
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.modules_img] placeholderImage:[UIImage imageNamed:[dataImgArr objectAtIndex:indexPath.row]]];
        
        if (indexPath.row == [columnsArr count]-1){
            cell.titleName.text = model.modules_name;
        }else{
            if (indexPath.row == 0 || indexPath.row == 6){
                
            }else{
                NSString * numStr = [NSString stringWithFormat:@"(%@新帖)",model.content_num];
                cell.titleName.text = [NSString stringWithFormat:@"%@ %@",model.modules_name,numStr];
                
                NSInteger length = [NSString stringWithFormat:@"%@",model.modules_name].length;
                NSInteger totalLength = [[NSString stringWithFormat:@"%@ %@",model.modules_name,numStr] length];
                
                NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",model.modules_name,numStr]];
                [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.04 green:0.04 blue:0.04 alpha:1] range:NSMakeRange(length, totalLength - length)];
                [oneAttributeStr addAttribute:NSFontAttributeName value:FONT_0(19.0f) range:NSMakeRange(length, totalLength - length)];
                cell.titleName.attributedText = oneAttributeStr;
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 6){
        return 25;
    }else{
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 6){
        return;
    }
    id controller = nil;
    NSString* className = [self getModuleClassNameWithIndexRow:indexPath.row];
    if (className && className.length > 0) {
        Class class = NSClassFromString(className);
        controller = [[class alloc] init];
    }
    switch (indexPath.row) {
        case 7:{
            [controller loadRequestWithUrl:@"http://www.baidu.com" withTitle: @"新手教程"];
            break;
        }
        case 8:{
            [controller loadRequestWithUrl:@"http://www.baidu.com" withTitle: @"升级建议"];
            break;
        }
            
        default:
            break;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSString *)getModuleClassNameWithIndexRow:(NSInteger)row {
    NSString* viewControllerName = nil;
    switch (row) {
        case kRMDefault:
        case kRMReleasePoison:
            viewControllerName = @"RMReleasePoisonViewController";
            break;
        case kRMPlantWithSale:
            viewControllerName = @"RMPlantWithSaleViewController";
            break;
        case kRMFreshPlantMarket:
            viewControllerName = @"RMFreshPlantMarketViewController";
            break;
        case kRMPlantExchange:
            viewControllerName = @"RMPlantExchangeViewController";
            break;
        case kRMActivityWithGroupPurchase:
            viewControllerName = @"RMActivityWithGroupPurchaseViewController";
            break;
        case kRMFreshManCourseOfStudy:
            viewControllerName = @"RMFreshManCourseOfStudyViewController";
            break;
        case kRMUpgradeSuggest:
            viewControllerName = @"RMUpgradeSuggestViewController";
            break;

        default:
            break;
    }
    return viewControllerName;
}

#pragma mark - 跳转到附近商家

- (void)jumpHomeNearbyMerchant {
    RMNearbyMerchantViewController * nearbyMerchantCtl = [[RMNearbyMerchantViewController alloc] init];
    [self.navigationController pushViewController:nearbyMerchantCtl animated:YES];
}

#pragma mark - 跳转广告位置

- (void)jumpPopularize:(RMImageView *)image {
    NSLog(@"会员标识:%@",image.identifierString);

    RMBaseWebViewController * baseWebCtl = [[RMBaseWebViewController alloc] init];
    [baseWebCtl loadRequestWithUrl:@"" withTitle: @"广告位置"];
    [self.navigationController pushViewController:baseWebCtl animated:YES];
}

#pragma mark - AFNNetwork

- (void)requestFinishiDownLoadWith:(NSMutableArray *)array {
    switch (requestType) {
        case requestAdvertising:{
            advertisingArr = [NSMutableArray arrayWithArray:array];
            
            [self loadTableHeaderView];
            
            manager.delegate = self;
            requestType = requestColumns;
            [manager getHomeColumnsNumber];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            break;
        }
        case requestColumns:{
            columnsArr = [NSMutableArray arrayWithArray:array];
            [mTableView reloadData];
            break;
        }
            
        default:
            break;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)requestError:(NSError *)error {
    switch (requestType) {
        case requestAdvertising:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //广告位置加载错误 run
            manager.delegate = self;
            requestType = requestColumns;
            [manager getHomeColumnsNumber];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            break;
        }
        case requestColumns:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            break;
        }
        default:
            break;
    }
    NSLog(@"error:%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
