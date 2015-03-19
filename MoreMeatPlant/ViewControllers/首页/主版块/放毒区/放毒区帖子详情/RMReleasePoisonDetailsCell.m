//
//  RMReleasePoisonDetailsCell.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/11.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMReleasePoisonDetailsCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation RMReleasePoisonDetailsCell

- (void)awakeFromNib {
    // Initialization code
    [self.toPromoteImg addTarget:self WithSelector:@selector(jumpPromoteClick:)];
    [self.addPraiseImg addTarget:self WithSelector:@selector(addPraiseClick:)];
    
    [self.userHead_1 addTarget:self WithSelector:@selector(userHeadClick:)];
    [self.userHead_1.layer setCornerRadius:20.0];
    
    [self.userHead_2 addTarget:self WithSelector:@selector(userHeadClick:)];
    [self.userHead_2.layer setCornerRadius:20.0];
    
    [self.comments_2_1_bgView.layer setCornerRadius:6.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)jumpPromoteClick:(RMImageView *)image {
    if ([self.delegate respondsToSelector:@selector(jumpPromoteMethod:)]){
        [self.delegate jumpPromoteMethod:image];
    }
}

- (void)addPraiseClick:(RMImageView *)image {
    if ([self.delegate respondsToSelector:@selector(addPraiseMethod:)]){
        [self.delegate addPraiseMethod:image];
    }
}

- (void)userHeadClick:(RMImageView *)image {
    if ([self.delegate respondsToSelector:@selector(userHeadMethod:)]){
        [self.delegate userHeadMethod:image];
    }
}

- (IBAction)replyClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(replyMethod:)]){
        [self.delegate replyMethod:sender];
    }
}

@end
