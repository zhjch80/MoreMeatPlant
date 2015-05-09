//
//  RMHadBabyListViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMHadBabyListViewController.h"
#import "RefreshControl.h"
#import "RefreshView.h"
#import "UIViewController+HUD.h"
#import "RMOrderReturnEditView.h"
#import "CONST.h"
#import "AppDelegate.h"


#import "RMOrderHeadTableViewCell.h"
#import "RMOrderDetailProTableViewCell.h"
#import "RMOrderLeaveMsgTableViewCell.h"
#import "RMOrderDetailNumTableViewCell.h"
#import "RMOrderAddressTableViewCell.h"
#import "RMOederDetailOperationTableViewCell.h"
#import "RMOrderDetailEvaluateTableViewCell.h"

#import "UIAlertView+Expland.h"

@interface RMHadBabyListViewController ()<RefreshControlDelegate,UITextFieldDelegate>{
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
    self.view.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0.8];
    
    dataarray = [[NSMutableArray alloc]init];
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    pageCount = 1;
    isRefresh = YES;
    
    self.mTableView.backgroundColor = [UIColor clearColor];
    self.mTableView.opaque = NO;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [dataarray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    RMPublicModel * model = [dataarray objectAtIndex:section];
    if([_order_type isEqualToString:@"unorder"]){
        if([model.is_status integerValue] == 0){//未处理
            return [model.pros count] + 5;
        }else { //([model.is_status integerValue] == 1){//待发货
            return [model.pros count] + 5;
        }
        
    }else if ([_order_type isEqualToString:@"unpayorder"]){
        return [model.pros count] + 4;
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
            return [model.pros count] + 5;
        }
    }else{//退货
        if([model.is_status boolValue]){
            return 1+2;
        }else{
           return 1+3;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMPublicModel * model = [dataarray objectAtIndex:indexPath.section];
    
    if(indexPath.row == 0){
        
        RMOrderHeadTableViewCell * headcell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderHeadTableViewCell"];
        if(headcell == nil){
            headcell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderHeadTableViewCell" owner:self options:nil] lastObject];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goCorp:)];
            headcell.corp_name.userInteractionEnabled = YES;
            [headcell.corp_name addGestureRecognizer:tap];
        }
        
        headcell.corp_name.tag = indexPath.section+100;
        headcell.corp_name.text = OBJC_Nil([model.mem objectForKey:@"content_name"]);
        headcell.create_time.text = model.create_time;
//        if([model.is_paystatus boolValue]){
//            if([model.is_status integerValue] == 1){
//                headcell.order_status.text = @"待发货";
//            }else if ([model.is_status integerValue] == 2){
//                headcell.order_status.text = @"已发货";
//            }else if ([model.is_status integerValue] == 3){
//                headcell.order_status.text = @"已签收";
//            }else if ([model.is_status integerValue] == 4){
//                headcell.order_status.text = @"已取消";
//            }else if ([model.is_status integerValue] == 5){
//                headcell.order_status.text = @"已完成";
//            }else{
//                headcell.order_status.text = @"未处理";
//            }
//        }else{
//            headcell.order_status.text = @"待付款";
//        }
        headcell.order_status.text = model.content_status;
        return headcell;
    }else{
        
        if([_order_type isEqualToString:@"unorder"]){
            if([model.is_status integerValue] == 0){//未处理
                if(indexPath.row == [model.pros count] +5-1){
                    //操作
                    RMOederDetailOperationTableViewCell * operationcell = [self getRMOederDetailOperationTableViewCell:indexPath];
                    operationcell.leftBtn.hidden = NO;
                    operationcell.rightBtn.hidden = NO;
                    [operationcell.leftBtn setTitle:@"联系买家" forState:UIControlStateNormal];
                    [operationcell.rightBtn setTitle:@"开始备货" forState:UIControlStateNormal];
                    return operationcell;
                }else if(indexPath.row == [model.pros count]+5-2){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
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
                if(indexPath.row == [model.pros count] +5-1){
                    //操作
                    RMOederDetailOperationTableViewCell * operationcell = [self getRMOederDetailOperationTableViewCell:indexPath];
                    operationcell.leftBtn.hidden = NO;
                    operationcell.rightBtn.hidden = NO;
                    [operationcell.leftBtn setTitle:@"联系买家" forState:UIControlStateNormal];
                    [operationcell.rightBtn setTitle:@"点击发货" forState:UIControlStateNormal];
                    return operationcell;
                }else if(indexPath.row == [model.pros count]+5-2){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    
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
            }
            
        }else if ([_order_type isEqualToString:@"unpayorder"]){
            if(indexPath.row == [model.pros count]+4-1){
                //地址
                RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                
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
                return procell;
            }
        }else if ([_order_type isEqualToString:@"onorder"]){
            if([model.is_status integerValue] == 2){//已发货
                if(indexPath.row == [model.pros count] +5-1){
                    //操作
                    RMOederDetailOperationTableViewCell * operationcell = [self getRMOederDetailOperationTableViewCell:indexPath];
                    
                    operationcell.leftBtn.hidden = YES;
                    operationcell.rightBtn.hidden = NO;
                    [operationcell.rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    return operationcell;
                }else if(indexPath.row == [model.pros count]+5-2){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    
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
                        [procell.returnBtn setTitle:@"已退货" forState:UIControlStateNormal];
                    }else{
                        procell.returnBtn.enabled = YES;
                        [procell.returnBtn setTitle:@"我要退货" forState:UIControlStateNormal];
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
                    UIButton * btn = (UIButton *)[evaluatecell.contentView viewWithTag:1000*indexPath.section+n-1];
                    [btn setImage:[UIImage imageNamed:@"order_yellow_sun"] forState:UIControlStateNormal];
                    evaluatecell.userInteractionEnabled = NO;
                    return evaluatecell;
                }else if(indexPath.row == [model.pros count]+5-2){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    
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
                    procell.userInteractionEnabled = NO;
                    procell.evaluateTextField.text = [[model.pros objectAtIndex:indexPath.row-1] objectForKey:@"comment_desc"];
                    return procell;
                }
            }else{
                if(indexPath.row == [model.pros count] +5-1){
                    //操作
                    RMOederDetailOperationTableViewCell * operationcell = [self getRMOederDetailOperationTableViewCell:indexPath];
                    
                    operationcell.leftBtn.hidden = YES;
                    operationcell.rightBtn.hidden = NO;
                    [operationcell.rightBtn setTitle:@"尚未评价" forState:UIControlStateNormal];
                    return operationcell;
                }else if(indexPath.row == [model.pros count]+5-2){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    
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
                    procell.fieldHeght.constant = 0;
                    procell.evaluateTextField.userInteractionEnabled = YES;
                    procell.evaluateTextField.text = [[model.pros objectAtIndex:indexPath.row-1] objectForKey:@"comment_desc"];
                    return procell;
                }
            }
        }else{//退货
            if([model.is_status boolValue]){
                if(indexPath.row == 1+2-1){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    
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
                if(indexPath.row == 1+3-1){
                    RMOederDetailOperationTableViewCell * operationcell = [self getRMOederDetailOperationTableViewCell:indexPath];
                    
                    operationcell.leftBtn.hidden = NO;
                    operationcell.rightBtn.hidden = NO;
                    [operationcell.leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [operationcell.rightBtn setTitle:@"确认签收" forState:UIControlStateNormal];
                    return operationcell;
                }else if(indexPath.row == 1+3-2){
                    //地址
                    RMOrderAddressTableViewCell * addresscell = [self getRMOrderAddressTableViewCell:indexPath];
                    
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
    RMOrderDetailProTableViewCell * procell = [_mTableView dequeueReusableCellWithIdentifier:@"RMOrderDetailProTableViewCell"];
    if(procell == nil){
        procell = [[[NSBundle mainBundle]loadNibNamed:@"RMOrderDetailProTableViewCell" owner:self options:nil] lastObject];
        procell.returnBtn.hidden = YES;
//        [procell.returnBtn addTarget:self action:@selector(iWantToReturn:) forControlEvents:UIControlEventTouchDown];
        procell.fieldHeght.constant = 0;
    }
    procell.returnBtn.tag = indexPath.section*1000+indexPath.row;
    procell.evaluateTextField.tag = indexPath.section*100+1+indexPath.row;
    procell.evaluateTextField.delegate = self;
    return procell;
}

- (RMOrderLeaveMsgTableViewCell *)getRMOrderLeaveMsgTableViewCell:(NSIndexPath *)indexPath{
    RMOrderLeaveMsgTableViewCell * leavecell = [_mTableView dequeueReusableCellWithIdentifier:@"RMOrderLeaveMsgTableViewCell"];
    if(leavecell == nil){
        leavecell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderLeaveMsgTableViewCell" owner:self options:nil] lastObject];
        leavecell.leaveMsg.userInteractionEnabled = NO;
    }
    return leavecell;
}

- (RMOrderDetailNumTableViewCell *)getRMOrderDetailNumTableViewCell:(NSIndexPath *)indexPath{
    RMOrderDetailNumTableViewCell * numcell = [_mTableView dequeueReusableCellWithIdentifier:@"RMOrderDetailNumTableViewCell"];
    if(numcell == nil){
        numcell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderDetailNumTableViewCell" owner:self options:nil] lastObject];
    }
    return numcell;
}

- (RMOrderAddressTableViewCell *)getRMOrderAddressTableViewCell:(NSIndexPath *)indexPath{
    RMOrderAddressTableViewCell * addresscell = [_mTableView dequeueReusableCellWithIdentifier:@"RMOrderAddressTableViewCell"];
    if(addresscell == nil){
        addresscell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderAddressTableViewCell" owner:self options:nil] lastObject];
    }
    return addresscell;
}

- (RMOederDetailOperationTableViewCell *)getRMOederDetailOperationTableViewCell:(NSIndexPath *)indexPath{
    RMOederDetailOperationTableViewCell * operationcell = [_mTableView dequeueReusableCellWithIdentifier:@"RMOederDetailOperationTableViewCell"];
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
    RMOrderDetailEvaluateTableViewCell * evaluatecell = [_mTableView dequeueReusableCellWithIdentifier:@"RMOrderDetailEvaluateTableViewCell"];
    if(evaluatecell == nil){
        evaluatecell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderDetailEvaluateTableViewCell" owner:self options:nil] lastObject];
//        for(int i = 0;i<4;i++){
//            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(evaluateAction:)];
//            UILabel * label = (UILabel *)[evaluatecell.contentView viewWithTag:100+i];
//            [label addGestureRecognizer:tap];
//        }
        
        
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
    RMPublicModel * model = [dataarray objectAtIndex:indexPath.section];
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
            }
            
        }else if ([_order_type isEqualToString:@"unpayorder"]){
        if(indexPath.row == [model.pros count]+4-1){
                //地址
                
                return 55.f;
            }else if (indexPath.row == [model.pros count]+4-2){
                //和
                
                return 38.f;
            }else if (indexPath.row == [model.pros count]+4-3){
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
                if(indexPath.row == [model.pros count] +5-1){
                    //操作
                    return 40.f;
                }else if(indexPath.row == [model.pros count]+5-2){
                    return 55.f;
                }else if (indexPath.row == [model.pros count]+5-3){
                    //和
                    return 38.f;
                }else if (indexPath.row == [model.pros count]+5-4){
                    return 39.f;
                }else{
                    return 80.f;
                }
            }
        }else{//退货
            if(model.is_status){
                if(indexPath.row == 1 + 2 -1){
                    return 55.f;
                }else{
                    return 80.f;
                }
            }else{
                if(indexPath.row == 1 + 3 -1){
                    return 40.f;
                }else if(indexPath.row == 1 + 3 -2){
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

#pragma mark - 进入店铺
- (void)goCorp:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag-100;
    
    if(self.goCorp_callback){
        self.goCorp_callback ([dataarray objectAtIndex:tag]);
    }
}

#pragma mark - 订单操作
- (void)rightAction:(UIButton *)sender{
    RMPublicModel *model = [dataarray objectAtIndex:sender.tag/100];
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
        [self seeLogistics:model];
    }
}

#pragma mark - 联系买家
- (void)contactUser:(RMPublicModel *)model{
    if(model.member_user == nil){
        [self showHint:@"该商家被停用了！"];
        return;
    }
//    if(self.call_back){
//        _call_back();
//    }
    [self.navigationController popToRootViewControllerAnimated:NO];
    AppDelegate * dele = [[UIApplication sharedApplication] delegate];
    [dele tabSelectController:3];
    
    [dele.talkMoreCtl._chatListVC jumpToChatView:[model.mem objectForKey:@"content_user"]];
}


#pragma mark - 查看物流
- (void)seeLogistics:(RMPublicModel *)model{
    if(self.seeLogistics_callback){
        _seeLogistics_callback (model);
    }
//    if(self.call_back){
//        _call_back();
//    }
}

#pragma mark - 点击发货
- (void)deliveryAction:(RMPublicModel *)model{
    //这里应该是调用接口
    [self showReturnEditView:model];
}

#pragma mark -确认签收
- (void)sureReceiver:(RMPublicModel *)model{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定签收吗？" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
    [alert show];
    
    [alert handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
        if(btnIndex == 1){
            if(self.startRequest){
                self.startRequest();
            }
            [RMAFNRequestManager corpReturnSureWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] orderId:model.order_id andCallBack:^(NSError *error, BOOL success, id object) {
                //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if(self.finishedRequest){
                    self.finishedRequest();
                }
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
    }];
}

#pragma mark - 备货
- (void)startBh:(RMPublicModel *)model{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要准备备货吗？" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
    [alert show];
    
    [alert handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
        if(btnIndex == 1){
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
        returnEditView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenWidth*220.0/320.0);
        [returnEditView.commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchDown];
    }
    
    NSLog(@"++++++++++%@",[NSValue valueWithCGRect:returnEditView.frame]);
    
    returnEditView._model = model;
    returnEditView.content_name.text = model.content_linkname;
    returnEditView.content_mobile.text = model.content_mobile;
    returnEditView.content_address.text = model.content_address;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        returnEditView.frame = CGRectMake(0, _mTableView.frame.size.height-(kScreenWidth*220.0/320.0), kScreenWidth, kScreenWidth*220.0/320.0);
        NSLog(@"-------%@",[NSValue valueWithCGRect:returnEditView.frame]);
        [self.view addSubview:returnEditView];
    }];
}

- (void)dismissAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.3 animations:^{
        UIControl * cover = (UIControl *)[self.view viewWithTag:101311];
        [cover removeFromSuperview];
        returnEditView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenWidth*206.0/320.0);
        returnEditView.expressName.text = nil;
        returnEditView.express_price.text = nil;//这里实际上是快递单号，不是价格，
    }];
    
}


#pragma mark - 提交
- (void)commit{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(returnEditView.express_price.text.length == 0 || returnEditView.expressName.text.length == 0){
        [self showHint:@"请输入快递公司和单号"];
        return;
    }
    if(self.startRequest){
        self.startRequest();
    }
    [RMAFNRequestManager memberReturnGoodsOrSureDeliveryWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] isReturn:NO orderId:[returnEditView._model auto_id] expressName:[returnEditView.expressName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] expressId:returnEditView.express_price.text andCallBack:^(NSError *error, BOOL success, id object) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(self.finishedRequest){
            self.finishedRequest ();
        }
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
    if(self.startRequest){
        self.startRequest();
    }
    [RMAFNRequestManager myOrderListRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] isCorp:YES type:self.order_type Page:pageCount andCallBack:^(NSError *error, BOOL success, id object) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(self.finishedRequest){
            self.finishedRequest ();
        }
        if(success){
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
