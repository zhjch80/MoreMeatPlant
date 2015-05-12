//
//  RMPublishNumberTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPublishNumberTableViewCell.h"

@implementation RMPublishNumberTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _bottom_line.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"heidian", @"png")];
    
    _numTextfield.backgroundColor = UIColorFromRGB(0xd3d3d3);
    _numTextfield.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
