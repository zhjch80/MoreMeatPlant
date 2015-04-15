//
//  RMHomeHeadView.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMHomeHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UILabel *content_signature;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *hua_bi;
@property (weak, nonatomic) IBOutlet UIButton *sendPrivateMsgBtn;
@property (weak, nonatomic) IBOutlet UIButton *attentionHeBtn;
@end
