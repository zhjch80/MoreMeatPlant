//
//  RMAdvertisingViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMAdvertisingViewController : RMBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSMutableArray * planteArray;
    NSMutableArray * selectArray;
    NSURL * _filePath;
    UIImage * default_image;
    NSInteger num_total;
    float money_total;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
