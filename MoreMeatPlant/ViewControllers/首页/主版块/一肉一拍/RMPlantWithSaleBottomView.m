//
//  RMPlantWithSaleBottomView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantWithSaleBottomView.h"
#import "CONST.h"
#import "UIButton+EnlargeEdge.h"

@implementation RMPlantWithSaleBottomView

- (void)loadPlantWithSaleBottomView {
    UIImageView * bgimage = [[UIImageView alloc] init];
    bgimage.image = LOADIMAGE(@"bottom", kImageTypePNG);
    bgimage.backgroundColor = [UIColor clearColor];
    bgimage.userInteractionEnabled = YES;
    bgimage.multipleTouchEnabled = YES;
    bgimage.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [self addSubview:bgimage];
    
    NSArray * btnArr = [NSArray arrayWithObjects:@"img_backup", @"img_up", @"img_moreChat", nil];

    for (NSInteger i=0; i<3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(0, 0, 28, 28);
        if (i==0){
            button.center = CGPointMake(20, 20);
        }else if (i==1){
            button.center = CGPointMake(kScreenWidth/2, 20);
        }else{
            button.center = CGPointMake(kScreenWidth - 20, 20);
        }
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonReleasePoisonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:LOADIMAGE([btnArr objectAtIndex:i], kImageTypePNG) forState:UIControlStateNormal];
        [button setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [self addSubview:button];
    }
}

- (void)buttonReleasePoisonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(plantWithSaleBottomMethodWithTag:)]){
        [self.delegate plantWithSaleBottomMethodWithTag:button.tag];
    }
}

#pragma mark - 详情

- (void)loadPlantWithSaleDetailsBottomView {
    UIImageView * bgimage = [[UIImageView alloc] init];
    bgimage.image = LOADIMAGE(@"bottom", kImageTypePNG);
    bgimage.backgroundColor = [UIColor clearColor];
    bgimage.userInteractionEnabled = YES;
    bgimage.multipleTouchEnabled = YES;
    bgimage.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [self addSubview:bgimage];
    
    NSArray * btnArr = [NSArray arrayWithObjects:@"img_backup", @"img_collectiom", @"img_buy", @"img_share", nil];
    
    for (NSInteger i=0; i<4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(0, 0, 28, 28);
        if (i==0){
            button.center = CGPointMake(20, 20);
        }else if (i==1){
            button.center = CGPointMake(kScreenWidth/3+10, 20);
        }else if (i==2){
            button.center = CGPointMake(kScreenWidth/3+kScreenWidth/2-60, 20);
        }else{
            button.center = CGPointMake(kScreenWidth - 20, 20);
        }
        [button setBackgroundImage:LOADIMAGE([btnArr objectAtIndex:i], kImageTypePNG) forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonPlantWithSaleDetailsClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [self addSubview:button];
    }
}

- (void)buttonPlantWithSaleDetailsClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(plantWithSaleDetailsBottomMethodWithTag:)]){
        [self.delegate plantWithSaleDetailsBottomMethodWithTag:button.tag];
    }
}

@end
