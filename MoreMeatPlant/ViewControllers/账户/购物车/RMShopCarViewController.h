//
//  RMShopCarViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/9.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMShopCarViewController : RMBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *all_total_moneyL;
@property (weak, nonatomic) IBOutlet UIButton *settleBtn;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
