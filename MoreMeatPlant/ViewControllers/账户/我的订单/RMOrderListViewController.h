//
//  RMOrderListViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMBaseViewController.h"
typedef void (^RMOrderListViewDidSelectCallBack)(RMPublicModel *model);
typedef void (^RMOrderListViewGoPayCallBack)(RMPublicModel *model);
typedef void (^RMOrderListViewGoCorpCallBack)(RMPublicModel *model);
typedef void (^RMOrderListViewSeeLogisticsCallBack)(RMPublicModel *model);
@interface RMOrderListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray * orderlists;
}

@property (weak, nonatomic) IBOutlet UITableView *maintableView;
@property (retain, nonatomic) NSString * order_type;
@property (copy, nonatomic) RMOrderListViewDidSelectCallBack  didSelectCellcallback;
@property (copy, nonatomic) RMOrderListViewGoPayCallBack gopay_callback;
@property (copy, nonatomic) RMOrderListViewSeeLogisticsCallBack seeLogistics_callback;
@property (copy, nonatomic) RMOrderListViewGoCorpCallBack goCorp_callback;
@property (assign, nonatomic) NSInteger pageCount;
- (void)requestData;
@end
