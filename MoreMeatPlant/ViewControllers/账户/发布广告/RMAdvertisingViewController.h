//
//  RMAdvertisingViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMAdvertisingViewController : RMBaseViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray * planteArray;
    NSMutableArray * selectArray;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
