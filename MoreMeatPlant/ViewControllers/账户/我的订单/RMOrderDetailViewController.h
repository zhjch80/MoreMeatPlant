//
//  RMOrderDetailViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/22.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMOrderDetailViewController : RMBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (retain, nonatomic) RMPublicModel * _model;
@property (retain, nonatomic) NSString * order_type;
@end
