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

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
