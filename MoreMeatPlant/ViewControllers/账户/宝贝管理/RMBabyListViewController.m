//
//  RMBabyListViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBabyListViewController.h"
#import "RMBabyListTableViewCell.h"
#import "RefreshControl.h"
#import "RefreshView.h"
#import "UIViewController+HUD.h"
#import "RMAFNRequestManager.h"
#import "RMUserLoginInfoManager.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
@interface RMBabyListViewController ()<RefreshControlDelegate>{

}
@property (nonatomic, strong) RefreshControl * refreshControl;

@end

@implementation RMBabyListViewController
@synthesize pageCount,isLoadComplete;
@synthesize refreshControl;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    pageCount = 1;
    isLoadComplete = NO;
    babyArray = [[NSMutableArray alloc]init];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [babyArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMBabyListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMBabyListTableViewCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMBabyListTableViewCell" owner:self options:nil] lastObject];
        [cell.modify_btn addTarget:self action:@selector(modify_btnAction:) forControlEvents:UIControlEventTouchDown];
        [cell.delete_btn addTarget:self action:@selector(delete_btnAction:) forControlEvents:UIControlEventTouchDown];
        [cell.shelves_btn addTarget:self action:@selector(shelves_btnAction:) forControlEvents:UIControlEventTouchDown];
    }

    if([babyArray count]>0){
        RMPublicModel * model = [babyArray objectAtIndex:indexPath.row];
        [cell.content_img sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:[UIImage imageNamed:@"nophote"]];
        cell.content_name.text = model.content_name;
        cell.content_price.text = model.content_price;
        if([model.is_shelf boolValue]){
            [cell.shelves_btn setTitle:@"下架" forState:UIControlStateNormal];
            cell.delete_btn.hidden = YES;
            cell.modify_btn.hidden = YES;
        }else{
            [cell.shelves_btn setTitle:@"上架" forState:UIControlStateNormal];
                cell.delete_btn.hidden = NO;
                cell.modify_btn.hidden = NO;
                cell.deleteWidth.constant = 35;
        }
//        if([model.publish boolValue]){//已审核
//            cell.delete_btn.hidden = YES;
//            cell.modify_btn.hidden = YES;
//        }else{//未审核
//            cell.delete_btn.hidden = NO;
//            cell.modify_btn.hidden = NO;
//            cell.deleteWidth.constant = 35;
//        }
        

    }
    cell.modify_btn.tag = 100*indexPath.row;
    cell.shelves_btn.tag = 100*indexPath.row+1;
    cell.delete_btn.tag  =100*indexPath.row+2;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
        [babyArray removeAllObjects];
        [self requestDataWithPageCount:1];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        pageCount ++;
        [self requestDataWithPageCount:pageCount];
    }
}

- (void)requestDataWithPageCount:(NSInteger)page{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager corpBabyListWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] memberclass:self.member_class is_shelf:self.is_shelf Page:page  andCallBack:^(NSError *error, BOOL success, id object) {
        if(page == 1){
            [babyArray removeAllObjects];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            if([object isKindOfClass:[RMPublicModel class]]){//模型类
                RMPublicModel * model = object;
                if(model.status){
                    if(page == 1){
                        [self showHint:@"您还没有发布宝贝噢！"];
                        [refreshControl finishRefreshingDirection:RefreshDirectionTop];
                    }else{
                        [self showHint:@"没有更多宝贝啦！"];
                        [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                    }
                }else{
                    [self showHint:model.msg];
                }
            }else{//数组
                [babyArray addObjectsFromArray:object];
                if(page == 1){
                    [refreshControl finishRefreshingDirection:RefreshDirectionTop];
                    isLoadComplete = YES;

                }else{
                    [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                }
            }
        }else{
            [self showHint:object];
        }
        [_mTableView reloadData];
    }];
}
#pragma mark - 修改宝贝发布信息
- (void)modify_btnAction:(UIButton *)sender{
    RMPublicModel * model = [babyArray objectAtIndex:sender.tag
                             /100];
    if(self.modifycallback){
        _modifycallback (model);
    }
}
#pragma mark - 删除宝贝
- (void)delete_btnAction:(UIButton *)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    RMPublicModel * model = [babyArray objectAtIndex:sender.tag
                             /100];
    [RMAFNRequestManager babyDeleteOperationWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Autoid:model.auto_code andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * _model = object;
            if(_model.status){
                [babyArray removeObject:model];
            }else{
                
            }
            [self showHint:_model.msg];
        }else{
            [self showHint:object];
        }
    }];
}
#pragma mark - 上下架宝贝
- (void)shelves_btnAction:(UIButton *)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    RMPublicModel * model = [babyArray objectAtIndex:sender.tag
                             /100];
    BOOL isup ;
    if([model.is_shelf boolValue]){
        isup = NO;
    }else{
        isup = YES;
    }
    
    [RMAFNRequestManager babyShelfOperationWithUser:[[RMUserLoginInfoManager loginmanager]user] Pwd:[[RMUserLoginInfoManager loginmanager]pwd] upShelf:isup Autoid:model.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        RMPublicModel * _model = object;
        if(success){
            if(_model.status){
                model.is_shelf = [NSString stringWithFormat:@"%d",![model.is_shelf boolValue]];
                [babyArray removeObject:model];
            }else{
                
            }
            [self showHint:_model.msg];
            [_mTableView reloadData];
        }else{
            [self showHint:object];
        }
    }];
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
