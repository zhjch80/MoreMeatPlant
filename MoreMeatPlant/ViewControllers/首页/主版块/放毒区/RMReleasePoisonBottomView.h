//
//  RMReleasePoisonBottomView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReleasePoisonBottomDelegate <NSObject>

- (void)releasePoisonBottomMethodWithTag:(NSInteger)tag;

@end

@interface RMReleasePoisonBottomView : UIView
@property (nonatomic, assign) id<ReleasePoisonBottomDelegate>delegate;

- (void)loadReleasePoisonBottom;

@end
