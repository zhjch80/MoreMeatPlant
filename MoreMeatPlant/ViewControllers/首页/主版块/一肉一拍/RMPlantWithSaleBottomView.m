//
//  RMPlantWithSaleBottomView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantWithSaleBottomView.h"
#import "CONST.h"

@implementation RMPlantWithSaleBottomView

- (void)loadPlantWithSaleBottomView {
    UIImageView * bgimage = [[UIImageView alloc] init];
    bgimage.image = LOADIMAGE(@"bottom", kImageTypePNG);
    bgimage.backgroundColor = [UIColor clearColor];
    bgimage.userInteractionEnabled = YES;
    bgimage.multipleTouchEnabled = YES;
    bgimage.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [self addSubview:bgimage];
    
    for (NSInteger i=0; i<3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(0, 0, 40, 40);
        if (i==0){
            button.center = CGPointMake(20, 20);
        }else if (i==1){
            button.center = CGPointMake(kScreenWidth/2, 20);
        }else{
            button.center = CGPointMake(kScreenWidth - 20, 20);
        }
        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(buttonReleasePoisonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonReleasePoisonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(plantWithSaleBottomMethodWithTag:)]){
        [self.delegate plantWithSaleBottomMethodWithTag:button.tag];
    }
}

@end
