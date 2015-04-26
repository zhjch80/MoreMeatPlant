//
//  RMStartLongPostingCell.m
//  MoreMeatPlant
//
//  Created by mobei on 15/4/23.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMStartLongPostingCell.h"
#import "UIImage+LK.h"
#import "UtilityFunc.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@implementation RMStartLongPostingCell

- (void)awakeFromNib {
    // Initialization code
    [self.editTitleBtn.layer setCornerRadius:5.0];
    self.editTitleBtn.clipsToBounds = YES;
    
    self.imageContent.userInteractionEnabled = YES;
    self.imageContent.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editingContentWithTag:)]){
        [self.delegate editingContentWithTag:sender.tag];
    }
}

- (void)adjustsTextContentFrameWithText:(NSString *)text {
    CGFloat height = [UtilityFunc boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 0) font:FONT(14.0) text:text].height;
    self.textContent.frame = CGRectMake(self.textContent.frame.origin.x, 3, kScreenWidth - 10, height);
    self.textContent.text = text;
    self.textContent.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    [self.textContent sizeToFit];
    self.line_3.frame = CGRectMake(5, self.textContent.frame.size.height + 5, kScreenWidth - 10, 1);
    self.frame = CGRectMake(0, 0, kScreenWidth, self.textContent.frame.size.height + 6);
}

- (void)adjustsImageContentFrameWithImage:(UIImage *)image {
    self.imageContent.image = image;
    CGFloat height = image.size.height/image.size.width * kScreenWidth;
    self.imageContent.frame = CGRectMake(0, 0, kScreenWidth, height);
    self.frame = CGRectMake(0, 0, kScreenWidth, height + 3);
}

@end
