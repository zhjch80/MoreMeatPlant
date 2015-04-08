//
//  TransactionRecordsViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/2.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMTransactionRecordsViewController : RMBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    int more;
}
@property (weak, nonatomic) IBOutlet UILabel *sum;
@property (weak, nonatomic) IBOutlet UILabel *yu_e;
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (retain, nonatomic) NSArray * tags;
@property (retain, nonatomic) NSString * app_com;
@property (retain, nonatomic) NSMutableArray * dataarray;
@end
