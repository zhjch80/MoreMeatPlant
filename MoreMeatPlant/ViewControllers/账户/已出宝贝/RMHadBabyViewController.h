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
}
@property (copy, nonatomic) RMHadBabyViewCtlCallBack  callback;
@end
