//
//  RMUserInfoEditViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMUserInfoEditViewController : RMBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *nickT;
@property (weak, nonatomic) IBOutlet UITextField *passwordT;
@property (weak, nonatomic) IBOutlet UITextView *signatureT;//签名
@property (weak, nonatomic) IBOutlet UITextField *mobileT;
@property (weak, nonatomic) IBOutlet UITextField *apliyT;
@property (retain, nonatomic) RMPublicModel * _model;
@property (weak, nonatomic) IBOutlet UIButton *sureModifyBtn;

@end
