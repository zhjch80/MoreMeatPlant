//
//  RMMyWalletTransferTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMMyWalletTransferTableViewCell.h"

@implementation RMMyWalletTransferTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _otherAccountField.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _otherAccountField.layer.cornerRadius = 5;
    
    _moneyField.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _moneyField.layer.cornerRadius = 5;
    
    _codeField.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _codeField.layer.cornerRadius = 5;
    
    _withdrawalField.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _withdrawalField.layer.cornerRadius = 5;
    
    _sureBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _sureBtn.layer.cornerRadius = 5;
    _sureBtn.clipsToBounds = YES;
    
    _sureWithdrawalBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _sureWithdrawalBtn.layer.cornerRadius = 5;
    _sureWithdrawalBtn.clipsToBounds = YES;
    
    _sendCodeBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _sendCodeBtn.layer.cornerRadius = 5;
    _sendCodeBtn.clipsToBounds = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
