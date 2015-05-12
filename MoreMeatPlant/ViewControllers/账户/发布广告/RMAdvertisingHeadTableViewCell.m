//
//  RMAdvertisingHeadTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMAdvertisingHeadTableViewCell.h"

@implementation RMAdvertisingHeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _bottom_line.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"heidian", @"png")];
    
    _publishBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _publishBtn.layer.cornerRadius = 5;
    _publishBtn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
