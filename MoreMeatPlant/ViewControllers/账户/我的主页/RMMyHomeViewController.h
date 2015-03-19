//
//  RMMyHomeViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMReleasePoisonCell.h"
@interface RMMyHomeViewController : RMBaseViewController<UITableViewDelegate,UITableViewDataSource,PostDetatilsDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@end
