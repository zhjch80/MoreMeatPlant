//
//  TransactionRecordsViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/2.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "RMTransactionRecordsViewController.h"
#import "RMRecordsTableViewCell.h"
@interface RMTransactionRecordsViewController ()<RefreshControlDelegate >

@property (nonatomic, strong) RefreshControl * refreshControl;

@end

@implementation RMTransactionRecordsViewController
@synthesize tags;
@synthesize dataarray;
@synthesize refreshControl;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"交易记录"];
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    
    
    more = 1;
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mtableview delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    dataarray = [[NSMutableArray alloc]init];
    
    tags = [NSArray arrayWithObjects:@"收支",@"具体内容",@"金额(BTC)",@"时间", nil];
    [self requestData];
}

- (void)requestData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager billRecordRequest:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd]  Type:self.type page:more andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            if(more == 1){
                [dataarray removeAllObjects];
                [dataarray addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
                if([(NSArray *)object count] == 0){
                    [MBProgressHUD showSuccess:@"暂无消息" toView:self.view];
                    
                }
            }else{
                [dataarray addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                if([(NSArray *)object count] == 0){
                    [MBProgressHUD showSuccess:@"没有更多消息了" toView:self.view];
                    more--;
                }
            }
            [_mtableview reloadData];
        }else{
            [self showHint:object];
        }
    }];
}


#pragma mark 刷新代理
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        more = 1;
        [self requestData];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        more ++;
        [self requestData];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataarray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMRecordsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMRecordsTableViewCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMRecordsTableViewCell" owner:self options:nil] lastObject];
    }
    RMPublicModel * model = [dataarray objectAtIndex:indexPath.row];
    cell.content_desc.text = model.content_item;
    cell.content_money.text = model.content_value;
    cell.content_status.text = model.content_status;
    cell.content_time.text = model.create_time;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.f;
}

#pragma mark -
- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
