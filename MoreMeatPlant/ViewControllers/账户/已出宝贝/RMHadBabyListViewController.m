//
//  RMHadBabyListViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMHadBabyListViewController.h"
#import "RMOrderProTableViewCell.h"
#import "RMOrderHeadTableViewCell.h"
#import "RMHadbabyTableViewCell.h"
#import "RefreshControl.h"
#import "RefreshView.h"
#import "UIViewController+HUD.h"
#import "RMOrderReturnEditView.h"
#import "CONST.h"
#import "AppDelegate.h"

@interface RMHadBabyListViewController ()<RefreshControlDelegate>{
    BOOL isRefresh;
    BOOL isLoadComplete;
    RMOrderReturnEditView * returnEditView;
}
@property (nonatomic, strong) RefreshControl * refreshControl;
@end

@implementation RMHadBabyListViewController
@synthesize refreshControl;
@synthesize dataarray;
@synthesize pageCount;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.mTableView];
    
    dataarray = [[NSMutableArray alloc]init];
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    pageCount = 1;
    isRefresh = YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [dataarray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    RMPublicModel * model = [dataarray objectAtIndex:section];
    return [model.pros count]+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMPublicModel * model = [dataarray objectAtIndex:indexPath.section];
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
        RMHadbabyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMHadbabyTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMHadbabyTableViewCell" owner:self options:nil] lastObject];
            cell.leaveMsg.userInteractionEnabled = NO;
            cell.note.userInteractionEnabled = NO;
            [cell.btn_right addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchDown];
            [cell.left_btn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchDown];
        }
        
        cell.left_btn.tag = indexPath.section*1000+1;
        cell.btn_right.tag = indexPath.section*1000+2;
        
        int num = 0;
        for(NSDictionary * prodic in [model pros]){
            num += [[prodic objectForKey:@"content_num"] integerValue];
        }
        cell.content_num.text = [NSString stringWithFormat:@"%d",num];
        cell.total_money.text = model.content_total;
        cell.realy_total.text = model.content_realPay;
        cell.express.text = [NSString stringWithFormat:@"含运费%@",model.expresspay];
        cell.content_name.text = model.content_linkname;
        cell.content_mobile.text = model.content_mobile;
        cell.content_address.text = model.content_address;
        cell.leaveMsg.text = model.order_message;
        
        if([_order_type isEqualToString:@"unorder"]){
            cell.left_btn.hidden = NO;
            cell.btn_right.hidden = NO;
            if([model.is_status integerValue] == 0){//未处理
                [cell.left_btn setTitle:@"联系买家" forState:UIControlStateNormal];
                [cell.btn_right setTitle:@"开始备货" forState:UIControlStateNormal];
                
            }else{
                [cell.left_btn setTitle:@"联系买家" forState:UIControlStateNormal];
                [cell.btn_right setTitle:@"点击发货" forState:UIControlStateNormal];
            }
            
            
        }else if ([_order_type isEqualToString:@"unpayorder"]){
            cell.left_btn.hidden = YES;
            cell.btn_right.hidden = YES;

        }else if ([_order_type isEqualToString:@"onorder"]){
            cell.left_btn.hidden = YES;
            cell.btn_right.hidden = NO;
//            [cell.left_btn setTitle:@"联系买家" forState:UIControlStateNormal];
            [cell.btn_right setTitle:@"查看物流" forState:UIControlStateNormal];
        }else if ([_order_type isEqualToString:@"okorder"]){
            cell.left_btn.hidden = YES;
            cell.btn_right.hidden = YES;
        }else if ([_order_type isEqualToString:@"returnorder"]){
            cell.left_btn.hidden = YES;
            cell.btn_right.hidden = NO;
            if([model.is_return boolValue]){//已经退货签收
                cell.btn_right.hidden = YES;
            }else{//待签收
                [cell.btn_right setTitle:@"确认签收" forState:UIControlStateNormal];
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
    RMPublicModel * model = [dataarray objectAtIndex:indexPath.section];
    if(indexPath.row == 0){
        return 30;
    }else if (indexPath.row == [model.pros count]+1){
        return 193;
    }else{
        return 70;
    }
}
#pragma mark - 进入店铺
- (void)goCorp:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag-100;
    
    if(self.goCorp_callback){
        self.goCorp_callback ([dataarray objectAtIndex:tag]);
    }
}

#pragma mark - 订单操作
- (void)rightAction:(UIButton *)sender{
    RMPublicModel *model = [dataarray objectAtIndex:sender.tag/1000];
    if([_order_type isEqualToString:@"unorder"]){
        if([model.is_status integerValue] == 0){//未处理
            [self startBh:model];
        }else{
            //发货
            [self deliveryAction:model];
        }
        
    }else if ([_order_type isEqualToString:@"unpayorder"]){
        //什么操作也没有
    }else if ([_order_type isEqualToString:@"onorder"]){
        //查看物流
        [self seeLogistics:model];
    }else if ([_order_type isEqualToString:@"okorder"]){
        
    }else if([_order_type isEqualToString:@"returnorder"]){
        //确认签收
        [self sureReceiver:model];
    }
}

- (void)leftAction:(UIButton *)sender{
    RMPublicModel *model = [dataarray objectAtIndex:sender.tag/100];
    if([_order_type isEqualToString:@"unorder"]){
        [self contactUser:model];
    }else if ([_order_type isEqualToString:@"unpayorder"]){
        
    }else if ([_order_type isEqualToString:@"onorder"]){
        
    }else if ([_order_type isEqualToString:@"okorder"]){
        
    }else if ([_order_type isEqualToString:@"returnorder"]){
        
    }
}

#pragma mark - 联系买家
- (void)contactUser:(RMPublicModel *)model{
    [self.navigationController popToRootViewControllerAnimated:NO];
    AppDelegate * dele = [[UIApplication sharedApplication] delegate];
    [dele tabSelectController:3];
    [dele.talkMoreCtl._chatListVC jumpToChatView:model.member_user];

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


#pragma mark - 查看物流
- (void)seeLogistics:(RMPublicModel *)model{
    if(self.seeLogistics_callback){
        _seeLogistics_callback (model);
    }
}

#pragma mark - 点击发货
- (void)deliveryAction:(RMPublicModel *)model{
    //这里应该是调用接口
    [self showReturnEditView:model];
}

#pragma mark -确认签收
- (void)sureReceiver:(RMPublicModel *)model{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager memberCancelOrSureOrderWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] iscancel:NO orderId:model.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * _model = object;
            if(_model.status){
                //
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

#pragma mark - 备货
- (void)startBh:(RMPublicModel *)model{
    [RMAFNRequestManager corpStockUpProductWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] orderId:model.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
        if(success){
            RMPublicModel * model = object;
            if(model.status){
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


#pragma mark - 显示发货信息填写
- (void)showReturnEditView:(RMPublicModel *)model{
    
    UIControl * cover = [[UIControl alloc]initWithFrame:_mTableView.frame];
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


#pragma mark - 
- (void)seeExpress:(UIButton *)sender{
    [self seeLogistics:returnEditView._model];
}

#pragma mark - 提交
- (void)commit{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager memberReturnGoodsOrSureDeliveryWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] isReturn:NO orderId:returnEditView._model.auto_id expressName:[returnEditView.expressName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] expressId:returnEditView.express_price.text andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * model = object;
            if(model.status){
                //发货成功
                [self dismissAction:nil];
                pageCount = 1;
                [self requestData];
            }
            [self showHint:model.msg];
        }else{
            [self showHint:object];
        }
    }];
}


#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager myOrderListRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] isCorp:NO type:self.order_type Page:pageCount andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(pageCount == 1){
                [dataarray removeAllObjects];
                [dataarray addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
                if([object count] == 0){
                    [MBProgressHUD showSuccess:@"暂无订单" toView:self.view];
                    
                }
            }else{
                [dataarray addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                if([object count] == 0){
                    [MBProgressHUD showSuccess:@"没有更多订单了" toView:self.view];
                    pageCount--;
                }
            }
            
            
        }else{
            [self showHint:object];
        }
        
        [_mTableView reloadData];
    }];
}

- (void)requestData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager myOrderListRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] isCorp:NO type:self.order_type Page:pageCount andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(pageCount == 1){
                [dataarray removeAllObjects];
                [dataarray addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
                if([object count] == 0){
                    [MBProgressHUD showSuccess:@"暂无订单" toView:self.view];
                    
                }
            }else{
                [dataarray addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                if([object count] == 0){
                    [MBProgressHUD showSuccess:@"没有更多订单了" toView:self.view];
                    pageCount--;
                }
            }
            
            
        }else{
            [self showHint:object];
        }
        
        [_mTableView reloadData];
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
