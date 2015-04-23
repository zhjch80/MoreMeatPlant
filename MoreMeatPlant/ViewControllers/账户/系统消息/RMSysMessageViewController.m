//
//  RMSysMessageViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/4.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMSysMessageViewController.h"
#import "RMSysMessageTableViewCell.h"

@interface RMSysMessageViewController ()<RefreshControlDelegate>{
    NSInteger pageCount;
}
@property (nonatomic, strong) RefreshControl * refreshControl;

@end

@implementation RMSysMessageViewController
@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"系统消息"];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mainTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    pageCount = 1;
    
    [self initPlat];
}

- (void)initPlat{
    self.view.backgroundColor = [UIColor clearColor];
    messageArray = [[NSMutableArray alloc]init];
    _mainTableView.opaque = NO;
    _mainTableView.backgroundColor = [UIColor clearColor];
    
    [self requestData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messageArray count]*2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row%2 != 0){
        RMSysMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMSysMessageTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMSysMessageTableViewCell" owner:self options:nil] lastObject];
        }

        RMPublicModel * model = [messageArray objectAtIndex:indexPath.row/2];
//        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:[UIImage imageNamed:@"nophote"]];
        cell.titleL.text = model.msg_title;
        cell.subtitleL.text = model.msg_text;
        cell.readStateL.text = model.msg_read;
        if([model.msg_read isEqualToString:@"未读"]){
            [cell.detailImgV setImage:[UIImage imageNamed:@"detail_arrow_red"]];
        }else{
            [cell.detailImgV setImage:[UIImage imageNamed:@"detail_arrow"]];
        }
        cell.timeL.text = model.create_time;
        return cell;
    }
    else{
        UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row%2 != 0){
        return 44;
    }
    else{
        return 10.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.didselect_callback){
        RMPublicModel * model = [messageArray objectAtIndex:indexPath.row/2];
        _didselect_callback(model.auto_id);
    }
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            if(self.callback){
                _callback(self);
            }
            break;
        }
        case 2:{
            
            break;
        }
            
        default:
            break;
    }
}

- (void)requestData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager systemMessageWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] page:pageCount andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            if(pageCount == 1){
                [messageArray removeAllObjects];
                [messageArray addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
                if([object count] == 0){
                    [MBProgressHUD showSuccess:@"暂无消息" toView:self.view];
                    
                }
            }else{
                [messageArray addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                if([object count] == 0){
                    [MBProgressHUD showSuccess:@"没有更多消息了" toView:self.view];
                    pageCount--;
                }
            }
            

        }else{
                    [self showHint:object];
        }
        
        [_mainTableView reloadData];
       
    }];
}

#pragma mark 刷新代理
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
        [self requestData];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
            pageCount ++;
           [self requestData];
        
    }
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
