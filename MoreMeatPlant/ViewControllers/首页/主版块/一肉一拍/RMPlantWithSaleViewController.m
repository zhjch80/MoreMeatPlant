//
//  RMPlantWithSaleViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantWithSaleViewController.h"
#import "RMNearbyMerchantViewController.h"
#import "RMImageView.h"
#import "RMPlantWithSaleCell.h"
#import "RMPlantTypeView.h"
#import "RMStickView.h"
#import "RMPlantWithSaleDetailsViewController.h"
#import "RMPlantWithSaleBottomView.h"
#import "RMPostMessageView.h"
#import "RMBaseWebViewController.h"

@interface RMPlantWithSaleViewController ()<UITableViewDataSource,UITableViewDelegate,StickDelegate,SelectedPlantTypeMethodDelegate,JumpPlantDetailsDelegate,PostMessageSelectedPlantDelegate,PlantWithSaleBottomDelegate>
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) RMPostMessageView *action;

@end

@implementation RMPlantWithSaleViewController
@synthesize mTableView, dataArr, action;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"一肉一拍（80鲜肉）"];
    
    dataArr = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    RMImageView * rmImage = [[RMImageView alloc] init];
    rmImage.frame = CGRectMake(0, 64, kScreenWidth, 45);
    rmImage.image = LOADIMAGE(@"img_02", kImageTypePNG);
    [rmImage addTarget:self WithSelector:@selector(jumpPlantWithSaleNearbyMerchant)];
    [self.view addSubview:rmImage];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, rmImage.frame.size.height + 64, kScreenWidth, kScreenHeight - rmImage.frame.size.height - 64 - 40) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
 
    [self loadTableViewHead];
    
    [self loadBottomView];
}

#pragma mark - 加载底部View

- (void)loadBottomView {
    RMPlantWithSaleBottomView * plantWithSaleBottomView = [[RMPlantWithSaleBottomView alloc] init];
    plantWithSaleBottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    [plantWithSaleBottomView loadPlantWithSaleBottomView];
    plantWithSaleBottomView.delegate = self;
    [self.view addSubview:plantWithSaleBottomView];
}

#pragma mark - 加载tableViewHead

- (void)loadTableViewHead {
    UIView * headView = [[UIView alloc] init];
    
    CGFloat height = 0;
    
    for (NSInteger i=0; i<2; i++) {
        RMStickView * stickView = [[RMStickView alloc] init];
        stickView.frame = CGRectMake(0, 0 + i*30, kScreenWidth, 30);
        [headView addSubview:stickView];
        stickView.delegate = self;
        [stickView loadStickViewWithTitle:(i==0 ? @"新手教程！" : @"发帖前必看！") withOrder:i];
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
    RMPlantWithSaleDetailsViewController * plantWithSaleDetailsCtl = [[RMPlantWithSaleDetailsViewController alloc] init];
    [self.navigationController pushViewController:plantWithSaleDetailsCtl animated:YES];
}

#pragma mark - 选择肉肉类型

- (void)selectedPlantWithType:(NSString *)type {
    NSLog(@"type:%@",type);
}

#pragma mark - 跳转到置顶详情界面

- (void)stickJumpDetailsWithOrder:(NSInteger)order {
    RMBaseWebViewController * baseWebCtl = [[RMBaseWebViewController alloc] init];
    [baseWebCtl loadRequestWithUrl:@"" withTitle:@"置顶 新手教程"];
    [self.navigationController pushViewController:baseWebCtl animated:YES];
}

#pragma mark - 跳转到附近商家

- (void)jumpPlantWithSaleNearbyMerchant {
    RMNearbyMerchantViewController * nearbyMerchantCtl = [[RMNearbyMerchantViewController alloc] init];
    [self.navigationController pushViewController:nearbyMerchantCtl animated:YES];
}

#pragma mark - 选择类型 开始发帖

- (void)selectedPostMessageWithPlantType:(NSString *)type {
    NSLog(@"开始发帖 plant type:%@",type);
    [action dismiss];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{

            break;
        }
        case 2:{
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

#pragma mark - 底部栏回调方法

- (void)plantWithSaleBottomMethodWithTag:(NSInteger)tag {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
