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
    [self.userHead addTarget:self WithSelector:@selector(userHeadClick:)];
    
    [self.ReportImg.layer setCornerRadius:8.0];
    [self.userHead.layer setCornerRadius:20.0];
    
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

@end
