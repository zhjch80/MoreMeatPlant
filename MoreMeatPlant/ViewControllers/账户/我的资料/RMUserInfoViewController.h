//
//  RMUserInfoViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
@class RMUserInfoViewController;
typedef void (^RMUserInfoCallBack) (RMUserInfoViewController *controller);

typedef void (^RMUserInfoCloseAction) (RMUserInfoViewController *controller);

@interface RMUserInfoViewController : RMBaseViewController
@property (copy, nonatomic) RMUserInfoCallBack callback;

@property (copy, nonatomic) RMUserInfoCloseAction close_action;

@property (weak, nonatomic) IBOutlet UILabel *nickL;
@property (weak, nonatomic) IBOutlet UILabel *passwordL;
@property (weak, nonatomic) IBOutlet UILabel *signatureL;
@property (weak, nonatomic) IBOutlet UILabel *mobileL;
@property (weak, nonatomic) IBOutlet UILabel *apliyL;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end
