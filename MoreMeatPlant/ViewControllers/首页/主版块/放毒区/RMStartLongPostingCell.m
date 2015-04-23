//
//  RMStartLongPostingCell.m
//  MoreMeatPlant
//
//  Created by mobei on 15/4/23.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMStartLongPostingCell.h"

@implementation RMStartLongPostingCell

- (void)awakeFromNib {
    // Initialization code
    [self.editTitleBtn.layer setCornerRadius:5.0];
    self.editTitleBtn.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editingContentWithTag:)]){
        [self.delegate editingContentWithTag:sender.tag];
    }
}

@end
