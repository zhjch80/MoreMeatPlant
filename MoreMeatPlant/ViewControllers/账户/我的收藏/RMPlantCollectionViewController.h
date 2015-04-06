//
//  RMPlantCollectionViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDaqoCell.h"
#import "RMDaqoDetailsViewController.h"
typedef void (^RMPlantCollectionViewCtlDetailCallBack) (NSString * auto_id);
@interface RMPlantCollectionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,DaqpSelectedPlantTypeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (copy, nonatomic) RMPlantCollectionViewCtlDetailCallBack detailcall_back;
@end
