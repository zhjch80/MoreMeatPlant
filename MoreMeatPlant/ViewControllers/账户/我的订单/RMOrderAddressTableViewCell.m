//
//  RMOrderAddressTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/5/5.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMOrderAddressTableViewCell.h"

@implementation RMOrderAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _bottom_line.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"heidian", @"png")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
