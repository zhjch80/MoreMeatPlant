//
//  RMPlantWithSaleCell.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantWithSaleCell.h"

@implementation RMPlantWithSaleCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.leftImg addTarget:self WithSelector:@selector(selectedImgJumpPlantDetails:)];
    [self.centerImg addTarget:self WithSelector:@selector(selectedImgJumpPlantDetails:)];
    [self.rightImg addTarget:self WithSelector:@selector(selectedImgJumpPlantDetails:)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)selectedImgJumpPlantDetails:(RMImageView *)image {
    if ([self.delegate respondsToSelector:@selector(jumpPlantDetailsWithImage:)])
        [self.delegate jumpPlantDetailsWithImage:image];
}

@end
