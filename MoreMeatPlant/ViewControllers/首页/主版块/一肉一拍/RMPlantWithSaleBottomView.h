//
//  RMPlantWithSaleBottomView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlantWithSaleBottomDelegate <NSObject>

- (void)plantWithSaleBottomMethodWithTag:(NSInteger)tag;

@end

@interface RMPlantWithSaleBottomView : UIView
@property (nonatomic, assign) id<PlantWithSaleBottomDelegate>delegate;

- (void)loadPlantWithSaleBottomView;

@end
