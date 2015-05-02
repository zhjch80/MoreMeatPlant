//
//  RMHadbabyTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMHadbabyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *leaveMsg;
@property (weak, nonatomic) IBOutlet UITextField *note;
@property (weak, nonatomic) IBOutlet UILabel *content_num;
@property (weak, nonatomic) IBOutlet UILabel *total_money;
@property (weak, nonatomic) IBOutlet UILabel *express;

@property (weak, nonatomic) IBOutlet UILabel *realy_total;
@property (weak, nonatomic) IBOutlet UILabel *content_mobile;
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UILabel *content_address;
@property (weak, nonatomic) IBOutlet UIButton *btn_right;
@property (weak, nonatomic) IBOutlet UIButton *left_btn;
@end
