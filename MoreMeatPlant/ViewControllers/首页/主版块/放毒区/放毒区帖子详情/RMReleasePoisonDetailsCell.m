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
    [self.toPromoteImg addTarget:self withSelector:@selector(jumpPromoteClick:)];
    [self.addPraiseImg addTarget:self withSelector:@selector(addPraiseClick:)];
    
    [self.userHead_1 addTarget:self withSelector:@selector(userHeadClick:)];
    [self.userHead_1.layer setCornerRadius:20.0];
    
    [self.userHead_2 addTarget:self withSelector:@selector(userHeadClick:)];
    [self.userHead_2.layer setCornerRadius:20.0];
    
    [self.comments_2_1_bgView.layer setCornerRadius:6.0f];
    
    self.userHead_1.clipsToBounds = YES;
    self.userHead_2.clipsToBounds = YES;
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

- (IBAction)replyClick:(RMBaseButton *)sender {
    if ([self.delegate respondsToSelector:@selector(replyMethod:)]){
        [self.delegate replyMethod:sender];
    }
}

- (CGRect)boundingRectCommentWith:(NSString *)str {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FZZHJW--GB1-0" size:13.0], NSFontAttributeName, nil];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width - 75, 0)
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:attrs
                                      context:nil];
    return rect;
}

@end
