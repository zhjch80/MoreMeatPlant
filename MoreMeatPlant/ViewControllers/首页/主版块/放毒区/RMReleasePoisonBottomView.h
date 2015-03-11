//
//  RMReleasePoisonBottomView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReleasePoisonBottomDelegate <NSObject>

@optional
/**
 *  @method 放毒区首页底部栏回调方法
 */
- (void)releasePoisonBottomMethodWithTag:(NSInteger)tag;

/**
 *  @method 放毒区详情底部栏回调方法
 */
- (void)releasePoisonDetailsBottomMethodWithTag:(NSInteger)tag;

@end

@interface RMReleasePoisonBottomView : UIView
@property (nonatomic, assign) id<ReleasePoisonBottomDelegate>delegate;

/**
 *  @name 放毒区首页底部栏
 */
- (void)loadReleasePoisonBottom;

/**
 *  @name 放毒区详情底部栏
 */
- (void)loadReleasePoisonDetailsBottom;

@end
