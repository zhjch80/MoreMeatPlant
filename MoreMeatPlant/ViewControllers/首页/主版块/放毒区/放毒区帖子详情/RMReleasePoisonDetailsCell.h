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

- (void)reportMethod:(UIButton *)button;

- (void)jumpPromoteMethod:(RMImageView *)image;

- (void)addPraiseMethod:(RMImageView *)image;

- (void)userHeadMethod:(RMImageView *)image;

@end

@interface RMReleasePoisonDetailsCell : UITableViewCell
@property (nonatomic, assign) id <ReleasePoisonDetailsDelegate>delegate;

//情况零
@property (strong, nonatomic) IBOutlet UILabel *detailsTitle;
@property (strong, nonatomic) IBOutlet UILabel *detailsTime;
@property (strong, nonatomic) IBOutlet UIImageView *detailsUserHead;
@property (strong, nonatomic) IBOutlet UILabel *detailsUserNameTime;
@property (strong, nonatomic) IBOutlet UILabel *detailsLocation;
@property (weak, nonatomic) IBOutlet UIWebView *mWebView;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;


//情况一
@property (weak, nonatomic) IBOutlet UILabel *praiseCount;
@property (weak, nonatomic) IBOutlet RMImageView *addPraiseImg;

//情况二
@property (weak, nonatomic) IBOutlet RMImageView *toPromoteImg;

//情况三
@property (nonatomic, assign) CGRect cellFrame;

@property (weak, nonatomic) IBOutlet RMImageView *userHead;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userLocatiom;
@property (strong, nonatomic) IBOutlet UILabel *userPostTime;
@property (strong, nonatomic) IBOutlet UILabel *userPostName;

@end
