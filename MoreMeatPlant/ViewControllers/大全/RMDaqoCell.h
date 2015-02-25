//
//  RMDaqoCell.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/17.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

@protocol DaqpSelectedPlantTypeDelegate <NSObject>

- (void)daqoSelectedPlantTypeMethod:(RMImageView *)image;

@end

@interface RMDaqoCell : UITableViewCell
@property (nonatomic, assign) id<DaqpSelectedPlantTypeDelegate>delegate;

@property (weak, nonatomic) IBOutlet RMImageView *leftImg;
@property (weak, nonatomic) IBOutlet RMImageView *centerImg;
@property (weak, nonatomic) IBOutlet RMImageView *rightImg;

@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *centerTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;

@end
