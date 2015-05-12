//
//  RMPublishTitleTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPublishTitleTableViewCell.h"

@implementation RMPublishTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _titleTextfield.backgroundColor = UIColorFromRGB(0xd3d3d3);
    _titleTextfield.layer.cornerRadius = 5;
    
    _content_descField.backgroundColor = UIColorFromRGB(0xd3d3d3);
    _content_descField.layer.cornerRadius = 5;
    
    _content_price.backgroundColor = UIColorFromRGB(0xd3d3d3);
    _content_price.layer.cornerRadius = 5;
    
    _qt_nameField.backgroundColor = UIColorFromRGB(0xd3d3d3);
    _qt_nameField.layer.cornerRadius = 5;
    
    _qt_priceField.backgroundColor = UIColorFromRGB(0xd3d3d3);
    _qt_priceField.layer.cornerRadius = 5;
    
    _textViewBg.backgroundColor = UIColorFromRGB(0xd3d3d3);
    _textViewBg.layer.cornerRadius = 5;
    
    _bottom_line.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"heidian", @"png")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
