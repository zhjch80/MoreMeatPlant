//
//  RMCorpHeadTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/5/3.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMCorpHeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bannerImgV;
@property (weak, nonatomic) IBOutlet UIImageView *corp_headImgV;
@property (weak, nonatomic) IBOutlet UILabel *corp_nameL;
@property (weak, nonatomic) IBOutlet UILabel *signatureL;
@property (weak, nonatomic) IBOutlet UILabel *corp_regionL;
@property (weak, nonatomic) IBOutlet UIButton *corp_level;
@property (weak, nonatomic) IBOutlet UIButton *corp_renzheng;
@property (weak, nonatomic) IBOutlet UIButton *corp_sun;
@property (weak, nonatomic) IBOutlet UIButton *collection;
@property (weak, nonatomic) IBOutlet UIView *headbackView;
@property (weak, nonatomic) IBOutlet UIView *classesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *renzhengWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *renzheng_rightspace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectWidth;
@end
