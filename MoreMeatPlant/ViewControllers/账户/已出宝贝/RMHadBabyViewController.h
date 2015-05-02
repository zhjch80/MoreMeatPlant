//
//  RMHadBabyViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMHadBabyListViewController.h"
typedef void (^RMHadBabyViewCtlCallBack)(void);
@interface RMHadBabyViewController : RMBaseViewController
{
    RMHadBabyListViewController * waitDeliveryCtl;
    RMHadBabyListViewController * waitPayCtl;
    RMHadBabyListViewController * deliveryedCtl;
    RMHadBabyListViewController * orderDoneCtl;
    RMHadBabyListViewController * orderReturnCtl;
}
@property (copy, nonatomic) RMHadBabyViewCtlCallBack  callback;
@property (weak, nonatomic) IBOutlet UIButton *waitDelivery;
@property (weak, nonatomic) IBOutlet UIButton *waitPay;
@property (weak, nonatomic) IBOutlet UIButton *deliveryed;
@property (weak, nonatomic) IBOutlet UIButton *orderDone;
@property (weak, nonatomic) IBOutlet UIButton *returned;
@property (copy, nonatomic) RMOrderListViewGoPayCallBack  gopay_callback;
@property (copy, nonatomic) RMOrderListViewGoCorpCallBack goCorp_callback;
@property (copy, nonatomic) RMOrderListViewSeeLogisticsCallBack seeLogistics_callback;
@end
