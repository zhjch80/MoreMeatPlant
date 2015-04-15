//
//  RMModifyPassWordViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/28.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMBaseTextField.h"
@interface RMModifyPassWordViewController : RMBaseViewController
@property (weak, nonatomic) IBOutlet RMBaseTextField *oldTextField;
@property (weak, nonatomic) IBOutlet RMBaseTextField *twoTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureModifyBtn;

@property (weak, nonatomic) IBOutlet RMBaseTextField *sureTextField;
@end
