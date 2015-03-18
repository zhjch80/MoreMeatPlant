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
 *  @method 放毒区首页底部栏回调方法
 */
- (void)releasePoisonBottomMethodWithTag:(NSInteger)tag;

/**
 *  @method 放毒区详情底部栏回调方法
 */
- (void)releasePoisonDetailsBottomMethodWithTag:(NSInteger)tag;

/**
 *  @method 一肉一拍底部栏回调方法
 */
- (void)plantWithSaleBottomMethodWithTag:(NSInteger)tag;

/**
 *  @method 一肉一拍详情底部栏回调方法
 */
- (void)plantWithSaleDetailsBottomMethodWithTag:(NSInteger)tag;

@end

@interface RMBottomView : UIView
@property (nonatomic, assign) id<BottomDelegate>delegate;


/**
 *  @name 放毒区首页底部栏
 */
- (void)loadReleasePoisonBottom;

/**
 *  @name 放毒区详情底部栏
 */
- (void)loadReleasePoisonDetailsBottom;

/**
 *  @method 一肉一拍底部栏回调方法
 */
- (void)loadPlantWithSaleBottomView;

/**
 *  @method 一肉一拍底详情部栏回调方法
 */
- (void)loadPlantWithSaleDetailsBottomView;

@end
