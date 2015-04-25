//
//  RMCorpInfoTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/23.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMCorpInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nickL;
@property (weak, nonatomic) IBOutlet UILabel *passwordL;
@property (weak, nonatomic) IBOutlet UILabel *signatureL;
@property (weak, nonatomic) IBOutlet UILabel *mobileL;
@property (weak, nonatomic) IBOutlet UILabel *apliyL;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *content_face;
@property (weak, nonatomic) IBOutlet UILabel *content_linkL;
@property (weak, nonatomic) IBOutlet UILabel *content_mobileL;
@property (weak, nonatomic) IBOutlet UILabel *content_addressL;

@property (weak, nonatomic) IBOutlet UIImageView *card_photo;
@property (weak, nonatomic) IBOutlet UIImageView *corp_photo;
@end
