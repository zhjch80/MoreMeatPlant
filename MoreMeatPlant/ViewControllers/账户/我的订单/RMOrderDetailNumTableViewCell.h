//
//  RMOrderDetailNumTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/22.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMOrderDetailNumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *totalNumL;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *content_realpayL;
@property (weak, nonatomic) IBOutlet UILabel *express_price;
@end
