//
//  RMSettlementViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/10.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMSettlementViewController : RMBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
