//
//  RMNearFriendViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/4.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMNearFriendViewController : RMBaseViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray * friendsArray;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
