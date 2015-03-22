//
//  RMOrderDetailProTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/22.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMOrderDetailProTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UILabel *content_price;
@property (weak, nonatomic) IBOutlet UILabel *content_num;
@property (weak, nonatomic) IBOutlet UITextField *evaluateTextField;

@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fieldHeght;
@end
