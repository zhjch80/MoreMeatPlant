//
//  RMSysMessageTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/4.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMSysMessageTableViewCell.h"

@implementation RMSysMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _imgV.layer.cornerRadius = 3;
    _imgV.clipsToBounds = YES;
    _messageV.layer.cornerRadius = 3;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
