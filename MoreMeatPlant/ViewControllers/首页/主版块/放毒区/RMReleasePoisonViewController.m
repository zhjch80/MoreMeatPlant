//
//  RMReleasePoisonViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMReleasePoisonViewController.h"
#import "RMImageView.h"
#import "RMNearbyMerchantViewController.h"
#import "RMReleasePoisonCell.h"
#import "RMStickView.h"
#import "RMStickDetailsViewController.h"
#import "RMPlantTypeView.h"
#import "RMReleasePoisonBottomView.h"
#import "RMPostMessageView.h"
#import "RMReleasePoisonDetailsViewController.h"

@interface RMReleasePoisonViewController ()<UITableViewDataSource,UITableViewDelegate,StickDelegate,SelectedPlantTypeMethodDelegate,PostMessageSelectedPlantDelegate,PostDetatilsDelegate>{
    
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic, strong) RMPostMessageView *action;
@end

@implementation RMReleasePoisonViewController
@synthesize mTableView, dataArr, action;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomNavTitle:@"放毒区(80新帖)"];
    
    dataArr = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    RMImageView * rmImage = [[RMImageView alloc] init];
    rmImage.frame = CGRectMake(0, 64, kScreenWidth, 45);
    rmImage.backgroundColor = [UIColor greenColor];
    [rmImage addTarget:self WithSelector:@selector(jumpPoisonNearbyMerchant)];
    [self.view addSubview:rmImage];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + rmImage.frame.size.height, kScreenWidth, kScreenHeight - rmImage.frame.size.height - 64 - 40) style:UITableViewStylePlain];
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
    RMReleasePoisonBottomView * releasePoisonBottomView = [[RMReleasePoisonBottomView alloc] init];
    releasePoisonBottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    releasePoisonBottomView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:releasePoisonBottomView];
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

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%3==0){
        static NSString * identifierStr = @"releasePoisonIdentifier";
        RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_1" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
            cell.delegate = self;
        }
        
        cell.plantTitle.text = @"未读 家有鲜肉 刚入的罗密欧，美不？";
        cell.userName.text = @"Lucy 10分钟前";
        cell.likeTitle.text = @"99+";
        cell.chatTitle.text = @"99+";
        cell.praiseTitle.text = @"99+";
        return cell;
    }else if (indexPath.row%3 == 1){
        static NSString * identifierStr = @"releasePoisonIdentifier";
        RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_2" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
            cell.delegate = self;
        }
        
        cell.plantTitle.text = @"未读 家有鲜肉 刚入的罗密欧，美不？";
        cell.userName.text = @"Lucy 10分钟前";
        cell.likeTitle.text = @"99+";
        cell.chatTitle.text = @"99+";
        cell.praiseTitle.text = @"99+";
        return cell;
    }else{
        static NSString * identifierStr = @"releasePoisonIdentifier";
        RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_3" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
            cell.delegate = self;
        }
        
        cell.plantTitle.text = @"未读 家有鲜肉 刚入的罗密欧，美不？";
        cell.userName.text = @"Lucy 10分钟前";
        cell.likeTitle.text = @"99+";
        cell.chatTitle.text = @"99+";
        cell.praiseTitle.text = @"99+";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - 添加喜欢 赞 评论

- (void)addLikeWithImage:(RMImageView *)image {
    NSLog(@"添加喜欢");
}

- (void)addChatWithImage:(RMImageView *)image {
    NSLog(@"添加评论");
}

- (void)addPraiseWithImage:(RMImageView *)image {
    NSLog(@"添加赞");
}

#pragma mark - 帖子详情

- (void)jumpPostDetailsWithImage:(RMImageView *)image {
    NSLog(@"帖子详情");
    RMReleasePoisonDetailsViewController * releasePoisonDetailsCtl = [[RMReleasePoisonDetailsViewController alloc] init];
    [self.navigationController pushViewController:releasePoisonDetailsCtl animated:YES];
}

#pragma mark - 选择类型 开始发帖

- (void)selectedPostMessageWithPlantType:(NSString *)type {
    NSLog(@"开始发帖 plant type:%@",type);
    [action dismiss];
}

#pragma mark - 选择肉肉类型

- (void)selectedPlantWithType:(NSString *)type {
    NSLog(@"type:%@",type);
}

#pragma mark - 跳转到置顶详情界面

- (void)stickJumpDetailsWithOrder:(NSInteger)order {
    NSLog(@"order:%ld",(long)order);
    RMStickDetailsViewController * stickDetailsCtl = [[RMStickDetailsViewController alloc] init];
    [self.navigationController pushViewController:stickDetailsCtl animated:YES];
}

#pragma mark - 跳转到附近商家

- (void)jumpPoisonNearbyMerchant {
    RMNearbyMerchantViewController * nearbyMerchantCtl = [[RMNearbyMerchantViewController alloc] init];
    [self.navigationController pushViewController:nearbyMerchantCtl animated:YES];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
