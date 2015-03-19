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
    
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) NSMutableArray * dataImgArr;

@end

@implementation RMHomeViewController
@synthesize mTableView, dataArr, dataImgArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    dataArr = [[NSMutableArray alloc] initWithObjects:
               @"",
               @"放毒区",
               @"一肉一拍",
               @"鲜肉市场",
               @"肉肉交换",
               @"活动与团购",
               @"",
               @"新手教程",
               @"升级建议",
               nil];
    
    dataImgArr = [[NSMutableArray alloc] initWithObjects:
                  @"",
                  @"img_06",
                  @"img_10",
                  @"img_14",
                  @"img_22",
                  @"img_26",
                  @"",
                  @"img_29",
                  @"img_31",
                  nil];
    
    RMImageView * rmImage = [[RMImageView alloc] init];
    rmImage.frame = CGRectMake(0, 20, kScreenWidth, 45);
    rmImage.backgroundColor = [UIColor greenColor];
    rmImage.image = LOADIMAGE(@"img_02", kImageTypePNG);
    [rmImage addTarget:self WithSelector:@selector(jumpHomeNearbyMerchant)];
    [self.view addSubview:rmImage];
    
    RMImageView * popularizeView = [[RMImageView alloc] init];
    popularizeView.frame = CGRectMake(0, rmImage.frame.size.height + 20, kScreenWidth, 40);
    popularizeView.image = LOADIMAGE(@"img_03", kImageTypePNG);
    [popularizeView addTarget:self WithSelector:@selector(jumpPopularize:)];
    [self.view addSubview:popularizeView];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, rmImage.frame.size.height + popularizeView.frame.size.height + 20, kScreenWidth, kScreenHeight - rmImage.frame.size.height - popularizeView.frame.size.height - 44 - 20) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
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
        
        cell.headImg.image = LOADIMAGE([dataImgArr objectAtIndex:indexPath.row], kImageTypePNG);
        if (indexPath.row == [dataArr count]-1){
            NSString *sample_text = [NSString stringWithFormat:@"<font face='HelveticaNeue-CondensedBold' size=19 color='#2C2C2C'>%@</font>",[dataArr objectAtIndex:indexPath.row]];
            [cell.titleName setText:sample_text];
        }else{
            NSString *sample_text = [NSString stringWithFormat:@"<font face='HelveticaNeue-CondensedBold' size=19 color='#2C2C2C'>%@</font> <font face='' size=24 color='#4F4F4F'>(80新帖)</font>",[dataArr objectAtIndex:indexPath.row]];
            [cell.titleName setText:sample_text];
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
    RMBaseWebViewController * baseWebCtl = [[RMBaseWebViewController alloc] init];
    [baseWebCtl loadRequestWithUrl:@"" withTitle: @"广告位置"];
    [self.navigationController pushViewController:baseWebCtl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
