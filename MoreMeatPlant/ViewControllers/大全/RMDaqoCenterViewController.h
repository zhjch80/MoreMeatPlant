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
- (void)requestDataWithPageCount:(NSInteger)pc withPlantType:(NSString *)plantType;

//获取全部肉肉总数量
- (void)requestDaqoAllCounts;

//刷新当前list
- (void)updateCurrentList:(RMPublicModel *)model withRow:(NSInteger)row;

@end
