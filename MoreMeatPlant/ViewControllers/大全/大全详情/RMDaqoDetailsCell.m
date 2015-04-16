//
//  RMDaqoDetailsCell.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/21.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMDaqoDetailsCell.h"

@implementation RMDaqoDetailsCell

- (void)awakeFromNib {
    // Initialization code
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.plantName.frame = CGRectMake(width - 110, 3, 100, 60);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(daqoqMethodWithTag:)]){
        [self.delegate daqoqMethodWithTag:sender.tag];
    }
}

@end
