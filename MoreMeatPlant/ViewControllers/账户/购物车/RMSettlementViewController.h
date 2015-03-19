//
//  RMSettlementViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/10.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
@class RMSettlementViewController;
typedef void (^RMSettlementViewCloseCallBack) (void);

typedef void (^RMSettlementViewSelectAddress) (void);
typedef void (^RMSettlementViewEditAddress) (void);
typedef void (^RMSettlementViewAddAddress) (void);
typedef void (^RMSettlementViewSelectPayment) (void);
typedef void (^RMSettlementViewSettle) (void);

@interface RMSettlementViewController : RMBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *close_btn;
@property (copy, nonatomic) RMSettlementViewCloseCallBack callback;
@property (copy, nonatomic) RMSettlementViewSelectAddress selectAddress_callback;
@property (copy, nonatomic) RMSettlementViewEditAddress editAddress_callback;
@property (copy, nonatomic) RMSettlementViewAddAddress addAddress_callback;
@property (copy, nonatomic) RMSettlementViewSelectPayment payment_callback;
@property (copy, nonatomic) RMSettlementViewSettle settle_callback;
@end
