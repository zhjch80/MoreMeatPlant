//
//  RMBabyListTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBabyListTableViewCell.h"

@implementation RMBabyListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _bottom_line.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"heidian", @"png")];
    
    _delete_btn.layer.cornerRadius = 5;
    _delete_btn.clipsToBounds = YES;
    _delete_btn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"red_btn", @"png")];
    
    _modify_btn.layer.cornerRadius = 5;
    _modify_btn.clipsToBounds = YES;
    _modify_btn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"red_btn", @"png")];
    
    _shelves_btn.layer.cornerRadius = 5;
    _shelves_btn.clipsToBounds = YES;
    _shelves_btn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"red_btn", @"png")];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
