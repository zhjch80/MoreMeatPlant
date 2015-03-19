//
//  RMPlantWithSaleHeaderView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantWithSaleHeaderView.h"

@implementation RMPlantWithSaleHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)intoShopClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(intoShopMethodWithBtn:)]){
        [self.delegate intoShopMethodWithBtn:sender];
    }
}

@end
