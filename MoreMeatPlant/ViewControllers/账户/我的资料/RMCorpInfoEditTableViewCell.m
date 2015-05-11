//
//  RMCorpInfoEditTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/25.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMCorpInfoEditTableViewCell.h"

@implementation RMCorpInfoEditTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _textViewBg.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _textViewBg.layer.cornerRadius = 5;
    
    _textViewBg2.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _textViewBg2.layer.cornerRadius = 5;
    
    _apliyT.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _apliyT.layer.cornerRadius = 5;
    
    _content_link.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _content_link.layer.cornerRadius = 5;
    
    _content_mobile.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _content_mobile.layer.cornerRadius = 5;
    
    _codeField.backgroundColor = UIColorFromRGB(0xe5e5e5);
    _codeField.layer.cornerRadius = 5;
    
    _sendBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"red_btn", @"png")];
    _sendBtn.layer.cornerRadius = 5;
    _sendBtn.clipsToBounds = YES;
    
    _sureModifyBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"red_btn", @"png")];
    _sureModifyBtn.layer.cornerRadius = 5;
    _sureModifyBtn.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
