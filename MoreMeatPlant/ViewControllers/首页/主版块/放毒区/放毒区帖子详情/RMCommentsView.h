//
//  RMCommentsView.h
//  MoreMeatPlant
//
//  Created by 郑俊超 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentsViewDelegate <NSObject>

//- (void)method;

@end

@interface RMCommentsView : UIView
@property (nonatomic, assign) id <CommentsViewDelegate>delegate;

- (void)loadCommentsViewWithReceiver:(NSString *)receive;

@end
