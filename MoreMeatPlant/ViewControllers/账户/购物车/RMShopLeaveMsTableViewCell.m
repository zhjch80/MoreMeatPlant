//
//  RMShopLeaveMsTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/9.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMShopLeaveMsTableViewCell.h"

@implementation RMShopLeaveMsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _bottom_line.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"heidian", @"png")];
    _bottom_line2.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"deidian", @"png")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
