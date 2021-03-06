//
//  RMOrderListViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMOrderListViewController.h"

#import "RMOrderBottomTableViewCell.h"
#import "CONST.h"
#import "RefreshControl.h"
#import "RefreshView.h"
#import "UIViewController+HUD.h"
#import "RMOrderReturnEditView.h"

#import "RMOrderHeadTableViewCell.h"
#import "RMOrderDetailProTableViewCell.h"
#import "RMOrderLeaveMsgTableViewCell.h"
#import "RMOrderDetailNumTableViewCell.h"
#import "RMOrderAddressTableViewCell.h"
#import "RMOederDetailOperationTableViewCell.h"
#import "RMOrderDetailEvaluateTableViewCell.h"
#import "UIAlertView+Expland.h"
@interface RMOrderListViewController ()<RefreshControlDelegate,UITextFieldDelegate>{
    
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

//if([model.is_status integerValue] == 1){
//    cell.order_status.text = @"待发货";
//}else if ([model.is_status integerValue] == 2){
//    cell.order_status.text = @"已发货";
//}else if ([model.is_status integerValue] == 3){
//    cell.order_status.text = @"已签收";
//}else if ([model.is_status integerValue] == 4){
//    cell.order_status.text = @"已取消";
//}else if ([model.is_status integerValue] == 5){
//    cell.order_status.text = @"已完成";
//}else{ == 0
//    cell.order_status.text = @"未处理";
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    RMPublicModel * model = [orderlists objectAtIndex:section];
    if([_order_type isEqualToString:@"unorder"]){
        if([model.is_status integerValue] == 0){//未处理
            return [model.pros count] + 5;
        }else { //([model.is_status integerValue] == 1){//待发货
            return [model.pros count] + 4;
        }
        
    }else if ([_order_type isEqualToString:@"unpayorder"]){
        return [model.pros count] + 5;
    }else if ([_order_type isEqualToString:@"onorder"]){
        if([model.is_status integerValue] == 2){//已发货
            return [model.pros count] + 5;
        }else{//[model.is_status integerValue] == 3 已签收,显示产品退货按钮
            return [model.pros count] + 4;
        }
    }else if ([_order_type isEqualToString:@"okorder"]){
        if([model.is_comment boolValue]){
            return [model.pros count] + 5;
        }else{
            return [model.pros count] + 6;
        }
    }else{//退货
        if([model.is_status isEqualToString:@"0"] || [model.is_status isEqualToString:@"2"]){//同意或者已经退货了待签收
            return  1+2+1;
        }else{
            return 1+2;

        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMPublicModel * model = [orderlists objectAtIndex:indexPath.section];

    if(indexPath.row == 0){
    
        RMOrderHeadTableViewCell * headcell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderHeadTableViewCell"];
        if(headcell == nil){
            headcell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderHeadTableViewCell" owner:self options:nil] lastObject];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goCorp:)];
            headcell.corp_name.userInteractionEnabled = YES;
            [headcell.corp_name addGestureRecognizer:tap];
        }
        
        headcell.corp_name.tag = indexPath.section+100;
        headcell.corp_name.text = OBJC_Nil([model.corp objectForKey:@"content_name"]);
        headcell.create_time.text = model.create_time;
        headcell.order_status.text = model.content_status;
        return headcell;
    }else{
        
        if([_order_type isEqualToString:@"unorder"]){
            if([model.is_status integerValue] == 0){//未处理
                if(indexPath.row == [model.pros count] +5-1){
                    //操作
                    RMOederDetailOperationTableViewCell * operationcell = [self getRMOederDetailOperationTableViewCell:indexPath];
                    operationcell.leftBtn.hidden = YES;
                    operationcell.rightBtn.hidden = NO;
                    [operationcell.rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    return operationcell;
                }else if(indexPath.row == [model.pros count]+5-2){
                //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    addresscell.bottom_line.hidden = NO;
                    addresscell.content_name.text = model.content_linkname;
                    addresscell.content_mobile.text = model.content_mobile;
                    addresscell.content_address.text = model.content_address;
                    return addresscell;
                }else if (indexPath.row == [model.pros count]+5-3){
                    //和
                    RMOrderDetailNumTableViewCell * numcell = [self getRMOrderDetailNumTableViewCell:indexPath];
                    int num = 0;
                    for(NSDictionary * prodic in [model pros]){
                        num += [[prodic objectForKey:@"content_num"] integerValue];
                    }
                    numcell.totalNumL.text = [NSString stringWithFormat:@"%d",num];
                    numcell.totalMoneyL.text = model.content_total;
                    numcell.content_realpayL.text = model.content_realPay;
                    numcell.express_price.text = [NSString stringWithFormat:@"含运费%@",model.expresspay];
                    
                    return numcell;
                }else if (indexPath.row == [model.pros count]+5-4){
                    //留言
                    RMOrderLeaveMsgTableViewCell * leavecell = [self getRMOrderLeaveMsgTableViewCell:indexPath];
                    leavecell.leaveMsg.text = model.order_message;

                    return leavecell;
                }else{
                    NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
                    RMOrderDetailProTableViewCell * procell = [self getRMOrderDetailProTableViewCell:indexPath];
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                    procell.content_price.text = OBJC_Nil([prodic objectForKey:@"single_price"]);
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                    return procell;
                }
            }else { //([model.is_status integerValue] == 1){//待发货
                if(indexPath.row == [model.pros count]+4-1){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    addresscell.bottom_line.hidden = YES;
                    addresscell.content_name.text = model.content_linkname;
                    addresscell.content_mobile.text = model.content_mobile;
                    addresscell.content_address.text = model.content_address;
                    return addresscell;
                }else if (indexPath.row == [model.pros count]+4-2){
                    //和
                    RMOrderDetailNumTableViewCell * numcell = [self getRMOrderDetailNumTableViewCell:indexPath];

                    int num = 0;
                    for(NSDictionary * prodic in [model pros]){
                        num += [[prodic objectForKey:@"content_num"] integerValue];
                    }
                    numcell.totalNumL.text = [NSString stringWithFormat:@"%d",num];
                    numcell.totalMoneyL.text = model.content_total;
                    numcell.content_realpayL.text = model.content_realPay;
                    numcell.express_price.text = [NSString stringWithFormat:@"含运费%@",model.expresspay];
                    return numcell;
                }else if (indexPath.row == [model.pros count]+4-3){
                    //留言
                    RMOrderLeaveMsgTableViewCell * leavecell = [self getRMOrderLeaveMsgTableViewCell:indexPath];

                    leavecell.leaveMsg.text = model.order_message;
                    return leavecell;
                }else{
                    NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
                    RMOrderDetailProTableViewCell * procell = [self getRMOrderDetailProTableViewCell:indexPath];

                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                    procell.content_price.text = OBJC_Nil([prodic objectForKey:@"single_price"]);
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                    return procell;
                }
            }
            
        }else if ([_order_type isEqualToString:@"unpayorder"]){
            if(indexPath.row == [model.pros count] +5-1){
                //操作
                RMOederDetailOperationTableViewCell * operationcell = [self getRMOederDetailOperationTableViewCell:indexPath];

                operationcell.leftBtn.hidden = NO;
                operationcell.rightBtn.hidden = NO;
                [operationcell.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [operationcell.rightBtn setTitle:@"去付款" forState:UIControlStateNormal];
                return operationcell;
            }else if(indexPath.row == [model.pros count]+5-2){
                //地址
                RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                addresscell.bottom_line.hidden = YES;
                addresscell.content_name.text = model.content_linkname;
                addresscell.content_mobile.text = model.content_mobile;
                addresscell.content_address.text = model.content_address;
                return addresscell;
            }else if (indexPath.row == [model.pros count]+5-3){
                //和
                RMOrderDetailNumTableViewCell * numcell = [self getRMOrderDetailNumTableViewCell:indexPath];

                int num = 0;
                for(NSDictionary * prodic in [model pros]){
                    num += [[prodic objectForKey:@"content_num"] integerValue];
                }
                numcell.totalNumL.text = [NSString stringWithFormat:@"%d",num];
                numcell.totalMoneyL.text = model.content_total;
                numcell.content_realpayL.text = model.content_realPay;
                numcell.express_price.text = [NSString stringWithFormat:@"含运费%@",model.expresspay];
                return numcell;
            }else if (indexPath.row == [model.pros count]+5-4){
                //留言
                RMOrderLeaveMsgTableViewCell * leavecell = [self getRMOrderLeaveMsgTableViewCell:indexPath];

                leavecell.leaveMsg.text = model.order_message;
                return leavecell;
            }else{
                NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
                RMOrderDetailProTableViewCell * procell = [self getRMOrderDetailProTableViewCell:indexPath];

                [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                procell.content_price.text = OBJC_Nil([prodic objectForKey:@"single_price"]);
                procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                return procell;
            }
        }else if ([_order_type isEqualToString:@"onorder"]){
            if([model.is_status integerValue] == 2){//已发货
                if(indexPath.row == [model.pros count] +5-1){
                    //操作
                    RMOederDetailOperationTableViewCell * operationcell = [self getRMOederDetailOperationTableViewCell:indexPath];

                    operationcell.leftBtn.hidden = NO;
                    operationcell.rightBtn.hidden = NO;
                    [operationcell.leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [operationcell.rightBtn setTitle:@"确认签收" forState:UIControlStateNormal];
                    return operationcell;
                }else if(indexPath.row == [model.pros count]+5-2){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    addresscell.bottom_line.hidden = NO;
                    addresscell.content_name.text = model.content_linkname;
                    addresscell.content_mobile.text = model.content_mobile;
                    addresscell.content_address.text = model.content_address;
                    return addresscell;
                }else if (indexPath.row == [model.pros count]+5-3){
                    //和
                    RMOrderDetailNumTableViewCell * numcell = [self getRMOrderDetailNumTableViewCell:indexPath];

                    int num = 0;
                    for(NSDictionary * prodic in [model pros]){
                        num += [[prodic objectForKey:@"content_num"] integerValue];
                    }
                    numcell.totalNumL.text = [NSString stringWithFormat:@"%d",num];
                    numcell.totalMoneyL.text = model.content_total;
                    numcell.content_realpayL.text = model.content_realPay;
                    numcell.express_price.text = [NSString stringWithFormat:@"含运费%@",model.expresspay];
                    return numcell;
                }else if (indexPath.row == [model.pros count]+5-4){
                    //留言
                    RMOrderLeaveMsgTableViewCell * leavecell = [self getRMOrderLeaveMsgTableViewCell:indexPath];

                    leavecell.leaveMsg.text = model.order_message;
                    return leavecell;
                }else{
                    NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
                    RMOrderDetailProTableViewCell * procell = [self getRMOrderDetailProTableViewCell:indexPath];
                    procell.returnBtn.hidden = YES;
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                    procell.content_price.text = OBJC_Nil([prodic objectForKey:@"single_price"]);
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                    return procell;
                }
            }else{//[model.is_status integerValue] == 3 已签收,显示产品退货按钮
                if(indexPath.row == [model.pros count]+4-1){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    addresscell.bottom_line.hidden = YES;
                    addresscell.content_name.text = model.content_linkname;
                    addresscell.content_mobile.text = model.content_mobile;
                    addresscell.content_address.text = model.content_address;
                    return addresscell;
                }else if (indexPath.row == [model.pros count]+4-2){
                    //和
                    RMOrderDetailNumTableViewCell * numcell = [self getRMOrderDetailNumTableViewCell:indexPath];

                    int num = 0;
                    for(NSDictionary * prodic in [model pros]){
                        num += [[prodic objectForKey:@"content_num"] integerValue];
                    }
                    numcell.totalNumL.text = [NSString stringWithFormat:@"%d",num];
                    numcell.totalMoneyL.text = model.content_total;
                    numcell.content_realpayL.text = model.content_realPay;
                    numcell.express_price.text = [NSString stringWithFormat:@"含运费%@",model.expresspay];
                    return numcell;
                }else if (indexPath.row == [model.pros count]+4-3){
                    //留言
                    RMOrderLeaveMsgTableViewCell * leavecell = [self getRMOrderLeaveMsgTableViewCell:indexPath];

                    leavecell.leaveMsg.text = model.order_message;
                    return leavecell;
                }else{
                    RMOrderDetailProTableViewCell * procell = [self getRMOrderDetailProTableViewCell:indexPath];

                    procell.returnBtn.hidden = NO;
                    NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];

                    if([[prodic objectForKey:@"is_return"]boolValue]){
                        procell.returnBtn.enabled = NO;
                        [procell.returnBtn setTitle:@"已申请退货" forState:UIControlStateNormal];
                    }else{
                        procell.returnBtn.enabled = YES;
                        [procell.returnBtn setTitle:@"申请退货" forState:UIControlStateNormal];
                    }
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                    procell.content_price.text = OBJC_Nil([prodic objectForKey:@"single_price"]);
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                    return procell;
                }
            }
        }else if ([_order_type isEqualToString:@"okorder"]){
            if([model.is_comment boolValue]){
                if(indexPath.row == [model.pros count] +5-1){
                   RMOrderDetailEvaluateTableViewCell * evaluatecell = [self getRMOrderDetailEvaluateTableViewCell:indexPath];
                    NSInteger n = [model.comment_num integerValue];
                    //                    banImg
                    //                    generalImg
                    //                    goodImg
                    //                    pefectImg
                    evaluatecell.bottom_line.hidden = YES;
                    UIButton * btn = (UIButton *)[evaluatecell.contentView viewWithTag:1000*indexPath.section+n-1];
                    [btn setImage:[UIImage imageNamed:@"order_yellow_sun"] forState:UIControlStateNormal];
                    evaluatecell.userInteractionEnabled = NO;
                    return evaluatecell;
                }else if(indexPath.row == [model.pros count]+5-2){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    addresscell.bottom_line.hidden = NO;
                    addresscell.content_name.text = model.content_linkname;
                    addresscell.content_mobile.text = model.content_mobile;
                    addresscell.content_address.text = model.content_address;
                    return addresscell;
                }else if (indexPath.row == [model.pros count]+5-3){
                    //和
                    RMOrderDetailNumTableViewCell * numcell = [self getRMOrderDetailNumTableViewCell:indexPath];

                    int num = 0;
                    for(NSDictionary * prodic in [model pros]){
                        num += [[prodic objectForKey:@"content_num"] integerValue];
                    }
                    numcell.totalNumL.text = [NSString stringWithFormat:@"%d",num];
                    numcell.totalMoneyL.text = model.content_total;
                    numcell.content_realpayL.text = model.content_realPay;
                    numcell.express_price.text = [NSString stringWithFormat:@"含运费%@",model.expresspay];
                    return numcell;
                }else if (indexPath.row == [model.pros count]+5-4){
                    //留言
                    RMOrderLeaveMsgTableViewCell * leavecell = [self getRMOrderLeaveMsgTableViewCell:indexPath];

                    leavecell.leaveMsg.text = model.order_message;
                    return leavecell;
                }else{
                    RMOrderDetailProTableViewCell * procell = [self getRMOrderDetailProTableViewCell:indexPath];

                    NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                    procell.content_price.text = OBJC_Nil([prodic objectForKey:@"single_price"]);
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                    procell.fieldHeght.constant = 30;
                    procell.evaluateTextField.userInteractionEnabled = NO;
                    procell.evaluateTextField.text = [[model.pros objectAtIndex:indexPath.row-1] objectForKey:@"comment_desc"];
                    return procell;
                }
            }else{
                if(indexPath.row == [model.pros count] +6-1){
                    //操作
                    RMOederDetailOperationTableViewCell * operationcell = [self getRMOederDetailOperationTableViewCell:indexPath];

                    operationcell.leftBtn.hidden = YES;
                    operationcell.rightBtn.hidden = NO;
                    [operationcell.rightBtn setTitle:@"我要评价" forState:UIControlStateNormal];
                    return operationcell;
                }else if(indexPath.row == [model.pros count] +6-2){
                    RMOrderDetailEvaluateTableViewCell * evaluatecell = [self getRMOrderDetailEvaluateTableViewCell:indexPath];
                    NSInteger n = [model.comment_num integerValue];
                    //                    banImg
                    //                    generalImg
                    //                    goodImg
                    //                    pefectImg
                    evaluatecell.bottom_line.hidden = NO;
                    evaluatecell.userInteractionEnabled = YES;
                    UIButton * btn = (UIButton *)[evaluatecell.contentView viewWithTag:1000*indexPath.section+n-1];
                    [btn setImage:[UIImage imageNamed:@"order_yellow_sun"] forState:UIControlStateNormal];
                    return evaluatecell;
                }else if(indexPath.row == [model.pros count]+6-3){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    addresscell.bottom_line.hidden = NO;
                    addresscell.content_name.text = model.content_linkname;
                    addresscell.content_mobile.text = model.content_mobile;
                    addresscell.content_address.text = model.content_address;
                    return addresscell;
                }else if (indexPath.row == [model.pros count]+6-4){
                    //和
                    RMOrderDetailNumTableViewCell * numcell = [self getRMOrderDetailNumTableViewCell:indexPath];

                    int num = 0;
                    for(NSDictionary * prodic in [model pros]){
                        num += [[prodic objectForKey:@"content_num"] integerValue];
                    }
                    numcell.totalNumL.text = [NSString stringWithFormat:@"%d",num];
                    numcell.totalMoneyL.text = model.content_total;
                    numcell.content_realpayL.text = model.content_realPay;
                    numcell.express_price.text = [NSString stringWithFormat:@"含运费%@",model.expresspay];
                    return numcell;
                }else if (indexPath.row == [model.pros count]+6-5){
                    //留言
                    RMOrderLeaveMsgTableViewCell * leavecell = [self getRMOrderLeaveMsgTableViewCell:indexPath];
                    leavecell.leaveMsg.text = model.order_message;
                    return leavecell;
                }else{
                    RMOrderDetailProTableViewCell * procell = [self getRMOrderDetailProTableViewCell:indexPath];
                    NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                    procell.content_price.text = OBJC_Nil([prodic objectForKey:@"single_price"]);
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                    procell.fieldHeght.constant = 30;
                    procell.evaluateTextField.userInteractionEnabled = YES;
                    procell.evaluateTextField.text = [[model.pros objectAtIndex:indexPath.row-1] objectForKey:@"comment_desc"];
                    return procell;
                }
            }
        }else{//退货
            
            if([model.is_status isEqualToString:@"0"] || [model.is_status isEqualToString:@"2"]){
                if(indexPath.row == 1 +2+1-1){
                    //操作
                    RMOederDetailOperationTableViewCell * operationcell = [self getRMOederDetailOperationTableViewCell:indexPath];
                    
                    operationcell.leftBtn.hidden = YES;
                    operationcell.rightBtn.hidden = NO;
                    if([model.is_status isEqualToString:@"0"]){
                        [operationcell.rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    }else{
                        [operationcell.rightBtn setTitle:@"退货" forState:UIControlStateNormal];
                    }
                    return operationcell;

                }else if(indexPath.row == 1 +2+1-2){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    addresscell.bottom_line.hidden = YES;
                    addresscell.content_name.text = [model.corp objectForKey:@"content_name"];
                    addresscell.content_mobile.text = [model.corp objectForKey:@"content_mobile"];
                    addresscell.content_address.text = [model.corp objectForKey:@"content_address"];
                    return addresscell;
                }else{
                    RMOrderDetailProTableViewCell * procell = [self getRMOrderDetailProTableViewCell:indexPath];
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = model.content_name;
                    procell.content_price.text = model.content_price;
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil(model.content_num)];
                    procell.fieldHeght.constant = 0;
                    
                    return procell;
                }

                
            }else{
                if(indexPath.row == 1 +2-1){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    addresscell.bottom_line.hidden = YES;
                    addresscell.content_name.text = [model.corp objectForKey:@"content_name"];
                    addresscell.content_mobile.text = [model.corp objectForKey:@"content_mobile"];
                    addresscell.content_address.text = [model.corp objectForKey:@"content_address"];
                    return addresscell;
                }else{
                    RMOrderDetailProTableViewCell * procell = [self getRMOrderDetailProTableViewCell:indexPath];
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = model.content_name;
                    procell.content_price.text = model.content_price;
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil(model.content_num)];
                    procell.fieldHeght.constant = 0;
                    
                    return procell;
                }

            }
            
        }
    }
}
//RMOrderDetailProTableViewCell.h
//RMOrderLeaveMsgTableViewCell.h
//RMOrderDetailNumTableViewCell.h
//RMOrderAddressTableViewCell.h
//RMOederDetailOperationTableViewCell.h
//RMOrderDetailEvaluateTableViewCell.h
- (RMOrderDetailProTableViewCell *)getRMOrderDetailProTableViewCell:(NSIndexPath *)indexPath{
    RMOrderDetailProTableViewCell * procell = [_maintableView dequeueReusableCellWithIdentifier:@"RMOrderDetailProTableViewCell"];
    if(procell == nil){
        procell = [[[NSBundle mainBundle]loadNibNamed:@"RMOrderDetailProTableViewCell" owner:self options:nil] lastObject];
        procell.returnBtn.hidden = YES;
        [procell.returnBtn addTarget:self action:@selector(iWantToReturn:) forControlEvents:UIControlEventTouchDown];
        procell.fieldHeght.constant = 0;
    }
    procell.returnBtn.tag = indexPath.section*1000+indexPath.row;
    procell.evaluateTextField.tag = indexPath.section*100+1+indexPath.row;
    procell.evaluateTextField.delegate = self;
    return procell;
}

- (RMOrderLeaveMsgTableViewCell *)getRMOrderLeaveMsgTableViewCell:(NSIndexPath *)indexPath{
    RMOrderLeaveMsgTableViewCell * leavecell = [_maintableView dequeueReusableCellWithIdentifier:@"RMOrderLeaveMsgTableViewCell"];
    if(leavecell == nil){
        leavecell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderLeaveMsgTableViewCell" owner:self options:nil] lastObject];
        leavecell.leaveMsg.userInteractionEnabled = NO;
    }
    return leavecell;
}

- (RMOrderDetailNumTableViewCell *)getRMOrderDetailNumTableViewCell:(NSIndexPath *)indexPath{
    RMOrderDetailNumTableViewCell * numcell = [_maintableView dequeueReusableCellWithIdentifier:@"RMOrderDetailNumTableViewCell"];
    if(numcell == nil){
        numcell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderDetailNumTableViewCell" owner:self options:nil] lastObject];
    }
    return numcell;
}

- (RMOrderAddressTableViewCell *)getRMOrderAddressTableViewCell:(NSIndexPath *)indexPath{
    RMOrderAddressTableViewCell * addresscell = [_maintableView dequeueReusableCellWithIdentifier:@"RMOrderAddressTableViewCell"];
    if(addresscell == nil){
        addresscell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderAddressTableViewCell" owner:self options:nil] lastObject];
    }
    return addresscell;
}

- (RMOederDetailOperationTableViewCell *)getRMOederDetailOperationTableViewCell:(NSIndexPath *)indexPath{
    RMOederDetailOperationTableViewCell * operationcell = [_maintableView dequeueReusableCellWithIdentifier:@"RMOederDetailOperationTableViewCell"];
    if(operationcell == nil){
        operationcell = [[[NSBundle mainBundle] loadNibNamed:@"RMOederDetailOperationTableViewCell" owner:self options:nil] lastObject];
        
        [operationcell.rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchDown];
        [operationcell.leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchDown];
    }
    operationcell.leftBtn.tag = indexPath.section*100;
    operationcell.rightBtn.tag = indexPath.section*100+1;
    return operationcell;
}

- (RMOrderDetailEvaluateTableViewCell *)getRMOrderDetailEvaluateTableViewCell:(NSIndexPath *)indexPath{
    RMOrderDetailEvaluateTableViewCell * evaluatecell = [_maintableView dequeueReusableCellWithIdentifier:@"RMOrderDetailEvaluateTableViewCell"];
    if(evaluatecell == nil){
        evaluatecell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderDetailEvaluateTableViewCell" owner:self options:nil] lastObject];
        for(int i = 0;i<4;i++){
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(evaluateAction:)];
            UILabel * label = (UILabel *)[evaluatecell.contentView viewWithTag:100+i];
            [label addGestureRecognizer:tap];
        }
        
        
    }
    evaluatecell.bad.tag = indexPath.section*100;
    evaluatecell.general.tag = indexPath.section*100 + 1;
    evaluatecell.good.tag = indexPath.section*100 + 2;
    evaluatecell.pefect.tag = indexPath.section*100 + 3;
    
    evaluatecell.banImg.tag = indexPath.section * 1000;
    evaluatecell.generalImg.tag = indexPath.section * 1000 + 1;
    evaluatecell.goodImg.tag = indexPath.section * 1000 + 2;
    evaluatecell.pefectImg.tag = indexPath.section * 1000 + 3;
    return evaluatecell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMPublicModel * model = [orderlists objectAtIndex:indexPath.section];
    if(indexPath.row == 0){
               return 52.0f;
    }else{
        
        if([_order_type isEqualToString:@"unorder"]){
            if([model.is_status integerValue] == 0){//未处理
                if(indexPath.row == [model.pros count] +5-1){
                    //操作
                  
                    return 40.0f;
                }else if(indexPath.row == [model.pros count]+5-2){
                    //地址
                  
                    return 55.0f;
                }else if (indexPath.row == [model.pros count]+5-3){
                    //和
                   
                    
                    return 38.0f;
                }else if (indexPath.row == [model.pros count]+5-4){
                    //留言
                    
                    return 39.0f;
                }else{
                    
                    return 80;
                }
            }else { //([model.is_status integerValue] == 1){//待发货
                if(indexPath.row == [model.pros count]+4-1){
                    //地址
                    
                    return 55.0f;
                }else if (indexPath.row == [model.pros count]+4-2){
                    //和
                   
                    return 38.0f;
                }else if (indexPath.row == [model.pros count]+4-3){
                    //留言
                    return 39.0f;
                }else{
                    
                    return 80;
                }
            }
            
        }else if ([_order_type isEqualToString:@"unpayorder"]){
            if(indexPath.row == [model.pros count] +5-1){
                //操作
              
                return 40.f;
            }else if(indexPath.row == [model.pros count]+5-2){
                //地址
                
                return 55.f;
            }else if (indexPath.row == [model.pros count]+5-3){
                //和
               
                return 38.f;
            }else if (indexPath.row == [model.pros count]+5-4){
                //留言
                return 39.f;
            }else{
               
                return 80.f;
            }
        }else if ([_order_type isEqualToString:@"onorder"]){
            if([model.is_status integerValue] == 2){//已发货
                if(indexPath.row == [model.pros count] +5-1){
                    //操作
                    
                    return 40.f;
                }else if(indexPath.row == [model.pros count]+5-2){
                    //地址
               
                    return 55.f;
                }else if (indexPath.row == [model.pros count]+5-3){
                    //和
                   
                    return 38.f;
                }else if (indexPath.row == [model.pros count]+5-4){
                    //留言
                    return 39.f;
                }else{
                   
                    return 80.f;
                }
            }else{//[model.is_status integerValue] == 3 已签收,显示产品退货按钮
                if(indexPath.row == [model.pros count]+4-1){
                    //地址
    
                    return 55.f;
                }else if (indexPath.row == [model.pros count]+4-2){
                    return 38.f;
                }else if (indexPath.row == [model.pros count]+4-3){
                    //留言
                    return 39.f;
                }else{
                    return 80.f;
                }
            }
        }else if ([_order_type isEqualToString:@"okorder"]){
            if([model.is_comment boolValue]){
                if(indexPath.row == [model.pros count] +5-1){
                    return 36.f;
                }else if(indexPath.row == [model.pros count]+5-2){
                    //地址
                    return 55.f;
                }else if (indexPath.row == [model.pros count]+5-3){
                    //和
                    return 38.f;
                }else if (indexPath.row == [model.pros count]+5-4){
                    //留言
                    return 39.f;
                }else{
                    
                    return 110.f;
                }
            }else{
                if(indexPath.row == [model.pros count] +6-1){
                    //操作
                    return 40.f;
                }else if(indexPath.row == [model.pros count] +6-2){
                    
                    return 36.f;
                }else if(indexPath.row == [model.pros count]+6-3){
                    return 55.f;
                }else if (indexPath.row == [model.pros count]+6-4){
                    //和
                    return 38.f;
                }else if (indexPath.row == [model.pros count]+6-5){
                    return 39.f;
                }else{
                    return 110.f;
                }
            }
        }else{//退货
            if([model.is_status isEqualToString:@"0"] || [model.is_status isEqualToString:@"2"]){
                if(indexPath.row == 1 +2+1-1){
                    return 40.f;
                }else if(indexPath.row == 1 +2+1-2){
                    return 55.f;
                }else{
                    return 80.f;;
                }
            }else{
                if(indexPath.row == 1 +2-1){
                    return 55.f;
                }else{
                    return 80.f;
                }
            }
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == [orderlists count]-1){
        return 10;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    RMPublicModel * model = [orderlists objectAtIndex:indexPath.section];
//    model.content_type = self.order_type;
//    if(self.didSelectCellcallback){
//        _didSelectCellcallback(model);
//    }
}


#pragma mark - 评价
- (void)evaluateAction:(UITapGestureRecognizer *)sender{
    NSInteger n = sender.view.tag/100;
    NSInteger m = sender.view.tag%100;
    RMPublicModel * model = [orderlists objectAtIndex:n];
    model.comment_num = [NSString stringWithFormat:@"%ld",m+1];
//    [_maintableView reloadData];
    RMOrderDetailEvaluateTableViewCell * cell = (RMOrderDetailEvaluateTableViewCell *)[_maintableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[model.pros count]+4 inSection:n]];
    for(UIButton * btn in cell.contentView.subviews){
        if([btn isKindOfClass:[UIButton class]]){
            if(btn.tag == n*1000 + sender.view.tag%100){
                [btn setImage:[UIImage imageNamed:@"order_yellow_sun"] forState:UIControlStateNormal];
            }
            else{
                [btn setImage:[UIImage imageNamed:@"order_gray_sun"] forState:UIControlStateNormal];
            }
        }
        
    }
    
    NSLog(@"333333%@",model);
    
    [orderlists replaceObjectAtIndex:n withObject:model];
    
        NSLog(@"44444%@",model);
    
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%ld",(long)textField.tag);
    NSInteger n = textField.tag/100;
    RMPublicModel * model = [orderlists objectAtIndex:n];
    NSLog(@"1111111%@",model.pros);
    model.comment_num = [NSString stringWithFormat:@"%ld",n+1];
    NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:model.pros];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:[model.pros objectAtIndex:textField.tag%100-1-1]];
    [dic setValue:textField.text forKey:@"comment_desc"];
    [arr replaceObjectAtIndex:textField.tag%100-1-1 withObject:dic];
    model.pros = [NSArray arrayWithArray:arr];
    NSLog(@"2222222%@",model.pros);
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
        if([model.is_status integerValue] == 3){//已签收
            
        }else{
            //确认签收
            [self sureReceiver:model];
        }
    }else if ([_order_type isEqualToString:@"okorder"]){
        //发表评价
        [self publishEvaluate:model];
    }else if ([_order_type isEqualToString:@"returnorder"]){
        if([model.is_status isEqualToString:@"0"]){
            //产看物流
            [self seeLogistics:model];
        }else{
            //退货操作
            [self returnGoods:model];
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

- (void)iWantToReturn:(UIButton *)sender{
    RMPublicModel * model = [orderlists objectAtIndex:sender.tag/1000];
    NSDictionary * dic = [model.pros objectAtIndex:sender.tag%1000-1];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要申请退货吗？" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    [alert show];
    
    [alert handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
        if(btnIndex == 0){
        
        }else{
            //执行申请退货的申请
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [RMAFNRequestManager memberReturnApplyWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Auto_id:[dic objectForKey:@"orderpro_id"] andCallBack:^(NSError *error, BOOL success, id object) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if(success){
                    RMPublicModel * model = object;
                    [self showHint:model.msg];
                    pageCount = 1;
                    [self requestData];
                }else{
                    [self showHint:object];
                }
            }];
        }
    }];
    
//    RMPublicModel * model = [orderlists objectAtIndex:sender.tag/1000];
//    NSDictionary * dic = [model.pros objectAtIndex:sender.tag%1000-1];
//    [self showReturnEditView:model withDic:dic];
}


#pragma mark - 退货
- (void)returnGoods:(RMPublicModel *)model{
    [self showReturnEditView:model withDic:nil];
}

- (void)showReturnEditView:(RMPublicModel *)model withDic:(NSDictionary *)prodic{
    
    UIControl * cover = [[UIControl alloc]initWithFrame:_maintableView.frame];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction:)];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.25;
    cover.tag = 101311;
    [cover addGestureRecognizer:tap];
    [self.view addSubview:cover];
    
    if(returnEditView == nil){
        returnEditView = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderReturnEditView" owner:self options:nil] lastObject];
        returnEditView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenWidth*220.0/320.0);
        [returnEditView.commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchDown];
    }
    
    returnEditView._model = model;
    returnEditView.content_name.text = [model.corp objectForKey:@"content_name"];
    returnEditView.content_mobile.text = [model.corp objectForKey:@"content_mobile"];
    returnEditView.content_address.text = [model.corp objectForKey:@"content_address"];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        returnEditView.frame = CGRectMake(0, _maintableView.frame.size.height-(kScreenWidth*220.0/320.0), kScreenWidth, kScreenWidth*220.0/320.0);
        [self.view addSubview:returnEditView];
    }];
}

- (void)dismissAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.3 animations:^{
        UIControl * cover = (UIControl *)[self.view viewWithTag:101311];
        [cover removeFromSuperview];
        returnEditView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenWidth*220.0/320.0);
        returnEditView.expressName.text = nil;
        returnEditView.express_price.text = nil;//这里实际上是快递单号，不是价格，
    }];
    
}

- (void)commit{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(returnEditView.express_price.text.length == 0 || returnEditView.expressName.text.length == 0){
        [self showHint:@"请输入快递公司和单号"];
        return;
    }
    if(self.startRequest){
        self.startRequest();
    }
    [RMAFNRequestManager memberReturnGoodsOrSureDeliveryWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] isReturn:YES orderId:[returnEditView._model auto_id] expressName:[returnEditView.expressName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] expressId:returnEditView.express_price.text andCallBack:^(NSError *error, BOOL success, id object) {
        if(self.finishedRequest){
            self.finishedRequest();
        }
        if(success){
            RMPublicModel * model = object;
            if(model.status){
                //申请成功
                pageCount = 1;
                [self dismissAction:nil];
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
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定取消该订单吗？" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
    [alert show];
    
    [alert handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
        if(btnIndex == 1){
            if(self.startRequest){
                self.startRequest();
            }
            [RMAFNRequestManager memberCancelOrSureOrderWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] iscancel:YES orderId:model.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
                //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if(self.finishedRequest){
                    self.finishedRequest();
                }
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
    
    
//    NSString * autoidStr = @"";
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    int i = 0;
    for(NSDictionary * dic in model.pros){
//        autoidStr = [autoidStr stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"orderpro_id"]]];
        if([[model.pros objectAtIndex:i] objectForKey:@"comment_desc"] == nil || [[[model.pros objectAtIndex:i] objectForKey:@"comment_desc"] length] == 0){
            [self showHint:@"请对没有文字评价的宝贝进行填写！"];
            return;
        }
        [dict setValue:[[model.pros objectAtIndex:i] objectForKey:@"comment_desc"] forKey:[NSString stringWithFormat:@"comment_desc[%d]",i]];
        [dict setValue:[[model.pros objectAtIndex:i] objectForKey:@"orderpro_id"] forKey:[NSString stringWithFormat:@"auto_id[%d]",i]];
        i++;
    }
    
    NSLog(@"+++++%@",dict);

    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(self.startRequest){
        self.startRequest();
    }
    [RMAFNRequestManager iwantEvaulateOrderWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Orderid:model.auto_id Comment_num:model.comment_num auto_idStr:nil Comment_desc:dict andCallBack:^(NSError *error, BOOL success, id object) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(self.finishedRequest){
            self.finishedRequest();
        }
        if(success){
            RMPublicModel * model = object;
            if(model.status){
                pageCount = 1;
                [self requestData];
            }else{
                
            }
            [_maintableView reloadData];
        }else{
            [self showHint:object];
        }
    }];
}

#pragma mark -确认签收
- (void)sureReceiver:(RMPublicModel *)model{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要签收吗？" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
    [alert show];
    [alert handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
        if(btnIndex == 1){
            if(self.startRequest){
                self.startRequest();
            }
            [RMAFNRequestManager memberCancelOrSureOrderWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] iscancel:NO orderId:model.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
                //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if(self.finishedRequest){
                    self.finishedRequest();
                }
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
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    BOOL iscorp ;
//    if([[[RMUserLoginInfoManager loginmanager] isCorp] isEqualToString:@"1"]){
//        iscorp = NO;
//    }else{
//        iscorp = YES;
//    }
    if(self.startRequest){
        self.startRequest();
    }
    [RMAFNRequestManager myOrderListRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] isCorp:NO type:self.order_type Page:pageCount andCallBack:^(NSError *error, BOOL success, id object) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(self.finishedRequest){
            self.finishedRequest ();
        }
        if(success){
            if(pageCount == 1){
                [orderlists removeAllObjects];
                [orderlists addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
                if([(NSArray *)object count] == 0){
                    [self showHint:@"暂无订单"];
                }
            }else{
                [orderlists addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                if([(NSArray *)object count] == 0){
                    [self showHint:@"没有更多订单了"];
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
