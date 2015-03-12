//
//  RMPlantWithSaleBottomView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlantWithSaleBottomDelegate <NSObject>

@optional

/**
 *  @method 一肉一拍底部栏回调方法
 */
- (void)plantWithSaleBottomMethodWithTag:(NSInteger)tag;

/**
 *  @method 一肉一拍详情底部栏回调方法
 */
- (void)plantWithSaleDetailsBottomMethodWithTag:(NSInteger)tag;

@end

@interface RMPlantWithSaleBottomView : UIView
@property (nonatomic, assign) id<PlantWithSaleBottomDelegate>delegate;

/**
 *  @method 一肉一拍底部栏回调方法
 */
- (void)loadPlantWithSaleBottomView;

/**
 *  @method 一肉一拍底详情部栏回调方法
 */
- (void)loadPlantWithSaleDetailsBottomView;

@end
