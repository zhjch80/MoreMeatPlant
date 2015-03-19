//
//  RMPlantTypeView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/17.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectedPlantTypeMethodDelegate <NSObject>
/**
 *  @name 选择肉肉类型
 */
- (void)selectedPlantWithType:(NSString *)type;

@end

@interface RMPlantTypeView : UIView
@property (nonatomic, assign) id<SelectedPlantTypeMethodDelegate>delegate;

- (void)loadPlantType;
@end
