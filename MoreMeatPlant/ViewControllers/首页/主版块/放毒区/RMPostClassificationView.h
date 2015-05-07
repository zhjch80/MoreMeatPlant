//
//  RMPostClassificationView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PostClassificationDelegate <NSObject>

@optional

- (void)selectedPlantType:(NSInteger)type_1 withType:(NSInteger)type_2;

@end

@interface RMPostClassificationView : UIView
@property (nonatomic, assign) id<PostClassificationDelegate>delegate;

- (void)initWithPostClassificationViewWithPlantArr:(NSArray *)plants withSubsPlant:(NSArray *)subs;

- (void)show;

- (void)dismiss;

//更新食物科目选择状态
- (void)updataPlantClassificationSelectStateWith:(NSInteger)value;


@end
