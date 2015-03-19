//
//  RMPostCollectionViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"
#import "RMReleasePoisonCell.h"
#import "CONST.h"
@interface RMPostCollectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PostDetatilsDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@end
