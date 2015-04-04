//
//  RMCommentsView.h
//  MoreMeatPlant
//
//  Created by 郑俊超 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kRMReleasePoisonListComment = 1,                //放毒区列表评论
    kRMReleasePoisonListReplyComment = 2,           //放毒区回复
    kRMReleasePoisonToReport = 3                    //放毒区详情举报
}RequestType;

@protocol CommentsViewDelegate <NSObject>

@optional

- (void)commentSuccessMethodWithType:(NSInteger)type;

- (void)commentFailureMethodWithType:(NSInteger)type;

@end

@interface RMCommentsView : UIView
@property (nonatomic, assign) id <CommentsViewDelegate>delegate;
@property (nonatomic, assign) RequestType requestType;      //请求类型
@property (nonatomic, copy) NSString * code;                //标识

- (void)loadCommentsViewWithReceiver:(NSString *)receive;

@end
