//
//  RMOrderListViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RMOrderListViewDidSelectCell)(NSIndexPath * indexpath);
@interface RMOrderListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *maintableView;
@property (copy, nonatomic) RMOrderListViewDidSelectCell  didSelectCellcallback;
@end
