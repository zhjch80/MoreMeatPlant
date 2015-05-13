//
//  RMMyHomeViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMReleasePoisonCell.h"
#import "RMBottomView.h"
#import "KxMenu.h"

typedef void (^RMMyHomeViewCtlDetailCallBack) (NSString * auto_id);
@interface RMMyHomeViewController : RMBaseViewController<UITableViewDelegate,UITableViewDataSource,PostDetatilsDelegate,BottomDelegate>{
    RMBottomView * bottomView;
    RKNotificationHub * badge;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
//@property (weak, nonatomic) IBOutlet UIImageView *content_img;
//@property (weak, nonatomic) IBOutlet UILabel *content_name;
//@property (weak, nonatomic) IBOutlet UILabel *content_signature;
//@property (weak, nonatomic) IBOutlet UILabel *city;
//@property (weak, nonatomic) IBOutlet UILabel *yu_e;
//@property (weak, nonatomic) IBOutlet UILabel *hua_bi;
//@property (weak, nonatomic) IBOutlet UIButton *sendPrivateMsgBtn;
//@property (weak, nonatomic) IBOutlet UIButton *attentionHeBtn;
@property (copy, nonatomic) RMMyHomeViewCtlDetailCallBack detailcall_back;
@property (retain, nonatomic) NSString * auto_id;
@property (assign, nonatomic) BOOL isSelf;
@property (retain, nonatomic) NSString * titleName;

@end
