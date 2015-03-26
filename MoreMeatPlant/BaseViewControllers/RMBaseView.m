//
//  RMBaseView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseView.h"
#import "CONST.h"

@interface RMBaseView(){
    
}

@end

@implementation RMBaseView
@synthesize identifierString;

- (void)addTarget:(id)target withSelector:(SEL)sel{
    _target = target;
    _sel = sel;
    self.userInteractionEnabled = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_target) {
        SuppressPerformSelectorLeakWarning (
                                            [_target performSelector:_sel withObject:self]
                                            );
    }
}

@end
