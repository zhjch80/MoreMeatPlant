//
//  RMOrderListViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMOrderListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *maintableView;
@end
