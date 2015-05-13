//
//  RMAddressTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/10.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectAddressBtn;
@property (weak, nonatomic) IBOutlet UILabel *linkName;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_line;

@end
