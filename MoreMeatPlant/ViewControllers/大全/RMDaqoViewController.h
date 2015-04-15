//
//  RMDaqoViewController.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMDaqoViewController : RMBaseViewController

/**
 *  管理侧滑的开关状态
 */
- (void)updateSlideSwitchState;

- (void)updataSlideStateClose;

//刷新中间控制器list
- (void)updateCenterListWithModel:(RMPublicModel *)model withRow:(NSInteger)row;

@end
