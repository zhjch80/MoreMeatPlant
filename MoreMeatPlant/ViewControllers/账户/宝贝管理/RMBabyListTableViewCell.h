//
//  RMBabyListTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMBabyListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UILabel *content_price;
@property (weak, nonatomic) IBOutlet UIButton *modify_btn;
@property (weak, nonatomic) IBOutlet UIButton *shelves_btn;
@property (weak, nonatomic) IBOutlet UIButton *delete_btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteWidth;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shelfWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shelfHeight;

@end
