//
//  RMOrderListViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMOrderListViewController.h"
#import "RMOrderHeadTableViewCell.h"
#import "RMOrderProTableViewCell.h"
#import "RMOrderBottomTableViewCell.h"
#import "CONST.h"
#import "RefreshControl.h"
#import "RefreshView.h"
#import "UIViewController+HUD.h"
#import "RMOrderReturnEditView.h"

@interface RMOrderListViewController ()<RefreshControlDelegate>{
    
    BOOL isRefresh;
    RMOrderReturnEditView * returnEditView;
}
@property (nonatomic, strong) RefreshControl * refreshControl;

@end

@implementation RMOrderListViewController
@synthesize refreshControl,pageCount;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    
    _maintableView.backgroundColor = [UIColor clearColor];
    _maintableView.opaque = NO;
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:_maintableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    pageCount = 1;
    isRefresh = YES;
    
    orderlists = [[NSMutableArray alloc]init];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [orderlists count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    RMPublicModel * model = [orderlists objectAtIndex:section];
    return [model.pros count]+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMPublicModel * model = [orderlists objectAtIndex:indexPath.section];
    if(indexPath.row == 0){
    
        RMOrderHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderHeadTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderHeadTableViewCell" owner:self options:nil] lastObject];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goCorp:)];
            cell.corp_name.userInteractionEnabled = YES;
            [cell.corp_name addGestureRecognizer:tap];
        }
        cell.corp_name.tag = indexPath.section+100;
        cell.corp_name.text = OBJC_Nil([model.corp objectForKey:@"content_name"]);
        cell.create_time.text = model.create_time;
        if([model.is_paystatus boolValue]){
            if([model.is_status integerValue] == 1){
                 cell.order_status.text = @"待发货";
            }else if ([model.is_status integerValue] == 2){
                 cell.order_status.text = @"已发货";
            }else if ([model.is_status integerValue] == 3){
                 cell.order_status.text = @"已签收";
            }else if ([model.is_status integerValue] == 4){
                 cell.order_status.text = @"已取消";
            }else if ([model.is_status integerValue] == 5){
                 cell.order_status.text = @"已完成";
            }else{
                cell.order_status.text = @"未处理";
            }
        }else{
            cell.order_status.text = @"待付款";
        }
        
        return cell;
    }else if (indexPath.row == [model.pros count]+1){
        RMOrderBottomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderBottomTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderBottomTableViewCell" owner:self options:nil] lastObject];
            [cell.rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchDown];
            [cell.leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchDown];
        }
        cell.leftBtn.tag = indexPath.section*100;
        cell.rightBtn.tag = indexPath.section*100+1;
        int num = 0;
        for(NSDictionary * prodic in [model pros]){
            num += [[prodic objectForKey:@"content_num"] integerValue];
        }
        cell.totalNumL.text = [NSString stringWithFormat:@"%d",num];
        cell.totalMoneyL.text = model.content_total;
        cell.content_realpayL.text = model.content_realPay;
        cell.express_price.text = [NSString stringWithFormat:@"含运费%@",model.expresspay];

        if([_order_type isEqualToString:@"unorder"]){
            cell.leftBtn.hidden = YES;
            cell.rightBtn.hidden = NO;
            [cell.rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];

        }else if ([_order_type isEqualToString:@"unpayorder"]){
            cell.leftBtn.hidden = NO;
            cell.rightBtn.hidden = NO;
            [cell.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cell.rightBtn setTitle:@"去付款" forState:UIControlStateNormal];
        }else if ([_order_type isEqualToString:@"onorder"]){
            cell.leftBtn.hidden = NO;
            cell.rightBtn.hidden = NO;
            [cell.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [cell.leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        }else if ([_order_type isEqualToString:@"okorder"]){
            
            NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
            if([[prodic objectForKey:@"is_commit"] boolValue]){
                cell.leftBtn.hidden = YES;
                cell.rightBtn.hidden = YES;
            }else{
                cell.leftBtn.hidden = YES;
                cell.rightBtn.hidden = NO;
                [cell.rightBtn setTitle:@"发表评论" forState:UIControlStateNormal];
            }

        }else if ([_order_type isEqualToString:@"returnorder"]){
            cell.leftBtn.hidden = YES;
            cell.rightBtn.hidden = NO;
            if([model.is_return boolValue]){//已经退货签收
                cell.rightBtn.hidden = YES;
            }else{//待签收
                [cell.rightBtn setTitle:@"申请退货" forState:UIControlStateNormal];
            }
            
        }
        return cell;
    }else{
        RMOrderProTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderProTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderProTableViewCell" owner:self options:nil] lastObject];
        }
        NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
        [cell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
        cell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
        cell.content_price.text = OBJC_Nil([prodic objectForKey:@"content_price"]);
        cell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMPublicModel * model = [orderlists objectAtIndex:indexPath.section];
    if(indexPath.row == 0){
        return 30;
    }else if (indexPath.row == [model.pros count]+1){
        return 62;
    }else{
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RMPublicModel * model = [orderlists objectAtIndex:indexPath.section];
    model.content_type = self.order_type;
    if(self.didSelectCellcallback){
        _didSelectCellcallback(model);
    }
}

#pragma mark - 进入店铺
- (void)goCorp:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag-100;
    
    if(self.goCorp_callback){
        self.goCorp_callback ([orderlists objectAtIndex:tag]);
    }
}

#pragma mark - 订单操作
- (void)rightAction:(UIButton *)sender{
    RMPublicModel *model = [orderlists objectAtIndex:sender.tag/100];
    if([_order_type isEqualToString:@"unorder"]){
        //取消订单
        [self cancelOrder:model];
    }else if ([_order_type isEqualToString:@"unpayorder"]){
        //去付款
        [self goPay:model];
    }else if ([_order_type isEqualToString:@"onorder"]){
        //确认签收
        [self sureReceiver:model];
    }else if ([_order_type isEqualToString:@"okorder"]){
        //发表评价
        [self publishEvaluate:model];
    }else if ([_order_type isEqualToString:@"returnorder"]){
        if([model.is_return boolValue]){
        
        }else{
            [self applyReturn:model];
        }
    }
}

- (void)leftAction:(UIButton *)sender{
    RMPublicModel *model = [orderlists objectAtIndex:sender.tag/100];
    if([_order_type isEqualToString:@"unorder"]){
        
    }else if ([_order_type isEqualToString:@"unpayorder"]){
        //取消订单
        [self cancelOrder:model];
    }else if ([_order_type isEqualToString:@"onorder"]){
        //查看物流
        [self seeLogistics:model];
    }else if ([_order_type isEqualToString:@"okorder"]){
        
    }
}
#pragma mark - 申请退货
- (void)applyReturn:(RMPublicModel *)model{
    [self showReturnEditView:model];
}

- (void)showReturnEditView:(RMPublicModel *)model{
    
    UIControl * cover = [[UIControl alloc]initWithFrame:_maintableView.frame];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction:)];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.25;
    cover.tag = 101311;
    [cover addGestureRecognizer:tap];
    [self.view addSubview:cover];
    
    if(returnEditView == nil){
        returnEditView = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderReturnEditView_1" owner:self options:nil] lastObject];
        returnEditView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenWidth*206.0/320.0 + 64 +49);
        [returnEditView.seeBtn addTarget:self action:@selector(seeExpress:) forControlEvents:UIControlEventTouchDown];
        [returnEditView.commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchDown];
    }
    
    returnEditView._model = model;
    returnEditView.expressName.text = model.express_name;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        returnEditView.frame = CGRectMake(0, kScreenHeight-kScreenWidth*206.0/320.0-  64 -49, kScreenWidth, kScreenWidth*206.0/320.0 + 64 +49);
        
        [self.view addSubview:returnEditView];
    }];
}

- (void)dismissAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.3 animations:^{
        UIControl * cover = (UIControl *)[self.view viewWithTag:101311];
        [cover removeFromSuperview];
        returnEditView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenWidth*206.0/320.0 + 64 +49);
        returnEditView.expressName.text = nil;
        returnEditView.express_price.text = nil;//这里实际上是快递单号，不是价格，
    }];
    
}


- (void)commit{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager memberReturnGoodsOrSureDeliveryWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] isReturn:YES orderId:returnEditView._model.auto_id expressName:[returnEditView._model.express_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] expressId:returnEditView.express_price.text andCallBack:^(NSError *error, BOOL success, id object) {
        
        if(success){
            RMPublicModel * model = object;
            if(model.status){
                //申请成功
                pageCount = 1;
                [self requestData];
            }else{
                
            }
            [self showHint:model.msg];
        }else{
            [self showHint:object];
        }
    }];
}


#pragma mark - 取消订单
- (void)cancelOrder:(RMPublicModel *)model{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager memberCancelOrSureOrderWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] iscancel:YES orderId:model.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * _model = object;
            if(_model.status){
                pageCount = 1;
                [self requestData];
            }else{
            
            }
            [self showHint:_model.msg];
        }else{
            [self showHint:object];
        }
    }];
}

#pragma mark - 去付款
- (void)goPay:(RMPublicModel *)model{
    if(self.gopay_callback){
        _gopay_callback (model);
    }
}

#pragma mark - 查看物流
- (void)seeLogistics:(RMPublicModel *)model{
    if(self.seeLogistics_callback){
        _seeLogistics_callback (model);
    }
}

#pragma mark - 发表评论
- (void)publishEvaluate:(RMPublicModel *)model{
    //这里应该是调用接口
}

#pragma mark -确认签收
- (void)sureReceiver:(RMPublicModel *)model{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager memberCancelOrSureOrderWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] iscancel:NO orderId:model.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * _model = object;
            if(_model.status){
                
            }else{
                
            }
            [self showHint:_model.msg];
        }else{
            [self showHint:object];
        }
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


- (void)requestData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager myOrderListRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] isCorp:NO type:self.order_type Page:pageCount andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(pageCount == 1){
                [orderlists removeAllObjects];
                [orderlists addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
                if([object count] == 0){
                    [MBProgressHUD showSuccess:@"暂无订单" toView:self.view];
                    
                }
            }else{
                [orderlists addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                if([object count] == 0){
                    [MBProgressHUD showSuccess:@"没有更多订单了" toView:self.view];
                    pageCount--;
                }
            }
            
            
        }else{
                    [self showHint:object];
        }
        
        [_maintableView reloadData];
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
