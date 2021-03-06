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

typedef void (^RMUserInfoModifyAction) (RMUserInfoViewController *controller);

@interface RMUserInfoViewController : RMBaseViewController
@property (copy, nonatomic) RMUserInfoCallBack callback;//编辑

@property (copy, nonatomic) RMUserInfoCloseAction close_action;//关闭/返回

@property (copy, nonatomic) RMUserInfoModifyAction modify_callback;//修改


@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) RMPublicModel * _model;
@property (weak, nonatomic) IBOutlet UITableView *mtableView;


@property (retain, nonatomic) UIImage * content_faceImg;
@property (retain, nonatomic) UIImage * cardImg;
@property (retain, nonatomic) UIImage * corpImg;


@end
