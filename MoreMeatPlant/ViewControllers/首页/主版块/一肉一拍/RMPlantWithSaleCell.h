//
//  RMPlantWithSaleCell.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

@protocol JumpPlantDetailsDelegate <NSObject>

- (void)jumpPlantDetailsWithImage:(RMImageView *)image;

@end

@interface RMPlantWithSaleCell : UITableViewCell
@property (nonatomic, assign) id<JumpPlantDetailsDelegate>delegate;

@property (weak, nonatomic) IBOutlet RMImageView *leftImg;
@property (weak, nonatomic) IBOutlet RMImageView *centerImg;
@property (weak, nonatomic) IBOutlet RMImageView *rightImg;

@property (weak, nonatomic) IBOutlet UILabel *leftPrice;
@property (weak, nonatomic) IBOutlet UILabel *centerPrice;
@property (weak, nonatomic) IBOutlet UILabel *rightPrice;

@property (weak, nonatomic) IBOutlet UILabel *leftName;
@property (weak, nonatomic) IBOutlet UILabel *centerName;
@property (weak, nonatomic) IBOutlet UILabel *rightName;






@end
