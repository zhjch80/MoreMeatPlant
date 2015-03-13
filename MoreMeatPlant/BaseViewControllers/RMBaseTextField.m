//
//  RMBaseTextField.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseTextField.h"

@implementation RMBaseTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(10, 3, bounds.size.width, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(10, 3, bounds.size.width, bounds.size.height);
}

//控制placeHolder的位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(10, 3, bounds.size.width-5, bounds.size.height);
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect {
    if (self.placeHolderColor) {
        [self.placeHolderColor setFill];
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil];
        [[self placeholder] drawInRect:rect withAttributes:attrs];
    } else {
        [super drawPlaceholderInRect:rect];
    }
}

@end
