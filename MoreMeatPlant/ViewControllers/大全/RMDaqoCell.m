//
//  RMDaqoCell.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/17.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMDaqoCell.h"

@implementation RMDaqoCell

- (void)awakeFromNib {
    // Initialization code
    [self.leftImg addTarget:self WithSelector:@selector(selectedPlantType:)];
    [self.centerImg addTarget:self WithSelector:@selector(selectedPlantType:)];
    [self.rightImg addTarget:self WithSelector:@selector(selectedPlantType:)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)selectedPlantType:(RMImageView *)image {
    if ([self.delegate respondsToSelector:@selector(daqoSelectedPlantTypeMethod:)]){
        [self.delegate daqoSelectedPlantTypeMethod:image];
    }
}

@end
