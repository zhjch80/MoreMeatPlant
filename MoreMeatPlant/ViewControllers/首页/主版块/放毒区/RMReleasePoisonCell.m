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
    
    [self.leftImg addTarget:self withSelector:@selector(selectedPostDetatils:)];
    [self.rightImg addTarget:self withSelector:@selector(selectedPostDetatils:)];
    
    [self.leftTwoImg addTarget:self withSelector:@selector(selectedPostDetatils:)];
    [self.rightUpTwoImg addTarget:self withSelector:@selector(selectedPostDetatils:)];
    [self.rightDownTwoImg addTarget:self withSelector:@selector(selectedPostDetatils:)];
    
    [self.threeImg addTarget:self withSelector:@selector(selectedPostDetatils:)];
    
    [self.likeImg addTarget:self withSelector:@selector(addLike:)];
    [self.chatImg addTarget:self withSelector:@selector(addChat:)];
    [self.praiseImg addTarget:self withSelector:@selector(addPraise:)];
    
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
