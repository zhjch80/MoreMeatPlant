//
//  RMBaseTextView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseTextView.h"

@implementation RMBaseTextView

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [[UITextView appearance] setTintColor:[UIColor redColor]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [[UITextView appearance] setTintColor:[UIColor redColor]];
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
