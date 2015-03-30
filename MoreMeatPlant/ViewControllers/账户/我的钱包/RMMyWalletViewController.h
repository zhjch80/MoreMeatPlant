//
//  RMMyWalletViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

typedef void (^RMMyWalletViewCloseCallBack)(id sender);
typedef void (^RMMyWalletViewBillCallBack)(id sender);


@interface RMMyWalletViewController : RMBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UIButton *billBtn;

@property (copy, nonatomic) RMMyWalletViewBillCallBack billcallback;
@property (copy, nonatomic) RMMyWalletViewCloseCallBack closecallback;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
