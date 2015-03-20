//
//  RMPlantWithSaleDetailsCell.m
//  MoreMeatPlant
//
//  Created by 郑俊超 on 15/3/14.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantWithSaleDetailsCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation RMPlantWithSaleDetailsCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.buyNowBtn.layer setCornerRadius:5.0f];
    [self.addToCartBtn.layer setCornerRadius:5.0f];
    [self.contactSeller.layer setCornerRadius:5.0f];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)plantWithSlaeCellBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(plantWithSaleCellMethodWithTag:)]){
        [self.delegate plantWithSaleCellMethodWithTag:sender.tag];
    }
}


@end
