//
//  RMLongPostFooterView.m
//  MoreMeatPlant
//
//  Created by mobei on 15/4/24.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMLongPostFooterView.h"
#import "CONST.h"

@implementation RMLongPostFooterView

- (IBAction)addSomeContentClick:(RMBaseButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addSomeContentWithSection:withRow:withType:)]){
        [self.delegate addSomeContentWithSection:sender.section withRow:sender.row withType:sender.tag];
    }
}

@end
