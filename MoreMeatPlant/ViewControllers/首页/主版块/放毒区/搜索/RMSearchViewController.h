//
//  RMSearchViewController.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMBaseTextField.h"

@interface RMSearchViewController : RMBaseViewController
@property (weak, nonatomic) IBOutlet RMBaseTextField *mTextField;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic, copy) NSString * searchType;          //搜索类型  宝贝 帖子 大全 三种种
@property (nonatomic, copy) NSString * searchWhere;         //搜索位置

@end
