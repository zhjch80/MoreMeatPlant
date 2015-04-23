//
//  RMBaseButton.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/4/10.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMBaseButton : UIButton

@property (nonatomic, strong) NSString * parameter_1;
@property (nonatomic, strong) NSString * parameter_2;

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;

@end
