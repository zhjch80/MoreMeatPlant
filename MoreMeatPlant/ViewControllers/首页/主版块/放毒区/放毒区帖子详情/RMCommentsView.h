//
//  RMCommentsView.h
//  MoreMeatPlant
//
//  Created by 郑俊超 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

typedef enum{
    kRMReleasePoisonListComment = 1,                //放毒区列表评论
    kRMReleasePoisonListReplyComment = 2,           //放毒区回复
    kRMReleasePoisonToReport = 3,                   //放毒区详情举报
    kRMReleasePoisonListReplyOrComment = 4,         //放毒区评论列表 评论或回复
    kRMDaqoAdded = 5                                //大全详情 纠正补充说明
}RequestType;

@protocol CommentsViewDelegate <NSObject>

@optional

- (void)commentMethodWithType:(NSInteger)type withError:(NSError *)error withState:(BOOL)success withObject:(id)object withImage:(RMImageView *)image;

@end

@interface RMCommentsView : UIView
@property (nonatomic, assign) id <CommentsViewDelegate>delegate;
@property (nonatomic, assign) RequestType requestType;      //请求类型
@property (nonatomic, copy) NSString * code;                //标识

@property (nonatomic, copy) NSString * review_id;           //评论帖子标识
@property (nonatomic, copy) NSString * comment_id;          //帖子标识  回复帖子的标识

//评论
@property (nonatomic, copy) NSString * commentType;

- (void)loadCommentsViewWithReceiver:(NSString *)receive withImage:(RMImageView *)image;

@end
