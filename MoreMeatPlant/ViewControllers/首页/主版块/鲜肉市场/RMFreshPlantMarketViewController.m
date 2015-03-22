//
//  RMFreshPlantMarketViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMFreshPlantMarketViewController.h"
#import "RMImageView.h"
#import "RMNearbyMerchantViewController.h"
#import "RMPlantTypeView.h"
#import "RMBottomView.h"
#import "RMStickView.h"
#import "RMPlantWithSaleCell.h"
#import "RMFreshPlantMarketDetailsViewController.h"
#import "RMBaseWebViewController.h"
#import "RMSearchViewController.h"
#import "RMPostMessageView.h"
#import "RMStartPostingViewController.h"
#import "ZFModalTransitionAnimator.h"

@interface RMFreshPlantMarketViewController ()<UITableViewDataSource,UITableViewDelegate,StickDelegate,SelectedPlantTypeMethodDelegate,BottomDelegate,JumpPlantDetailsDelegate,PostMessageSelectedPlantDelegate>{
    
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) RMPostMessageView * action;
@property (nonatomic, strong) ZFModalTransitionAnimator * animator;

@end

@implementation RMFreshPlantMarketViewController
@synthesize mTableView, dataArr, action, animator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self setRightBarButtonNumber:2];
//    [rightOneBarButton setImage:[UIImage imageNamed:@"img_search"] forState:UIControlStateNormal];
//    [rightTwoBarButton setImage:[UIImage imageNamed:@"img_postMessage"] forState:UIControlStateNormal];
    [self setCustomNavTitle:@"鲜肉市场"];
    
    dataArr = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];

    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 40) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    
    [self loadTableViewHead];
    
    [self loadBottomView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifierStr = @"homeIdentifier";
    RMPlantWithSaleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
        cell.delegate = self;
    }
    cell.leftPrice.text = @" ¥560";
    cell.centerPrice.text = @" ¥240";
    cell.rightPrice.text = @" ¥360";
    
    cell.leftName.text = @" 极品雪莲";
    cell.centerName.text = @" 桃美人";
    cell.rightName.text = @" 极品亚美奶酪";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (void)jumpPlantDetailsWithImage:(RMImageView *)image {
    RMFreshPlantMarketDetailsViewController * freshPlantMarketDetailsCtl = [[RMFreshPlantMarketDetailsViewController alloc] init];
    [self.navigationController pushViewController:freshPlantMarketDetailsCtl animated:YES];
}

#pragma mark - 选择肉肉类型

- (void)selectedPlantWithType:(NSString *)type {
    NSLog(@"type:%@",type);
}

#pragma mark - 加载底部View

- (void)loadBottomView {
    RMBottomView * bottomView = [[RMBottomView alloc] init];
    bottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_backup", @"img_up", @"img_moreChat", nil]];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
}

#pragma mark - 加载tableViewHead

- (void)loadTableViewHead {
    UIView * headView = [[UIView alloc] init];

    RMImageView * rmImage = [[RMImageView alloc] init];
    rmImage.frame = CGRectMake(0, 0, kScreenWidth, 45);
    rmImage.image = LOADIMAGE(@"img_02", kImageTypePNG);
    [rmImage addTarget:self WithSelector:@selector(jumpPlantWithSaleNearbyMerchant)];
    [headView addSubview:rmImage];
    
    CGFloat height = rmImage.frame.size.height;
    
    for (NSInteger i=0; i<2; i++) {
        RMStickView * stickView = [[RMStickView alloc] init];
        stickView.frame = CGRectMake(0, height + i*30, kScreenWidth, 30);
        [headView addSubview:stickView];
        stickView.delegate = self;
        [stickView loadStickViewWithTitle:(i==0 ? @"新手教程！" : @"发帖前必看！") withOrder:i];
    }
    
    for (NSInteger i=0; i<2; i++) {
        height = height + 30;
    }
    
    RMPlantTypeView * plantTypeView = [[RMPlantTypeView alloc] init];
    plantTypeView.frame = CGRectMake(0, height, kScreenWidth, kScreenWidth/7.0);
    plantTypeView.delegate = self;
    [plantTypeView loadPlantType];
    [headView addSubview:plantTypeView];
    
    height = height + kScreenWidth/7.0;
    
    headView.frame = CGRectMake(0, 0, kScreenWidth, height);
    mTableView.tableHeaderView = headView;
}

#pragma mark - 跳转到附近商家

- (void)jumpPlantWithSaleNearbyMerchant {
    RMNearbyMerchantViewController * nearbyMerchantCtl = [[RMNearbyMerchantViewController alloc] init];
    [self.navigationController pushViewController:nearbyMerchantCtl animated:YES];
}

#pragma mark - 跳转到置顶详情界面

- (void)stickJumpDetailsWithOrder:(NSInteger)order {
    RMBaseWebViewController * baseWebCtl = [[RMBaseWebViewController alloc] init];
    [baseWebCtl loadRequestWithUrl:@"" withTitle:@"置顶 新手教程"];
    [self.navigationController pushViewController:baseWebCtl animated:YES];
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
            //滚到顶部
            [mTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
        case 2:{
            //多聊
            
            break;
        }
            
        default:
            break;
    }
}

/*
- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            
            break;
        }
        case 2:{
            RMSearchViewController * searchCtl = [[RMSearchViewController alloc] init];
            [self.navigationController pushViewController:searchCtl animated:YES];
            break;
        }
        case 3:{
            action = [[RMPostMessageView alloc] init];
            action.delegate = self;
            action.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            action.backgroundColor = [UIColor clearColor];
            [action initWithPostMessageView];
            [self.view addSubview:action];
            [action show];
            
            break;
        }
            
        default:
            break;
    }
}
*/

- (void)selectedPostMessageWithPlantType:(NSString *)type {
    [action dismiss];
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
    [self presentViewController:startPostingCtl animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
