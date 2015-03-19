//
//  RMTableHeadView.h
//  MoreMeatPlant
//
//  Created by 郑俊超 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

@protocol TableHeadDelegate <NSObject>

- (void)reportMethod:(UIButton *)button;

@end

@interface RMTableHeadView : UIView
@property (nonatomic, assign) id <TableHeadDelegate>delegate;

@property (weak, nonatomic) IBOutlet RMImageView *detailsPointLine;
@property (strong, nonatomic) IBOutlet UILabel *detailsTitle;
@property (strong, nonatomic) IBOutlet UILabel *detailsTime;
@property (strong, nonatomic) IBOutlet RMImageView *detailsUserHead;
@property (strong, nonatomic) IBOutlet UILabel *detailsUserNameTime;
@property (strong, nonatomic) IBOutlet UILabel *detailsLocation;
@property (weak, nonatomic) IBOutlet UIButton *detailsReportBtn;
@property (weak, nonatomic) IBOutlet UIWebView *detailsWebView;

@end
