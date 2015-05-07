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
    
    self.leftImg.clipsToBounds = YES;
    self.centerImg.clipsToBounds = YES;
    self.rightImg.clipsToBounds = YES;

//    self.leftImg.contentMode = UIViewContentModeCenter;
//    self.centerImg.contentMode = UIViewContentModeCenter;
//    self.rightImg.contentMode = UIViewContentModeCenter;

    [self.leftImg addTarget:self withSelector:@selector(selectedImgJumpPlantDetails:)];
    [self.centerImg addTarget:self withSelector:@selector(selectedImgJumpPlantDetails:)];
    [self.rightImg addTarget:self withSelector:@selector(selectedImgJumpPlantDetails:)];

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
