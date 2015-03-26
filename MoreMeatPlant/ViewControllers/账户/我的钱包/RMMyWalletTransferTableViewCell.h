//
//  RMMyWalletTransferTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMMyWalletTransferTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *otherAccountField;
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *withdrawalField;
@property (weak, nonatomic) IBOutlet UILabel *alipayName;
@property (weak, nonatomic) IBOutlet UILabel *mobileL;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *sureWithdrawalBtn;

@end
