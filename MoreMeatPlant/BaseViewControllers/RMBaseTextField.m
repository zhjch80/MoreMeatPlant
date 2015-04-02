//
//  RMBaseTextField.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseTextField.h"

@implementation RMBaseTextField
@synthesize offset_top;
@synthesize offset_left;

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [[UITextField appearance] setTintColor:[UIColor redColor]];
        offset_top = 1.0;
        offset_left = 3.0;
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [[UITextField appearance] setTintColor:[UIColor redColor]];
        offset_top = 1.0;
        offset_left = 3.0;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(offset_left, offset_top, bounds.size.width, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(offset_left, offset_top, bounds.size.width, bounds.size.height);
}

//控制placeHolder的位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(offset_left, offset_top, bounds.size.width-5, bounds.size.height);
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
