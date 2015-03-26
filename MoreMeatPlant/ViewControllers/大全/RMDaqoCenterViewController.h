//
//  RMDaqoCenterViewController.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMDaqoCenterViewController : RMBaseViewController

@property (nonatomic, assign) id DaqoDelegate;

@property (nonatomic, strong) UIView * recognizerView;

//请求分类接口
- (void)requestPlantSubjects;

//请求list
- (void)requestDataWithPageCount:(NSInteger)pc;

@end
