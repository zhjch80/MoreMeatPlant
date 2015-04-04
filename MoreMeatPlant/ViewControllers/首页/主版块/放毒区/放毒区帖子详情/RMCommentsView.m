//
//  RMCommentsView.m
//  MoreMeatPlant
//
//  Created by 郑俊超 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMCommentsView.h"
#import "UIView+Effects.h"
#import "CONST.h"
#import <QuartzCore/QuartzCore.h>
#import "RMAFNRequestManager.h"
#import "RMUserLoginInfoManager.h"
#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

#define kCommentHeight      150.0

@interface RMCommentsView ()<UITextViewDelegate,UIAlertViewDelegate>{
    UIView * bgView;
    UITextView * commentTextView;
    UILabel * receiver;
    UIButton * sendBtn;
    BOOL isSendMessages;
}

@end

@implementation RMCommentsView

- (void)loadCommentsViewWithReceiver:(NSString *)receive {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:gesture];
    
    bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [bgView blur];
    [self addSubview:bgView];
    
    receiver = [[UILabel alloc] init];
    receiver.frame = CGRectMake(0, kScreenHeight, kScreenWidth-70, 30);
    receiver.text = receive;
    receiver.font = FONT_1(16.0);
    receiver.textColor = [UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1];
    receiver.backgroundColor = [UIColor clearColor];
    [bgView addSubview:receiver];
    
    commentTextView = [[UITextView alloc] init];
    commentTextView.font = [UIFont fontWithName:@"FZZHJW--GB1-0" size:16.0];
    commentTextView.delegate = self;
    commentTextView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    commentTextView.frame = CGRectMake(10, kScreenHeight, kScreenWidth - 20, kCommentHeight);
    [[UITextView appearance] setTintColor:[UIColor blackColor]];
    commentTextView.returnKeyType = UIReturnKeySend;
    [commentTextView.layer setCornerRadius:8.0f];
    [bgView addSubview:commentTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [commentTextView becomeFirstResponder];
}

- (void)KeyboardWillShow:(NSNotification *)noti {
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        commentTextView.frame = CGRectMake(10, kScreenHeight - size.height - kCommentHeight, kScreenWidth - 20, kCommentHeight);
        receiver.frame = CGRectMake(0, commentTextView.frame.origin.y - 35, kScreenWidth-70, 30);
        sendBtn.frame = CGRectMake(kScreenWidth-60,  commentTextView.frame.origin.y - 35, 50 , 30);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)KeyboardWillHide:(NSNotification *)noti {
    [UIView animateWithDuration:0.3 animations:^{
        commentTextView.frame = CGRectMake(10, kScreenHeight, kScreenWidth - 20, kCommentHeight);
        receiver.frame = CGRectMake(0, kScreenHeight, kScreenWidth-70, 30);
        sendBtn.frame = CGRectMake(kScreenWidth-60,  kScreenHeight, 50 , 30);
    } completion:^(BOOL finished) {
        if (isSendMessages){
            if (self.requestType == kRMReleasePoisonListComment){
                //帖子评论
                [self requestPostsComment];
            }else if (self.requestType == kRMReleasePoisonToReport){
                //放毒区详情举报
                [self requestToReport];
            }
        }else{
            NSLog(@"不发送");
        }
        [UIView animateWithDuration:0.2 animations:^{
            
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
            [self removeFromSuperview];
        }];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (commentTextView.text.length != 0){
            isSendMessages = YES;
            [textView resignFirstResponder];
        }
        return NO;
    }else{
        return YES;
    }
}

- (void)dismiss {
    if (commentTextView.text.length!=0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"放弃？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
            [self removeFromSuperview];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:{
            break;
        }
        case 1:{
            [UIView animateWithDuration:0.2 animations:^{
                
            } completion:^(BOOL finished) {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
                [self removeFromSuperview];
            }];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 发送请求

/**
 *  @method     放毒区 评论帖子
 */
- (void)requestPostsComment {
    [RMAFNRequestManager postPostsAddCommentsWithReview_id:self.code withContent_body:commentTextView.text withID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            if ([self.delegate respondsToSelector:@selector(commentFailureMethodWithType:)]){
                [self.delegate commentFailureMethodWithType:self.requestType];
            }
            return ;
        }
       
        if (success){
            if ([self.delegate respondsToSelector:@selector(commentSuccessMethodWithType:)]){
                [self.delegate commentSuccessMethodWithType:self.requestType];
            }
        }
    }];
}

/**
 *  @method     放毒区详情举报
 */
- (void)requestToReport {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [RMAFNRequestManager  postReleasePoisonDetailsToReportWithID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd wirhNote_id:self.code withNote_content:commentTextView.text callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            if ([self.delegate respondsToSelector:@selector(commentFailureMethodWithType:)]){
                [self.delegate commentFailureMethodWithType:self.requestType];
            }
            return ;
        }
        
        if (success){
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            if ([self.delegate respondsToSelector:@selector(commentSuccessMethodWithType:)]){
                [self.delegate commentSuccessMethodWithType:self.requestType];
            }
        }
        
    }];
}

@end
