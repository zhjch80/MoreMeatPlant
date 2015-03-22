//
//  RMBottomView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomDelegate <NSObject>

@optional

/**
 @method    回调方法
 */
- (void)bottomMethodWithTag:(NSInteger)tag;

@end

@interface RMBottomView : UIView
@property (nonatomic, assign) id<BottomDelegate>delegate;

/**
 *  @name 底部状态栏
 *  @param  imageArr        图片资源
 */
- (void)loadBottomWithImageArr:(NSArray *)imageArr;

@end
