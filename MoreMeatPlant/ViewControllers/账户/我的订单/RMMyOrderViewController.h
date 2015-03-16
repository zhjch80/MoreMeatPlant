//
//  RMMyOrderViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMOrderListViewController.h"
@interface RMMyOrderViewController : RMBaseViewController
{
    RMOrderListViewController * waitDeliveryController;
    RMOrderListViewController * waitPayController;
    RMOrderListViewController * deliveryedController;
    RMOrderListViewController * orderDoneController;
}
@property (weak, nonatomic) IBOutlet UIButton *waitDelivery;
@property (weak, nonatomic) IBOutlet UIButton *waitPay;
@property (weak, nonatomic) IBOutlet UIButton *deliveryed;
@property (weak, nonatomic) IBOutlet UIButton *orderDone;

@end
