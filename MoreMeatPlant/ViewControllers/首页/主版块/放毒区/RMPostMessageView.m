//
//  RMPostMessageView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPostMessageView.h"
#import "RMImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "CONST.h"

@interface RMPostMessageView ()
@property (nonatomic, strong) UIImageView * subView;
@property (nonatomic, assign) CGFloat subHeight;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) NSInteger postType_1;
@property (nonatomic, assign) NSInteger postType_2;
@property (nonatomic, assign) BOOL isSelectedType_1;
@property (nonatomic, assign) BOOL isSelectedType_2;

@property (nonatomic, strong) NSArray * tzTypeArr;
@property (nonatomic, strong) NSArray * tzTypeedArr;

@end

@implementation RMPostMessageView
@synthesize subView, subHeight, height, width, postType_1, postType_2, isSelectedType_1, isSelectedType_2, tzTypeArr, tzTypeedArr;

- (void)initWithPostMessageView {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:gesture];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    subHeight = 220;
    
    tzTypeArr = [NSArray arrayWithObjects:
                           @"img_tz_1",
                           @"img_tz_2",
                           @"img_tz_3",
                           @"img_tz_4",
                           @"img_tz_5",
                           @"img_tz_6",
                           @"img_tz_7",
                           @"img_tz_8",
                           @"img_tz_9",
                           @"img_tz_10",
                           @"img_tz_11",
                           @"img_tz_12",
                           nil];
    tzTypeedArr = [NSArray arrayWithObjects:
                             @"img_tzed_1",
                             @"img_tzed_2",
                             @"img_tzed_3",
                             @"img_tzed_4",
                             @"img_tzed_5",
                             @"img_tzed_6",
                             @"img_tzed_7",
                             @"img_tzed_8",
                             @"img_tzed_9",
                             @"img_tzed_10",
                             @"img_tzed_11",
                             @"img_tzed_12",
                             nil];

    subView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -height, width, subHeight)];
    subView.userInteractionEnabled = YES;
    subView.multipleTouchEnabled = YES;
    [self addSubview:subView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1].CGColor,
                       (id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor,
                       nil];
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(0, 1);
    gradient.startPoint = startPoint;
    gradient.endPoint = endPoint;
    [subView.layer insertSublayer:gradient atIndex:0];

    UILabel * title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 10, width, 25);
    title.textAlignment = NSTextAlignmentCenter;
    title.font = FONT_1(18.0);
    title.text = @"选择发帖类别";
    title.textColor = [UIColor colorWithRed:0.91 green:0.12 blue:0.37 alpha:1];
    [subView addSubview:title];
    
    NSInteger value = 0;
    for (NSInteger i=0; i<2; i++){
        for (NSInteger j=0; j<6; j++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(16 + j*50, 55 + i*50, 40, 40);
            [button setBackgroundImage:LOADIMAGE([tzTypeArr objectAtIndex:value], kImageTypePNG) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            button.tag = 401 + value;
            [button addTarget:self action:@selector(selectPostType:) forControlEvents:UIControlEventTouchUpInside];
            [subView addSubview:button];
            value ++;
        }
    }
    
    UIButton * postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.frame = CGRectMake(0, 0, 100, 30);
    postBtn.center = CGPointMake(width/2, 180);
    postBtn.backgroundColor = [UIColor colorWithRed:0.94 green:0 blue:0.32 alpha:1];
    [postBtn.layer setCornerRadius:8.0];
    [postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [postBtn setTitle:@"开始发帖" forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(selectedPostPlantType) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:postBtn];
}

- (void)selectPostType:(UIButton *)sender {
    if (sender.tag < 407){
        for (NSInteger i=0; i<6; i++) {
            UIButton * button = (UIButton *)[subView viewWithTag:401+i];
            [button setBackgroundImage:LOADIMAGE([tzTypeArr objectAtIndex:i], kImageTypePNG) forState:UIControlStateNormal];
        }
        postType_1 = sender.tag;
        isSelectedType_1 = YES;
    }else{
        for (NSInteger i=6; i<11; i++) {
            UIButton * button = (UIButton *)[subView viewWithTag:401+i];
            [button setBackgroundImage:LOADIMAGE([tzTypeArr objectAtIndex:i], kImageTypePNG) forState:UIControlStateNormal];
        }
        postType_2 = sender.tag;
        isSelectedType_2 = YES;
    }
    
    [sender setBackgroundImage:LOADIMAGE([tzTypeedArr objectAtIndex:sender.tag-401], kImageTypePNG) forState:UIControlStateNormal];
}

- (void)selectedPostPlantType {
    if (!isSelectedType_1){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您还没有选择发帖类型" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!isSelectedType_2){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您还没有选择植物类型" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    if ([self.delegate respondsToSelector:@selector(selectedPostMessageWithPostsType:withPlantType:)]){
        [self.delegate selectedPostMessageWithPostsType:postType_1 withPlantType:postType_2];
    }
}

- (void)show {
    self.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:0.1];
    [UIView animateWithDuration:0.2 animations:^{
        self.subView.frame = CGRectMake(0, 64, width, subHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.subView.frame = CGRectMake(0, -height, width, subHeight);
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}

@end
