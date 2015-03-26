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

@interface RMHomeViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL isFirstViewDidAppear;
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;             //本地标题
@property (nonatomic, strong) NSMutableArray * dataImgArr;          //本地标题对应图片资源
@property (nonatomic, strong) NSMutableArray * advertisingArr;      //广告数据
@property (nonatomic, strong) NSMutableArray * columnsArr;          //栏目数量

@end

@implementation RMHomeViewController
@synthesize mTableView, advertisingArr, columnsArr, dataImgArr;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isFirstViewDidAppear){
        [self requestAdvertisingQuery];
        isFirstViewDidAppear = YES;
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
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 46 - 20) style:UITableViewStylePlain];
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

#pragma mark - 数据请求

/**
 *  @method     广告
 */
- (void)requestAdvertisingQuery {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getAdvertisingQueryWithType:1 callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error::%@",error);
            [self requestColumns];
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

            [self loadTableHeaderView];
            
            [self requestColumns];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/**
 *  @method     list
 */
- (void)requestColumns {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getHomeColumnsNumberCallBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            [columnsArr addObject:@""];
            
            for (NSInteger i=0; i<5; i++) {
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.modules_name = OBJC([[[[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"modules_sub"] objectAtIndex:i] objectForKey:@"modules_name"]);
                model.modules_img = OBJC([[[[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"modules_sub"] objectAtIndex:i] objectForKey:@"modules_img"]);
                model.content_num = OBJC([[[[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"modules_sub"] objectAtIndex:i] objectForKey:@"content_num"]);
                [columnsArr addObject:model];
            }
            
            [columnsArr addObject:@""];
            
            for (NSInteger i=0; i<2; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.modules_name = OBJC([[[[[object objectForKey:@"data"] objectAtIndex:1] objectForKey:@"modules_sub"] objectAtIndex:i] objectForKey:@"modules_name"]);
                model.modules_img = OBJC([[[[[object objectForKey:@"data"] objectAtIndex:1] objectForKey:@"modules_sub"] objectAtIndex:i] objectForKey:@"modules_img"]);
                model.content_num = OBJC([[[[[object objectForKey:@"data"] objectAtIndex:1] objectForKey:@"modules_sub"] objectAtIndex:i] objectForKey:@"content_num"]);
                [columnsArr addObject:model];
            }
        }
        [mTableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
