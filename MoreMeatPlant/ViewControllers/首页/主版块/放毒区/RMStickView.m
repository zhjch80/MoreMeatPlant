//
//  RMStickView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMStickView.h"

@implementation RMStickView

- (void)loadStickViewWithTitle:(NSString *)title withOrder:(NSInteger)order {
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    NSString * str = [NSString stringWithFormat:@"  置顶  %@",title];
    
    UILabel * sTitle = [[UILabel alloc] init];
    sTitle.frame = CGRectMake(0, 0, width, self.frame.size.height-1);
    sTitle.font = FONT_1(14.0);
    sTitle.text = str;
    [self addSubview:sTitle];
    
    NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:str];
    [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] range:NSMakeRange(2, 2)];
    [oneAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(2, 2)];
    sTitle.attributedText = oneAttributeStr;
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    line.frame = CGRectMake(0, self.frame.size.height - 1, width, 1);
    [self addSubview:line];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.tag = order;
    button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [button addTarget:self action:@selector(jumpStickDetails:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)jumpStickDetails:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(stickJumpDetailsWithOrder:)]){
        [self.delegate stickJumpDetailsWithOrder:sender.tag];
    }
}

@end
