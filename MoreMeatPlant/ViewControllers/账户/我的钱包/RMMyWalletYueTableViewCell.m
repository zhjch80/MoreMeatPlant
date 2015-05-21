//
//  RMMyWalletYueTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMMyWalletYueTableViewCell.h"

@implementation RMMyWalletYueTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _yue_Z_huabiTextField.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _yue_Z_huabiTextField.layer.cornerRadius = 5;
    
    _chargeBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _chargeBtn.layer.cornerRadius = 5;
    _chargeBtn.clipsToBounds = YES;
    
    _chargeRecordBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _chargeRecordBtn.layer.cornerRadius = 5;
    _chargeRecordBtn.clipsToBounds = YES;
    
    _turnBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _turnBtn.layer.cornerRadius = 5;
    _turnBtn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
