//
//  RMReleasePoisonCell.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/17.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMReleasePoisonCell.h"

@implementation RMReleasePoisonCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView.layer setCornerRadius:8.0];
    [self.userHeadImg.layer setCornerRadius:12.0];
    
    [self.leftImg addTarget:self WithSelector:@selector(selectedPostDetatils:)];
    [self.rightImg addTarget:self WithSelector:@selector(selectedPostDetatils:)];
    
    [self.leftTwoImg addTarget:self WithSelector:@selector(selectedPostDetatils:)];
    [self.rightUpTwoImg addTarget:self WithSelector:@selector(selectedPostDetatils:)];
    [self.rightDownTwoImg addTarget:self WithSelector:@selector(selectedPostDetatils:)];
    
    [self.threeImg addTarget:self WithSelector:@selector(selectedPostDetatils:)];
    
    [self.likeImg addTarget:self WithSelector:@selector(addLike:)];
    [self.chatImg addTarget:self WithSelector:@selector(addChat:)];
    [self.praiseImg addTarget:self WithSelector:@selector(addPraise:)];
    
}

- (void)selectedPostDetatils:(RMImageView *)image {
    if ([self.delegate respondsToSelector:@selector(jumpPostDetailsWithImage:)]){
        [self.delegate jumpPostDetailsWithImage:image];
    }
}

- (void)addLike:(RMImageView *)image {
    if ([self.delegate respondsToSelector:@selector(addLikeWithImage:)]){
        [self.delegate addLikeWithImage:image];
    }
}

- (void)addChat:(RMImageView *)image {
    if ([self.delegate respondsToSelector:@selector(addChatWithImage:)]){
        [self.delegate addChatWithImage:image];
    }
}

- (void)addPraise:(RMImageView *)image {
    if ([self.delegate respondsToSelector:@selector(addPraiseWithImage:)]){
        [self.delegate addPraiseWithImage:image];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
