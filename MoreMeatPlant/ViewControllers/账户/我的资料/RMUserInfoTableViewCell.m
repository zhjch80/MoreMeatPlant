//
//  RMUserInfoTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/23.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMUserInfoTableViewCell.h"

@implementation RMUserInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _modifyBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"red_btn", @"png")];
    _modifyBtn.layer.cornerRadius = 5;
    _modifyBtn.clipsToBounds = YES;
    
    _editBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"red_btn", @"png")];
    _editBtn.layer.cornerRadius = 5;
    _editBtn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
