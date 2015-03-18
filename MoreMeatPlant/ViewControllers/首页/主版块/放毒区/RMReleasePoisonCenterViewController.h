//
//  RMReleasePoisonViewController.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMReleasePoisonCenterViewController : RMBaseViewController

@property (nonatomic, assign) id PoisonDelegate;

@property (nonatomic, strong) UITapGestureRecognizer * enabledGesture;

@end
