//
//  RMUserInfoTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/23.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMUserInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nickL;
@property (weak, nonatomic) IBOutlet UILabel *passwordL;
@property (weak, nonatomic) IBOutlet UILabel *signatureL;
@property (weak, nonatomic) IBOutlet UILabel *mobileL;
@property (weak, nonatomic) IBOutlet UILabel *apliyL;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *content_face;
@end
