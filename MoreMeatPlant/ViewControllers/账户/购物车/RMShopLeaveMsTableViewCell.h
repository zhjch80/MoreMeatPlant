//
//  RMShopLeaveMsTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/9.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMShopLeaveMsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *leaveMessageT;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *totalL;
@property (weak, nonatomic) IBOutlet UIButton *contactCorpBtn;
@property (weak, nonatomic) IBOutlet UILabel *express_price;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_line;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_line2;

@end
