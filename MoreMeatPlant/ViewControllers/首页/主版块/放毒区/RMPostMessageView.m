//
//  RMPostMessageView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPostMessageView.h"
#import "RMImageView.h"

@interface RMPostMessageView ()
@property (nonatomic, strong) UIView * subView;
@property (nonatomic, assign) CGFloat subHeight;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) NSString * postType;
@property (nonatomic, assign) BOOL isSelectedPostType;

@end

@implementation RMPostMessageView
@synthesize subView, subHeight, height, width, postType, isSelectedPostType;

- (void)initWithPostMessageView {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:gesture];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    subHeight = 180;
    
    subView = [[UIView alloc] initWithFrame:CGRectMake(0, -height, width, subHeight)];
    self.subView.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    [self addSubview:self.subView];
    
    UILabel * title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 10, width, 25);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"选择发帖类别";
    title.textColor = [UIColor colorWithRed:0.91 green:0.12 blue:0.37 alpha:1];
    [subView addSubview:title];
    
    NSInteger value = 0;
    for (NSInteger i=0; i<6; i++){
        for (NSInteger j=0; j<2; j++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(width/6.0 - 12 + i*40, 45 + j*40, 35, 35);
            button.backgroundColor = [UIColor redColor];
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"发帖类型%ld",(long)value] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectPostType:) forControlEvents:UIControlEventTouchUpInside];
            [subView addSubview:button];
            value ++;
        }
    }
    
    UIButton * postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.frame = CGRectMake(0, 0, 100, 30);
    postBtn.center = CGPointMake(width/2, 145);
    postBtn.backgroundColor = [UIColor colorWithRed:0.94 green:0 blue:0.32 alpha:1];
    [postBtn.layer setCornerRadius:8.0];
    [postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [postBtn setTitle:@"开始发帖" forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(selectedPostPlantType) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:postBtn];
}

- (void)selectPostType:(UIButton *)sender {
    postType = sender.titleLabel.text;
    isSelectedPostType = YES;
    NSLog(@"选择类型:%@",postType);
}

- (void)selectedPostPlantType {
    if (!isSelectedPostType){
        NSLog(@"还没有选择发帖类型");
        return;
    }
    if ([self.delegate respondsToSelector:@selector(selectedPostMessageWithPlantType:)]){
        [self.delegate selectedPostMessageWithPlantType:postType];
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
