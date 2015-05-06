//
//  RMHadBabyListViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMBaseViewController.h"
#import "RMOrderListViewController.h"
typedef void (^RMHadBabyListViewCtlCallback)(void);
@interface RMHadBabyListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (retain, nonatomic) NSMutableArray * dataarray;
@property (assign, nonatomic) NSInteger pageCount;

@property (retain, nonatomic) NSString * order_type;
@property (copy, nonatomic) RMOrderListViewDidSelectCallBack  didSelectCellcallback;
@property (copy, nonatomic) RMOrderListViewGoPayCallBack gopay_callback;
@property (copy, nonatomic) RMOrderListViewSeeLogisticsCallBack seeLogistics_callback;
@property (copy, nonatomic) RMOrderListViewGoCorpCallBack goCorp_callback;

@property (copy, nonatomic) RMHadBabyListViewCtlCallback call_back;
- (void)requestData;
@end
