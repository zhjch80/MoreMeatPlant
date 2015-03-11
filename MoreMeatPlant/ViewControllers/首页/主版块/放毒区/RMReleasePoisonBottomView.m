//
//  RMReleasePoisonBottomView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMReleasePoisonBottomView.h"
#import "CONST.h"

@implementation RMReleasePoisonBottomView

#pragma mark - 放毒区首页底部栏

- (void)loadReleasePoisonBottom {
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
    if ([self.delegate respondsToSelector:@selector(releasePoisonBottomMethodWithTag:)]){
        [self.delegate releasePoisonBottomMethodWithTag:button.tag];
    }
}

#pragma mark - 放毒区详情底部栏

- (void)loadReleasePoisonDetailsBottom {
    UIImageView * bgimage = [[UIImageView alloc] init];
    bgimage.image = LOADIMAGE(@"bottom", kImageTypePNG);
    bgimage.backgroundColor = [UIColor clearColor];
    bgimage.userInteractionEnabled = YES;
    bgimage.multipleTouchEnabled = YES;
    bgimage.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [self addSubview:bgimage];
    
    for (NSInteger i=0; i<4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(0, 0, 40, 40);
        if (i==0){
            button.center = CGPointMake(20, 20);
        }else if (i==1){
            button.center = CGPointMake(kScreenWidth/3+10, 20);
        }else if (i==2){
            button.center = CGPointMake(kScreenWidth/3+kScreenWidth/2-60, 20);
        }else{
            button.center = CGPointMake(kScreenWidth - 20, 20);
        }
        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(buttonReleaseDetailsPoisonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonReleaseDetailsPoisonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(releasePoisonDetailsBottomMethodWithTag:)]){
        [self.delegate releasePoisonDetailsBottomMethodWithTag:button.tag];
    }
}

@end
