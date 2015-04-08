//
//  RMRecordsTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/8.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMRecordsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content_desc;
@property (weak, nonatomic) IBOutlet UILabel *content_money;
@property (weak, nonatomic) IBOutlet UILabel *content_status;

@property (weak, nonatomic) IBOutlet UILabel *content_time;
@end
