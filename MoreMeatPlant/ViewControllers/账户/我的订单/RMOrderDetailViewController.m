//
//  RMOrderDetailViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/22.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMOrderDetailViewController.h"
#import "RMOrderHeadTableViewCell.h"
#import "RMOrderDetailProTableViewCell.h"
#import "RMOrderDetailNumTableViewCell.h"
#import "RMOrderDetailEvaluateTableViewCell.h"
#import "RMOederDetailOperationTableViewCell.h"
#import "RMOrderReturnEditView.h"
#import "RMAliPayViewController.h"
#import "RMSeeLogisticsViewController.h"
#import "RMMyCorpViewController.h"
@interface RMOrderDetailViewController (){
    RMOrderReturnEditView * returnEditView;
    NSString * evaluate_level;
}

@end

@implementation RMOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"订单详情"];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    evaluate_level = @"3";
    
//    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.mTableView];
}

- (void)showReturnEditView{
    
    UIControl * cover = [[UIControl alloc]initWithFrame:_mTableView.frame];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction:)];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.25;
    cover.tag = 101311;
    [cover addGestureRecognizer:tap];
    [self.view addSubview:cover];
    
    if(returnEditView == nil){
        returnEditView = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderReturnEditView" owner:self options:nil] lastObject];
        returnEditView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 206);
    }

    
    [UIView animateWithDuration:0.3 animations:^{
        
               returnEditView.frame = CGRectMake(0, kScreenHeight-206, kScreenWidth, 206);

        [self.view addSubview:returnEditView];
    }];
}

- (void)dismissAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.3 animations:^{
        UIControl * cover = (UIControl *)[self.view viewWithTag:101311];
        [cover removeFromSuperview];
        returnEditView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 206);
        returnEditView.expressName.text = nil;
        returnEditView.express_price.text = nil;//这里实际上是快递单号，不是价格，
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [__model.pros count]+4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        RMOrderHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderHeadTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderHeadTableViewCell" owner:self options:nil] lastObject];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goCorp:)];
            cell.corp_name.userInteractionEnabled = YES;
            [cell.corp_name addGestureRecognizer:tap];

        }
        cell.corp_name.tag = indexPath.section+100;
        cell.corp_name.text = OBJC_Nil([__model.corp objectForKey:@"content_name"]);
        cell.create_time.text = __model.create_time;
        if([__model.is_paystatus boolValue]){
            if([__model.is_status integerValue] == 1){
                cell.order_status.text = @"待发货";
            }else if ([__model.is_status integerValue] == 2){
                cell.order_status.text = @"已发货";
            }else if ([__model.is_status integerValue] == 3){
                cell.order_status.text = @"已签收";
            }else if ([__model.is_status integerValue] == 4){
                cell.order_status.text = @"已取消";
            }else if ([__model.is_status integerValue] == 5){
                cell.order_status.text = @"已完成";
            }
        }else{
            cell.order_status.text = @"待付款";
        }
        return cell;
    }else if (indexPath.row == [__model.pros count]+4-3){
        RMOrderDetailNumTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderDetailNumTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderDetailNumTableViewCell" owner:self options:nil] lastObject];
        }
        
        int num = 0;
        for(NSDictionary * prodic in [__model pros]){
            num += [[prodic objectForKey:@"content_num"] integerValue];
        }
        cell.totalNumL.text = [NSString stringWithFormat:@"%d",num];
        cell.totalMoneyL.text = __model.content_total;
        cell.content_realpayL.text = __model.content_realPay;
        cell.express_price.text = [NSString stringWithFormat:@"含运费%@",__model.expresspay];
        return cell;
    }else if (indexPath.row == [__model.pros count]+4-2){
        RMOrderDetailEvaluateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderDetailEvaluateTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderDetailEvaluateTableViewCell" owner:self options:nil] lastObject];
            
            for(int i = 0;i<4;i++){
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(evaluateAction:)];
                UILabel * label = (UILabel *)[cell.contentView viewWithTag:100+i];
                [label addGestureRecognizer:tap];
            }
        }
        NSDictionary * prodic = [__model.pros objectAtIndex:0];
        if([[prodic objectForKey:@"is_commit"] boolValue]){
            cell.bad.userInteractionEnabled = NO;
            cell.general.userInteractionEnabled = NO;
            cell.good.userInteractionEnabled = NO;
            cell.pefect.userInteractionEnabled = NO;
        }else{
            cell.bad.userInteractionEnabled = YES;
            cell.general.userInteractionEnabled = YES;
            cell.good.userInteractionEnabled = YES;
            cell.pefect.userInteractionEnabled = YES;
        }
        //order_yellow_sun
        [cell.banImg setImage:[UIImage imageNamed:@"order_gray_sun"] forState:UIControlStateNormal];
        [cell.generalImg setImage:[UIImage imageNamed:@"order_gray_sun"] forState:UIControlStateNormal];
        [cell.goodImg setImage:[UIImage imageNamed:@"order_gray_sun"] forState:UIControlStateNormal];
        [cell.pefectImg setImage:[UIImage imageNamed:@"order_gray_sun"] forState:UIControlStateNormal];
        switch ([evaluate_level integerValue]) {
            case 0:
            {
                [cell.banImg setImage:[UIImage imageNamed:@"order_yellow_sun"] forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [cell.generalImg setImage:[UIImage imageNamed:@"order_yellow_sun"] forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [cell.goodImg setImage:[UIImage imageNamed:@"order_yellow_sun"] forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
                [cell.pefectImg setImage:[UIImage imageNamed:@"order_yellow_sun"] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }else if (indexPath.row == [__model.pros count]+4-1){
        RMOederDetailOperationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOederDetailOperationTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOederDetailOperationTableViewCell" owner:self options:nil] lastObject];
            [cell.rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchDown];
            [cell.leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchDown];
            }
       
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
            NSDictionary * prodic = [__model.pros objectAtIndex:0];
            if([[prodic objectForKey:@"is_commit"] boolValue]){
                cell.leftBtn.hidden = YES;
                cell.rightBtn.hidden = YES;
            }else{
                cell.leftBtn.hidden = YES;
                cell.rightBtn.hidden = NO;
                [cell.rightBtn setTitle:@"发表评论" forState:UIControlStateNormal];
            }
            
        }

        return cell;
    }else{
        RMOrderDetailProTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderDetailProTableViewCell"];
        if(cell == nil){
            cell =[[[NSBundle mainBundle] loadNibNamed:@"RMOrderDetailProTableViewCell" owner:self options:nil] lastObject];
            [cell.returnBtn addTarget:self action:@selector(iWantToReturn:) forControlEvents:UIControlEventTouchDown];
        }
        NSLog(@"%@,%ld",__model.pros,(long)indexPath.row);
        NSDictionary * prodic = [__model.pros objectAtIndex:indexPath.row-1];
        [cell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
        cell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
        cell.content_price.text = OBJC_Nil([prodic objectForKey:@"content_price"]);
        cell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
        if([[prodic objectForKey:@"is_status"] integerValue] == 5){
            cell.returnBtn.hidden = NO;
        }else{
            cell.returnBtn.hidden = YES;
        }
        if(/* DISABLES CODE */ (1)){
            cell.fieldHeght.constant = 0;
        }else{
            cell.fieldHeght.constant = 30;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 30;
    }else if (indexPath.row == [__model.pros count]+4-3){
        return 38;
    }else if (indexPath.row == [__model.pros count]+4-2){
        return 36;
    }else if (indexPath.row == [__model.pros count]+4-1){
        return 40;
    }else{
        if(1){
            return 80;
        }else{
            return 110;
        }
        
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
    [self.view endEditing:YES];
}


#pragma mark - 进入店铺
- (void)goCorp:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag-100;
    
    RMMyCorpViewController * corp = [[RMMyCorpViewController alloc] initWithNibName:@"RMMyCorpViewController" bundle:nil];
    corp.auto_id = [[__model.pros lastObject] objectForKey:@"corp_id"];
    [self.navigationController pushViewController:corp animated:YES];
}


#pragma mark - 订单操作
- (void)rightAction:(UIButton *)sender{
    if([_order_type isEqualToString:@"unorder"]){
        //取消订单
        [self cancelOrder:__model];
    }else if ([_order_type isEqualToString:@"unpayorder"]){
        //去付款
        [self goPay:__model];
    }else if ([_order_type isEqualToString:@"onorder"]){
        //确认签收
        [self sureReceiver:__model];
    }else if ([_order_type isEqualToString:@"okorder"]){
        //发表评价
        [self publishEvaluate:__model];
    }
}

- (void)leftAction:(UIButton *)sender{
    if([_order_type isEqualToString:@"unorder"]){
        
    }else if ([_order_type isEqualToString:@"unpayorder"]){
        //取消订单
        [self cancelOrder:__model];
    }else if ([_order_type isEqualToString:@"onorder"]){
        //查看物流
        [self seeLogistics:__model];
    }else if ([_order_type isEqualToString:@"okorder"]){
        
    }
}

#pragma mark - 取消订单
- (void)cancelOrder:(RMPublicModel *)model{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager memberCancelOrSureOrderWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] iscancel:YES orderId:model.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * _model = object;
            if(_model.status){
                //刷新界面，然后发送完成通知
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
    //去付款
    RMAliPayViewController * alipay = [[RMAliPayViewController alloc]initWithNibName:@"RMAliPayViewController" bundle:nil];
    alipay.is_direct = NO;
    alipay.order_id = model.content_sn;//支付宝支付的订单号
    [self.navigationController pushViewController:alipay animated:YES];
}

#pragma mark - 查看物流
- (void)seeLogistics:(RMPublicModel *)model{
    //查看物流
    //查看物流信息
    RMSeeLogisticsViewController * see = [[RMSeeLogisticsViewController alloc]initWithNibName:@"RMSeeLogisticsViewController" bundle:nil];
    see.express_name = model.express_name;
    see.express_no = model.express_no;
    [self.navigationController pushViewController:see animated:YES];
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

- (void)evaluateAction:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    evaluate_level = [NSString stringWithFormat:@"%ld",(long)tag-100];
    [_mTableView reloadData];
}

- (void)iWantToReturn:(UIButton *)sender{
    [self showReturnEditView];
}

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
