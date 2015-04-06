//
//  RMOrderBottomTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMOrderBottomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *totalNumL;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *content_realpayL;
@property (weak, nonatomic) IBOutlet UILabel *express_price;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@end
