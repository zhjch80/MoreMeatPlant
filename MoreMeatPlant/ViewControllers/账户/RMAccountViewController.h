//
//  RMAccountViewController.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMAccountViewController : RMBaseViewController{
    NSMutableArray * functitleArray;
    NSMutableArray * funcimgArray;
    RMPublicModel * _model;
    BOOL isShow;//YES 表示当前界面有其他控制器的View
    
}
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *userNameL;
@property (weak, nonatomic) IBOutlet UILabel *userDescL;
@property (weak, nonatomic) IBOutlet UILabel *regionL;
@property (weak, nonatomic) IBOutlet UILabel *yu_eL;//余额
@property (weak, nonatomic) IBOutlet UILabel *hua_biL;//花币
@property (weak, nonatomic) IBOutlet UIButton *member_right;
@property (weak, nonatomic) IBOutlet UIButton *member_level;
@property (weak, nonatomic) IBOutlet UIButton *member_right_tag;

@property (assign, nonatomic) BOOL isCorp;

- (void)initPlat;
@end
