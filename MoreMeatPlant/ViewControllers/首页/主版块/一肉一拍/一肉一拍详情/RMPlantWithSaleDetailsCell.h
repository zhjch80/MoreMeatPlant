//
//  RMPlantWithSaleDetailsCell.h
//  MoreMeatPlant
//
//  Created by 郑俊超 on 15/3/14.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  PlantWithSaleDetailsDelegate <NSObject>

@optional

- (void)method;

@end

@interface RMPlantWithSaleDetailsCell : UITableViewCell
@property (nonatomic, assign) id <PlantWithSaleDetailsDelegate>delegate;

@end
