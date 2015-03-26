//
//  RMImageView.m
//  RMVideo
//
//  Created by runmobile on 14-10-13.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMImageView.h"
#import "CONST.h"

@implementation RMImageView
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
