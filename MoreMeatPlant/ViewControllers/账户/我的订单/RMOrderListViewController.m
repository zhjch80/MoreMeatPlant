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
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMPublicModel * model = [orderlists objectAtIndex:indexPath.section];
    
    
    
    RMOrderDetailProTableViewCell * procell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderDetailProTableViewCell"];
    if(procell == nil){
        procell = [[[NSBundle mainBundle]loadNibNamed:@"RMOrderDetailProTableViewCell" owner:self options:nil] lastObject];
        procell.returnBtn.hidden = YES;
        [procell.returnBtn addTarget:self action:@selector(iWantToReturn:) forControlEvents:UIControlEventTouchDown];
        procell.fieldHeght.constant = 0;
    }
    procell.returnBtn.tag = indexPath.section*1000+indexPath.row;
    
    RMOrderLeaveMsgTableViewCell * leavecell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderLeaveMsgTableViewCell"];
    if(leavecell == nil){
        leavecell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderLeaveMsgTableViewCell" owner:self options:nil] lastObject];
        leavecell.leaveMsg.userInteractionEnabled = NO;
    }
    
    RMOrderDetailNumTableViewCell * numcell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderDetailNumTableViewCell"];
    if(numcell == nil){
        numcell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderDetailNumTableViewCell" owner:self options:nil] lastObject];
    }
    
    RMOrderAddressTableViewCell * addresscell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderAddressTableViewCell"];
    if(addresscell == nil){
        addresscell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderAddressTableViewCell" owner:self options:nil] lastObject];
    }
    
    RMOrderDetailEvaluateTableViewCell * evaluatecell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderDetailEvaluateTableViewCell"];
    if(evaluatecell == nil){
        evaluatecell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderDetailEvaluateTableViewCell" owner:self options:nil] lastObject];
        for(int i = 0;i<4;i++){
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(evaluateAction:)];
            UILabel * label = (UILabel *)[evaluatecell.contentView viewWithTag:100+i];
            [label addGestureRecognizer:tap];
        }
    }
    
    RMOederDetailOperationTableViewCell * operationcell = [tableView dequeueReusableCellWithIdentifier:@"RMOederDetailOperationTableViewCell"];
    if(operationcell == nil){
        operationcell = [[[NSBundle mainBundle] loadNibNamed:@"RMOederDetailOperationTableViewCell" owner:self options:nil] lastObject];
        
        [operationcell.rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchDown];
        [operationcell.leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchDown];
    }
    
    operationcell.leftBtn.tag = indexPath.section*100;
    operationcell.rightBtn.tag = indexPath.section*100+1;
    
    RMOrderHeadTableViewCell * headcell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderHeadTableViewCell"];
    if(headcell == nil){
        headcell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderHeadTableViewCell" owner:self options:nil] lastObject];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goCorp:)];
        headcell.corp_name.userInteractionEnabled = YES;
        [headcell.corp_name addGestureRecognizer:tap];
    }
    
    
    if(indexPath.row == 0){
    
        headcell.corp_name.tag = indexPath.section+100;
        headcell.corp_name.text = OBJC_Nil([model.corp objectForKey:@"content_name"]);
        headcell.create_time.text = model.create_time;
        if([model.is_paystatus boolValue]){
            if([model.is_status integerValue] == 1){
                 headcell.order_status.text = @"待发货";
            }else if ([model.is_status integerValue] == 2){
                 headcell.order_status.text = @"已发货";
            }else if ([model.is_status integerValue] == 3){
                 headcell.order_status.text = @"已签收";
            }else if ([model.is_status integerValue] == 4){
                 headcell.order_status.text = @"已取消";
            }else if ([model.is_status integerValue] == 5){
                 headcell.order_status.text = @"已完成";
            }else{
                headcell.order_status.text = @"未处理";
            }
        }else{
            headcell.order_status.text = @"待付款";
        }
        return headcell;
    }else{
        
        if([_order_type isEqualToString:@"unorder"]){
            if([model.is_status integerValue] == 0){//未处理
                if(indexPath.row == [model.pros count] +5-1){
                    //操作
                    operationcell.leftBtn.hidden = YES;
                    operationcell.rightBtn.hidden = NO;
                    [operationcell.rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    return operationcell;
                }else if(indexPath.row == [model.pros count]+5-2){
                //地址
                    addresscell.content_name.text = model.content_linkname;
                    addresscell.content_mobile.text = model.content_mobile;
                    addresscell.content_address.text = model.content_address;
                    return addresscell;
                }else if (indexPath.row == [model.pros count]+5-3){
                    //和
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
                    leavecell.leaveMsg.text = model.order_message;

                    return leavecell;
                }else{
                    NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                    procell.content_price.text = OBJC_Nil([prodic objectForKey:@"content_price"]);
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                    return procell;
                }
            }else { //([model.is_status integerValue] == 1){//待发货
                if(indexPath.row == [model.pros count]+4-1){
                    //地址
                    addresscell.content_name.text = model.content_linkname;
                    addresscell.content_mobile.text = model.content_mobile;
                    addresscell.content_address.text = model.content_address;
                    return addresscell;
                }else if (indexPath.row == [model.pros count]+4-2){
                    //和
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
                    leavecell.leaveMsg.text = model.order_message;
                    return leavecell;
                }else{
                    NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                    procell.content_price.text = OBJC_Nil([prodic objectForKey:@"content_price"]);
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                    return procell;
                }
            }
            
        }else if ([_order_type isEqualToString:@"unpayorder"]){
            if(indexPath.row == [model.pros count] +5-1){
                //操作
                operationcell.leftBtn.hidden = NO;
                operationcell.rightBtn.hidden = NO;
                [operationcell.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [operationcell.rightBtn setTitle:@"去付款" forState:UIControlStateNormal];
                return operationcell;
            }else if(indexPath.row == [model.pros count]+5-2){
                //地址
                addresscell.content_name.text = model.content_linkname;
                addresscell.content_mobile.text = model.content_mobile;
                addresscell.content_address.text = model.content_address;
                return addresscell;
            }else if (indexPath.row == [model.pros count]+5-3){
                //和
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
                leavecell.leaveMsg.text = model.order_message;
                return leavecell;
            }else{
                NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
                [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                procell.content_price.text = OBJC_Nil([prodic objectForKey:@"content_price"]);
                procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                return procell;
                return procell;
            }
        }else if ([_order_type isEqualToString:@"onorder"]){
            if([model.is_status integerValue] == 2){//已发货
                if(indexPath.row == [model.pros count] +5-1){
                    //操作
                    operationcell.leftBtn.hidden = NO;
                    operationcell.rightBtn.hidden = NO;
                    [operationcell.leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [operationcell.rightBtn setTitle:@"确认签收" forState:UIControlStateNormal];
                    return operationcell;
                }else if(indexPath.row == [model.pros count]+5-2){
                    //地址
                    addresscell.content_name.text = model.content_linkname;
                    addresscell.content_mobile.text = model.content_mobile;
                    addresscell.content_address.text = model.content_address;
                    return addresscell;
                }else if (indexPath.row == [model.pros count]+5-3){
                    //和
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
                    leavecell.leaveMsg.text = model.order_message;
                    return leavecell;
                }else{
                    NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                    procell.content_price.text = OBJC_Nil([prodic objectForKey:@"content_price"]);
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                    return procell;
                }
            }else{//[model.is_status integerValue] == 3 已签收,显示产品退货按钮
                if(indexPath.row == [model.pros count]+4-1){
                    //地址
                    addresscell.content_name.text = model.content_linkname;
                    addresscell.content_mobile.text = model.content_mobile;
                    addresscell.content_address.text = model.content_address;
                    return addresscell;
                }else if (indexPath.row == [model.pros count]+4-2){
                    //和
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
                    leavecell.leaveMsg.text = model.order_message;
                    return leavecell;
                }else{
                    procell.returnBtn.hidden = NO;
                    NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];

                    if([[prodic objectForKey:@"is_return"]boolValue]){
                        procell.returnBtn.enabled = NO;
                        [procell.returnBtn setTitle:@"已退货" forState:UIControlStateNormal];
                    }else{
                        procell.returnBtn.enabled = YES;
                        [procell.returnBtn setTitle:@"我要退货" forState:UIControlStateNormal];
                    }
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                    procell.content_price.text = OBJC_Nil([prodic objectForKey:@"content_price"]);
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                    return procell;
                }
            }
        }else if ([_order_type isEqualToString:@"okorder"]){
            if([model.is_comment boolValue]){
                if(indexPath.row == [model.pros count] +5-1){
                    return evaluatecell;
                }else if(indexPath.row == [model.pros count]+5-2){
                    //地址
                    addresscell.content_name.text = model.content_linkname;
                    addresscell.content_mobile.text = model.content_mobile;
                    addresscell.content_address.text = model.content_address;
                    return addresscell;
                }else if (indexPath.row == [model.pros count]+5-3){
                    //和
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
                    leavecell.leaveMsg.text = model.order_message;
                    return leavecell;
                }else{
                    NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                    procell.content_price.text = OBJC_Nil([prodic objectForKey:@"content_price"]);
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                    procell.fieldHeght.constant = 30;
                    procell.userInteractionEnabled = NO;
                    return procell;
                }
            }else{
                if(indexPath.row == [model.pros count] +6-1){
                    //操作
                    operationcell.leftBtn.hidden = YES;
                    operationcell.rightBtn.hidden = NO;
                    [operationcell.rightBtn setTitle:@"我要评价" forState:UIControlStateNormal];
                    return operationcell;
                }else if(indexPath.row == [model.pros count] +6-2){
                    
                    return evaluatecell;
                }else if(indexPath.row == [model.pros count]+6-3){
                    //地址
                    addresscell.content_name.text = model.content_linkname;
                    addresscell.content_mobile.text = model.content_mobile;
                    addresscell.content_address.text = model.content_address;
                    return addresscell;
                }else if (indexPath.row == [model.pros count]+6-4){
                    //和
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
                    leavecell.leaveMsg.text = model.order_message;
                    return leavecell;
                }else{
                    NSDictionary * prodic = [model.pros objectAtIndex:indexPath.row-1];
                    [procell.content_img sd_setImageWithURL:[NSURL URLWithString:[prodic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                    procell.content_name.text  = OBJC_Nil([prodic objectForKey:@"content_name"])?OBJC_Nil([prodic objectForKey:@"content_name"]):@" ";
                    procell.content_price.text = OBJC_Nil([prodic objectForKey:@"content_price"]);
                    procell.content_num.text = [NSString stringWithFormat:@"x%@",OBJC_Nil([prodic objectForKey:@"content_num"])];
                    procell.fieldHeght.constant = 30;
                    procell.userInteractionEnabled = YES;
                    return procell;
                }
            }
        }else{//退货
            return procell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMPublicModel * model = [orderlists objectAtIndex:indexPath.section];
    if(indexPath.row == 0){
               return 30.0f;
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
            return 80.f;
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
        if([model.is_status integerValue] == 3){//已签收
            
        }else{
            //确认签收
            [self sureReceiver:model];
        }
    }else if ([_order_type isEqualToString:@"okorder"]){
        //发表评价
        [self publishEvaluate:model];
    }else if ([_order_type isEqualToString:@"returnorder"]){
        if([model.is_return boolValue]){
        
        }else{
            
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
    [self showReturnEditView:dic];
}


- (void)showReturnEditView:(NSDictionary *)model{
    
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
//        [returnEditView.seeBtn addTarget:self action:@selector(seeExpress:) forControlEvents:UIControlEventTouchDown];
        [returnEditView.commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchDown];
    }
    
    returnEditView._model = model;
    
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
    [RMAFNRequestManager memberReturnGoodsOrSureDeliveryWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] isReturn:YES orderId:[returnEditView._model objectForKey:@"orderpro_id"] expressName:[returnEditView.expressName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] expressId:returnEditView.express_price.text andCallBack:^(NSError *error, BOOL success, id object) {
        
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
//    BOOL iscorp ;
//    if([[[RMUserLoginInfoManager loginmanager] isCorp] isEqualToString:@"1"]){
//        iscorp = NO;
//    }else{
//        iscorp = YES;
//    }
    
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
