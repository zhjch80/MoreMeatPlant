//
//  RMRegisterViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/21.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMRegisterViewController : RMBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *user_btn;
@property (weak, nonatomic) IBOutlet UIButton *corp_btn;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UIButton *sure_btn;
@property (weak, nonatomic) IBOutlet UIButton *back_login_btn;
@property (weak, nonatomic) IBOutlet UIButton *send_code_btn;

@end
