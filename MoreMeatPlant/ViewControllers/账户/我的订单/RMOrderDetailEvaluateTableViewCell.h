//
//  RMOrderDetailEvaluateTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/22.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMOrderDetailEvaluateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bad;
@property (weak, nonatomic) IBOutlet UILabel *general;
@property (weak, nonatomic) IBOutlet UILabel *good;
@property (weak, nonatomic) IBOutlet UILabel *pefect;
@property (weak, nonatomic) IBOutlet UIButton *banImg;
@property (weak, nonatomic) IBOutlet UIButton *generalImg;
@property (weak, nonatomic) IBOutlet UIButton *goodImg;
@property (weak, nonatomic) IBOutlet UIButton *pefectImg;

@end
