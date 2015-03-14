//
//  RMPlantWithSaleHeaderView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlantWithSaleHeaderViewDelegate <NSObject>

- (void)intoShopMethodWithBtn:(UIButton *)button;

@end

@interface RMPlantWithSaleHeaderView : UIView
@property (nonatomic, assign) id<PlantWithSaleHeaderViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *userHeader;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userLocation;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;

@property (weak, nonatomic) IBOutlet UIButton *intoShopBtn;

@end
