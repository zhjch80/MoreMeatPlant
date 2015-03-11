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

@end

@interface RMReleasePoisonDetailsCell : UITableViewCell
@property (nonatomic, assign) id <ReleasePoisonDetailsDelegate>delegate;

//情况一
@property (weak, nonatomic) IBOutlet UILabel *praiseCount;
@property (weak, nonatomic) IBOutlet RMImageView *addPraiseImg;

//情况二
@property (weak, nonatomic) IBOutlet RMImageView *toPromoteImg;

//情况三
@property (nonatomic, assign) CGRect cellFrame;

@property (weak, nonatomic) IBOutlet UIImageView *userHead;

@end
