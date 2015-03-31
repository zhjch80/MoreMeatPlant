//
//  RMPublishBabyViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMPublishBabyViewController : RMBaseViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSMutableArray * classArray;
    
    NSInteger img_tag;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
