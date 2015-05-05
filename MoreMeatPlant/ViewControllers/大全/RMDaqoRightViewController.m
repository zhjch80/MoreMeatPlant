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
#import "RMImageView.h"

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
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth - kSlideWidth, 20, kSlideWidth, kScreenHeight - 20 - 47) style:UITableViewStyleGrouped];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    
    [self loadTableViewheader];
}

- (void)loadTableViewheader {
    RMImageView * header = [[RMImageView alloc] init];
    header.frame = CGRectMake(kScreenWidth - kSlideWidth, 0, kSlideWidth, 30);
    [header addTarget:self withSelector:@selector(allOfTheMeatMethod)];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel * allMeat = [[UILabel alloc] init];
    allMeat.frame = CGRectMake(0, 0, kSlideWidth, 30);
    allMeat.text = @"    全部肉肉";
    allMeat.backgroundColor = [UIColor clearColor];
    allMeat.font = FONT_1(15.0);
    allMeat.userInteractionEnabled = YES;
    allMeat.multipleTouchEnabled = YES;
    [header addSubview:allMeat];
    
    mTableView.tableHeaderView = header;
}

- (void)allOfTheMeatMethod {
    RMDaqoViewController * daqoCtl = self.DaqoDelegate;

    [daqoCtl updateCenterListWithModel:nil withRow:-2];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [daqoCtl updateSlideSwitchState];
    });
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
    headerView.frame = CGRectMake(kScreenWidth - kSlideWidth, 0, kSlideWidth, 44);
    headerView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    headerView.model = model;
    [headerView addTarget:self withSelector:@selector(cellHeaderMethod:)];

    UILabel * title = [[UILabel alloc] init];
    title.userInteractionEnabled = YES;
    title.multipleTouchEnabled = YES;
    title.font = FONT_1(14.0);
    title.backgroundColor = [UIColor clearColor];
    title.frame = CGRectMake(0, 0, kSlideWidth, 44);
    title.text = [NSString stringWithFormat:@"    %@",model.modules_name];
    [headerView addSubview:title];
    [title adjustsFontSizeToFitWidth];
    
    return headerView;
}

- (void)cellHeaderMethod:(RMBaseView *)view {
    RMDaqoViewController * daqoCtl = self.DaqoDelegate;

    [daqoCtl updateCenterListWithModel:view.model withRow:-1];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [daqoCtl updateSlideSwitchState];
    });
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
    cell.mTitle.text = [NSString stringWithFormat:@"    %@",[[model.sub objectAtIndex:indexPath.row] objectForKey:@"modules_name"]];
    cell.mTitle.font = FONT_1(16.0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RMDaqoViewController * daqoCtl = self.DaqoDelegate;

    RMPublicModel * model = [dataArr objectAtIndex:indexPath.row];

    [daqoCtl updateCenterListWithModel:model withRow:indexPath.row];

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [daqoCtl updateSlideSwitchState];
    });
}

#pragma mark－ 数据请求

- (void)requestPlantSubs {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getClassificationOfSideslipCallBack:^(NSError *error, BOOL success, id object) {
        if (error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"error:%@",error);
        }
        
        if (success){
            for (NSInteger i=0; i<[[[object objectForKey:@"data"] objectForKey:@"course"] count]; i++) {
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.auto_id = OBJC([[[[object objectForKey:@"data"] objectForKey:@"course"] objectAtIndex:i] objectForKey:@"auto_id"]);
                model.modules_name = OBJC([[[[object objectForKey:@"data"] objectForKey:@"course"] objectAtIndex:i] objectForKey:@"modules_name"]);
                model.auto_code = OBJC([[[[object objectForKey:@"data"] objectForKey:@"course"] objectAtIndex:i] objectForKey:@"auto_code"]);
                model.auto_id = OBJC([[[[object objectForKey:@"data"] objectForKey:@"course"] objectAtIndex:i] objectForKey:@"auto_id"]);
                model.sub = [[[[object objectForKey:@"data"] objectForKey:@"course"] objectAtIndex:i] objectForKey:@"sub"];
                [dataArr addObject:model];
            }
            
            for (NSInteger i=0; i<[[[object objectForKey:@"data"] objectForKey:@"grow"] count]; i++) {
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.modules_name = OBJC([[[[object objectForKey:@"data"] objectForKey:@"grow"] objectAtIndex:i] objectForKey:@"label"]);
                model.auto_id = OBJC([[[[object objectForKey:@"data"] objectForKey:@"grow"] objectAtIndex:i] objectForKey:@"value"]);
                [dataArr addObject:model];
            }
            
            [mTableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}


@end
