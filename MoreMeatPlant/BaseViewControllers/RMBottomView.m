//
//  RMBottomView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBottomView.h"
#import "CONST.h"
#import "UIButton+EnlargeEdge.h"

@implementation RMBottomView

- (void)loadBottomWithImageArr:(NSArray *)imageArr {
    UIImageView * bgImageView = [[UIImageView alloc] init];
    bgImageView.image = LOADIMAGE(@"bottom", kImageTypePNG);
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.multipleTouchEnabled = YES;
    bgImageView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [self addSubview:bgImageView];

    if ([imageArr count] == 3){
        for (NSInteger i=0; i<3; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.frame = CGRectMake(0, 0, 28, 28);
            if (i==0){
                button.center = CGPointMake(20, 20);
            }else if (i==1){
                button.center = CGPointMake(kScreenWidth/2, 20);
            }else{
                button.center = CGPointMake(kScreenWidth - 25, 20);
            }
            [button setBackgroundImage:LOADIMAGE([imageArr objectAtIndex:i], kImageTypePNG) forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
            [self addSubview:button];
        }
    }else if ([imageArr count] == 4){
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
                button.center = CGPointMake(kScreenWidth - 25, 20);
            }
            [button setBackgroundImage:LOADIMAGE([imageArr objectAtIndex:i], kImageTypePNG) forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
            [self addSubview:button];
        }
    }
}

- (void)bottomButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bottomMethodWithTag:)]){
        [self.delegate bottomMethodWithTag:sender.tag];
    }
}

@end
