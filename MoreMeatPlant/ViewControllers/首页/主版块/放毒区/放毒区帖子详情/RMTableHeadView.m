//
//  RMTableHeadView.m
//  MoreMeatPlant
//
//  Created by 郑俊超 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMTableHeadView.h"

@implementation RMTableHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)reportClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(reportMethod:)]){
        [self.delegate reportMethod:sender];
    }
}

@end
