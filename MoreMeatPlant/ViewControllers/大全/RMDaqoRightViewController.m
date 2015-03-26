//
//  RMDaqoRightViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMDaqoRightViewController.h"
#import "RMSlideParameter.h"
#import "RMDaqoViewController.h"
#import "RMDaqoRightCell.h"
#import "RMBaseView.h"

@interface RMDaqoRightViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;


@end

@implementation RMDaqoRightViewController
@synthesize mTableView, dataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataArr = [[NSMutableArray alloc] init];
    
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth - kSlideWidth, 20, kSlideWidth, kScreenHeight - 20 - 49) style:UITableViewStyleGrouped];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
//    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RMPublicModel * model = [dataArr objectAtIndex:section];
    if ([model.sub isKindOfClass:[NSNull class]]){
        return 0;
    }else{
        return model.sub.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RMPublicModel * model = [dataArr objectAtIndex:section];

    RMBaseView * headerView = [[RMBaseView alloc] init];
    headerView.frame = CGRectMake(0, 0, kScreenWidth - kSlideWidth, 44);
    headerView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    headerView.identifierString = model.modules_name;
    [headerView addTarget:self withSelector:@selector(cellHeaderMethod:)];

    UILabel * title = [[UILabel alloc] init];
    title.userInteractionEnabled = YES;
    title.multipleTouchEnabled = YES;
    title.frame = CGRectMake(0, 0, kScreenWidth - kSlideWidth, 44);
    title.text = model.modules_name;
    [headerView addSubview:title];
    
    return headerView;
}

- (void)cellHeaderMethod:(RMBaseView *)view {
    NSLog(@"header 标识:%@",view.identifierString);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifierStr = @"DaqoRightCell";
    RMDaqoRightCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoRightCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    RMPublicModel * model = [dataArr objectAtIndex:indexPath.row];
    cell.mTitle.text = [NSString stringWithFormat:@"%@",[[model.sub objectAtIndex:indexPath.row] objectForKey:@"modules_name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RMPublicModel * model = [dataArr objectAtIndex:indexPath.row];
    NSLog(@"子分类 name:%@",[[model.sub objectAtIndex:indexPath.row] objectForKey:@"modules_name"]);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        RMDaqoViewController * daqoCtl = self.DaqoDelegate;
        [daqoCtl updateSlideSwitchState];
    });
}

#pragma mark－ 数据请求

- (void)requestPlantSubs {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPlantSubjectsListWithLevel:2 callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"error:%@",error);
        }
        
        if (success){
            for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.auto_code = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_code"]);
                model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                model.modules_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"modules_name"]);
                model.sub = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"sub"];
                [dataArr addObject:model];
            }
            [mTableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}


@end
