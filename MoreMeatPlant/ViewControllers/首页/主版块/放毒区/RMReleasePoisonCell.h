//
//  RMReleasePoisonCell.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/17.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

@protocol PostDetatilsDelegate <NSObject>

- (void)jumpPostDetailsWithImage:(RMImageView *)image;

- (void)addLikeWithImage:(RMImageView *)image;

- (void)addChatWithImage:(RMImageView *)image;

- (void)addPraiseWithImage:(RMImageView *)image;

@end

@interface RMReleasePoisonCell : UITableViewCell
@property (nonatomic, assign) id<PostDetatilsDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *plantTitle;

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet RMImageView *likeImg;
@property (weak, nonatomic) IBOutlet UILabel *likeTitle;
@property (weak, nonatomic) IBOutlet RMImageView *chatImg;
@property (weak, nonatomic) IBOutlet UILabel *chatTitle;
@property (weak, nonatomic) IBOutlet RMImageView *praiseImg;
@property (weak, nonatomic) IBOutlet UILabel *praiseTitle;

//类型一
@property (weak, nonatomic) IBOutlet RMImageView *leftImg;
@property (weak, nonatomic) IBOutlet RMImageView *rightImg;

//类型二
@property (weak, nonatomic) IBOutlet RMImageView *leftTwoImg;
@property (weak, nonatomic) IBOutlet RMImageView *rightUpTwoImg;
@property (weak, nonatomic) IBOutlet RMImageView *rightDownTwoImg;

//类型三
@property (weak, nonatomic) IBOutlet RMImageView *threeImg;


@end
