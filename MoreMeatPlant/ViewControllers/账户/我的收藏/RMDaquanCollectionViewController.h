//
//  RMDaquanCollectionViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/5/3.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDaqoCell.h"
#import "RMFoundationViewController.h"
typedef void (^RMCorpCollectionViewCtlDetailCallBack) (NSString * auto_id);
@interface RMDaquanCollectionViewController : RMFoundationViewController<UITableViewDataSource, UITableViewDelegate,DaqpSelectedPlantTypeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (copy, nonatomic) RMCorpCollectionViewCtlDetailCallBack detailcall_back;

@end
