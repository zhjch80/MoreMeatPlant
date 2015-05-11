//
//  RMOrderAddressTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/5/5.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMOrderAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content_mobile;
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UILabel *content_address;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_line;
@end
