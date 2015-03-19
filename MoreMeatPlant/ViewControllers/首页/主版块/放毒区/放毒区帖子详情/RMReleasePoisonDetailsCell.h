//
//  RMReleasePoisonDetailsCell.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/11.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

@protocol ReleasePoisonDetailsDelegate <NSObject>

@optional

- (void)jumpPromoteMethod:(RMImageView *)image;

- (void)addPraiseMethod:(RMImageView *)image;

- (void)userHeadMethod:(RMImageView *)image;

- (void)replyMethod:(UIButton *)button;

@end

@interface RMReleasePoisonDetailsCell : UITableViewCell
@property (nonatomic, assign) id <ReleasePoisonDetailsDelegate>delegate;
@property (nonatomic, assign) CGRect cellFrame;

//情况一
@property (weak, nonatomic) IBOutlet UILabel *praiseCount;
@property (weak, nonatomic) IBOutlet RMImageView *addPraiseImg;

//情况二
@property (weak, nonatomic) IBOutlet RMImageView *toPromoteImg;

//情况三
@property (weak, nonatomic) IBOutlet RMImageView *userHead_1;
@property (strong, nonatomic) IBOutlet UILabel *userName_1;
@property (strong, nonatomic) IBOutlet UILabel *userLocatiom_1;
@property (strong, nonatomic) IBOutlet UILabel *userPostTime_1;
@property (weak, nonatomic) IBOutlet UIImageView *pointLine_1;
@property (weak, nonatomic) IBOutlet UILabel *comments_1;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn_1;
@property (weak, nonatomic) IBOutlet UIView *line_1;

//情况四
@property (weak, nonatomic) IBOutlet RMImageView *userHead_2;
@property (weak, nonatomic) IBOutlet UILabel *userName_2;
@property (weak, nonatomic) IBOutlet UILabel *userLocatiom_2;
@property (weak, nonatomic) IBOutlet UILabel *userPostTime_2;
@property (weak, nonatomic) IBOutlet UIImageView *pointLine_2;
@property (weak, nonatomic) IBOutlet UIView *comments_2_1_bgView;
@property (weak, nonatomic) IBOutlet UILabel *comments_2_1;
@property (weak, nonatomic) IBOutlet UILabel *comments_2_2;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn_2;
@property (weak, nonatomic) IBOutlet UIView *line_2;


@end
