//
//  RMBabyListViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMPublicModel.h"
typedef void (^RMBabyListViewModifyCallback) (RMPublicModel * _model);
@interface RMBabyListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray * babyArray;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (copy, nonatomic) RMBabyListViewModifyCallback modifycallback;

@end
