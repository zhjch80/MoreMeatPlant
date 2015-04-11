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
#import "RMPublicModel.h"
#import "UIImageView+WebCache.h"

@interface RMPostMessageView ()
@property (nonatomic, strong) UIImageView * subView;
@property (nonatomic, assign) CGFloat subHeight;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) NSInteger postType_1;
@property (nonatomic, assign) NSInteger postType_2;
@property (nonatomic, assign) BOOL isSelectedType_1;
@property (nonatomic, assign) BOOL isSelectedType_2;

@property (nonatomic, strong) NSMutableArray * plantArrs;
@property (nonatomic, strong) NSMutableArray * subsPlantArrs;

@end

@implementation RMPostMessageView
@synthesize subView, subHeight, height, width, postType_1, postType_2, isSelectedType_1, isSelectedType_2, plantArrs, subsPlantArrs;

- (void)initWithPostMessageViewWithPlantArr:(NSArray *)plants withSubsPlant:(NSArray *)subs {
    plantArrs = [[NSMutableArray alloc] initWithArray:plants];
    subsPlantArrs = [[NSMutableArray alloc] initWithArray:subs];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:gesture];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    subHeight = 220;

    subView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, width, subHeight)];
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
    
    for (NSInteger i=0; i<[plants count]; i++) {
        RMPublicModel * model = [plants objectAtIndex:i];
        NSString * befStr = [model.label substringToIndex:2];
        NSString * aftStr = [model.label substringFromIndex:2];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
        button.frame = CGRectMake(16 + i*50, 55, 40, 40);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = FONT_1(12.0);
        button.titleLabel.numberOfLines = 2;
        [button.layer setCornerRadius:5.0f];
        button.tag = 401+i;
        [button setTitle:[NSString stringWithFormat:@"%@\n%@",befStr,aftStr] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectPostsType:) forControlEvents:UIControlEventTouchUpInside];
        [subView addSubview:button];
    }
    
    for (NSInteger i=1; i<[subs count]; i++) {
        RMPublicModel * model = [subs objectAtIndex:i];
        UIImageView * image = [[UIImageView alloc] init];
        image.userInteractionEnabled = YES;
        image.multipleTouchEnabled = YES;
        image.frame = CGRectMake(16 + (i-1)*50, 105, 40, 40);
        image.tag = 401 + 6 + i - 1;
        [image sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        image.backgroundColor = [UIColor clearColor];
        [subView addSubview:image];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(16 + (i-1)*50, 105, 40, 40);
        button.tag = 401 + 6 + i - 1;
        [button addTarget:self action:@selector(selectPostsType:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        [subView addSubview:button];
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

- (void)selectPostsType:(UIButton *)sender {
    if (sender.tag < 6+401){
        for (NSInteger i=0; i<[plantArrs count]; i++) {
            UIButton * button = (UIButton *)[subView viewWithTag:i+401];
            [button setBackgroundColor:[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1]];
        }
        [sender setBackgroundColor:[UIColor colorWithRed:0.94 green:0 blue:0.32 alpha:1]];
        postType_1 = sender.tag;/*401--406*/
        isSelectedType_1 = YES;
    }else{
        for (NSInteger i=1; i<[subsPlantArrs count]; i++){
            RMPublicModel * model = [subsPlantArrs objectAtIndex:i];
            UIImageView * image = (UIImageView *)[subView viewWithTag:i-1 + 6+401];
            [image sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        }

        RMPublicModel * model = [subsPlantArrs objectAtIndex:sender.tag-6-401 + 1];
        UIImageView * image = (UIImageView *)[subView viewWithTag:sender.tag];
        [image sd_setImageWithURL:[NSURL URLWithString:model.change_img] placeholderImage:nil];
        postType_2 = sender.tag;/*407--412*/
        isSelectedType_2 = YES;
    }
}

/**
 *      发帖
 */
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
    [UIView animateWithDuration:0.35 animations:^{
        self.subView.frame = CGRectMake(0, 64, width, subHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.35 animations:^{
        self.subView.frame = CGRectMake(0, 64, width, subHeight);
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}

@end
