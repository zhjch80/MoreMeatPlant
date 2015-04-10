//
//  RMForgotWordViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/21.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "JKCountDownButton.h"
@interface RMForgotWordViewController : RMBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UIButton *sure_btn;
@property (weak, nonatomic) IBOutlet JKCountDownButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *back_login_btn;

@end
