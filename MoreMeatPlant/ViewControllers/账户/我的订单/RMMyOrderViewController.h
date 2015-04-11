//
//  RMMyOrderViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMOrderListViewController.h"

typedef void (^RMMyOrderViewCallBack) (void);
typedef void (^RMMyOrderViewDidSelectCallBack) (RMPublicModel *model);
@interface RMMyOrderViewController : RMBaseViewController
{
    RMOrderListViewController * waitDeliveryCtl;
    RMOrderListViewController * waitPayCtl;
    RMOrderListViewController * deliveryedCtl;
    RMOrderListViewController * orderDoneCtl;
}
@property (weak, nonatomic) IBOutlet UIButton *waitDelivery;
@property (weak, nonatomic) IBOutlet UIButton *waitPay;
@property (weak, nonatomic) IBOutlet UIButton *deliveryed;
@property (weak, nonatomic) IBOutlet UIButton *orderDone;
@property (copy, nonatomic) RMOrderListViewGoPayCallBack  gopay_callback;
@property (copy, nonatomic) RMOrderListViewSeeLogisticsCallBack seeLogistics_callback;

@property (copy, nonatomic) RMMyOrderViewCallBack callback;
@property (copy, nonatomic) RMMyOrderViewDidSelectCallBack didSelectCell_callback;

@end
