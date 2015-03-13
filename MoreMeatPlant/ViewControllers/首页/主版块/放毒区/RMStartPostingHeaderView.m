//
//  RMStartPostingHeaderView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMStartPostingHeaderView.h"

@implementation RMStartPostingHeaderView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(headerNavMethodWithTag:)]){
        [self.delegate headerNavMethodWithTag:sender.tag];
    }
}

@end
