//
//  RMSysMessageViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/4.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
@class RMSysMessageViewController;
typedef void (^RMSysMessageCallBack) (RMSysMessageViewController * controller);

typedef void (^RMSysMessageDidSelectCallBack) (NSString * auto_id);

@interface RMSysMessageViewController : RMBaseViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray * messageArray;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (copy, nonatomic) RMSysMessageCallBack callback;
@property (copy, nonatomic) RMSysMessageDidSelectCallBack didselect_callback;
@end
