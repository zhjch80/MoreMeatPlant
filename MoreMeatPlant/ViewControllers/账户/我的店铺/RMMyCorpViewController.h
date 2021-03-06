//
//  RMMyCorpViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMPlantWithSaleCell.h"
#import "KxMenu.h"
#import "RMBottomView.h"
@interface RMMyCorpViewController : RMBaseViewController<UITableViewDelegate,UITableViewDataSource,BottomDelegate,JumpPlantDetailsDelegate>{
    RMBottomView * bottomView;
    RKNotificationHub * badge;
    RKNotificationHub * car_badge;
    RKNotificationHub * chat_badge;
    RMPublicModel * classsModel;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableview;
@property (retain, nonatomic) NSString * auto_id;
@property (retain, nonatomic) NSString * member_class;
@property (retain, nonatomic) NSString * titleName;
@end
