//
//  RMPostMessageView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostMessageSelectedPlantDelegate <NSObject>

- (void)selectedPostMessageWithPostsType:(NSInteger)type_1 withPlantType:(NSInteger)type_2;

@end

@interface RMPostMessageView : UIView
@property (nonatomic, assign) id<PostMessageSelectedPlantDelegate>delegate;

- (void)initWithPostMessageViewWithPlantArr:(NSArray *)plants withSubsPlant:(NSArray *)subs;

- (void)show;

- (void)dismiss;

@end
