//
//  RMPostClassificationView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPostClassificationView.h"
#import <QuartzCore/QuartzCore.h>
#import "CONST.h"
#import "RMPublicModel.h"
#import "UIImageView+WebCache.h"

@interface RMPostClassificationView (){
    CGFloat kHeightX;
    CGFloat kHeightY;

    CGFloat kMarginWidth;

    BOOL isPlantclassification;     //分类
    BOOL isPlantSubjects;           //科目

}
@property (nonatomic, strong) UIImageView * subView;
@property (nonatomic, assign) CGFloat subHeight;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) NSMutableArray * globPlantArr;
@property (nonatomic, strong) NSMutableArray * globSubsPlantArr;

@property (nonatomic, assign) NSInteger value_1;     //植物分类
@property (nonatomic, assign) NSInteger value_2;     //植物科目

@end

@implementation RMPostClassificationView
@synthesize subView, subHeight, height, width, globPlantArr, globSubsPlantArr, value_1, value_2;

- (void)initWithPostClassificationViewWithPlantArr:(NSArray *)plants withSubsPlant:(NSMutableArray *)subs {
    globPlantArr = [[NSMutableArray alloc] initWithArray:plants];
    globSubsPlantArr = [[NSMutableArray alloc] initWithArray:subs];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:gesture];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    subHeight = 240;
    
    subView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, width, subHeight)];
    subView.userInteractionEnabled = YES;
    subView.multipleTouchEnabled = YES;
    [self addSubview:self.subView];
    
    if (IS_IPHONE_6p_SCREEN){
        kHeightX = 2.0;
        kMarginWidth = 10;
    }else if (IS_IPHONE_6_SCREEN){
        kHeightX = 1.5;
        kMarginWidth = 5;
    }else{
        kHeightX = 1.5;
        kMarginWidth = 0;
    }
    
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
    title.text = @"分类";
    title.textColor = [UIColor colorWithRed:0.91 green:0.12 blue:0.37 alpha:1];
    [subView addSubview:title];
    
    for (NSInteger i=0; i<[plants count]; i++) {
        RMPublicModel * model = [plants objectAtIndex:i];
        NSString * befStr = [model.label substringToIndex:2];
        NSString * aftStr = [model.label substringFromIndex:2];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
        button.frame = CGRectMake(16 + i*((width - 32)/[plants count] + kHeightX), 55, 44 + kMarginWidth, 44 + kMarginWidth);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = FONT_1(12.0);
        button.titleLabel.numberOfLines = 2;
        [button.layer setCornerRadius:5.0f];
        if (i==0){
            button.tag = 601;
        }else{
            button.tag = i;
        }
        [button setTitle:[NSString stringWithFormat:@"%@\n%@",befStr,aftStr] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectUpdataListType:) forControlEvents:UIControlEventTouchUpInside];
        [subView addSubview:button];
    }

    for (NSInteger i=1; i<[subs count]; i++) {
        RMPublicModel * model = [subs objectAtIndex:i];
        UIImageView * image = [[UIImageView alloc] init];
        image.userInteractionEnabled = YES;
        image.multipleTouchEnabled = YES;
        image.frame = CGRectMake(16 + (i-1)*((width - 32)/([subs count] - 1) + kHeightX), 120, 44 + kMarginWidth, 44 + kMarginWidth);
        image.tag = 6 + i;
        [image sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        image.backgroundColor = [UIColor clearColor];
        [subView addSubview:image];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(16 + (i-1)*((width - 32)/([subs count] - 1) + kHeightX), 120, 44 + kMarginWidth, 44 + kMarginWidth);
        button.tag = 6 + i;
        [button addTarget:self action:@selector(selectUpdataListType:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        [subView addSubview:button];
    }
    
    UIButton * refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(0, 0, 100, 30);
    refreshBtn.center = CGPointMake(width/2, 200);
    refreshBtn.backgroundColor = [UIColor colorWithRed:0.94 green:0 blue:0.32 alpha:1];
    [refreshBtn.layer setCornerRadius:8.0];
    [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshCurrentCtl) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:refreshBtn];
}

- (void)refreshCurrentCtl {
    if (isPlantSubjects && isPlantclassification){
        [self dismiss];
        if ([self.delegate respondsToSelector:@selector(selectedPlantType:withType:)]){
            [self.delegate selectedPlantType:value_1 withType:value_2];
        }
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择完整" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
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

- (void)selectUpdataListType:(UIButton *)sender {
    NSInteger value_tag = sender.tag;
    if (value_tag == 601){
        for (NSInteger i=0; i<[globPlantArr count]; i++) {
            if (i==0){
                UIButton * button = (UIButton *)[subView viewWithTag:601];
                button.backgroundColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
            }else{
                UIButton * button = (UIButton *)[subView viewWithTag:i];
                button.backgroundColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
            }
        }
        
        sender.backgroundColor = [UIColor colorWithRed:0.95 green:0 blue:0.32 alpha:1];
        isPlantclassification = YES;
        value_1 = 0;
    }else{
        if (sender.tag < 5){
            for (NSInteger i=0; i<[globPlantArr count]; i++) {
                if (i==0){
                    UIButton * button = (UIButton *)[subView viewWithTag:601];
                    button.backgroundColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
                }else{
                    UIButton * button = (UIButton *)[subView viewWithTag:i];
                    button.backgroundColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
                }
            }
            
            sender.backgroundColor = [UIColor colorWithRed:0.95 green:0 blue:0.32 alpha:1];
            
            isPlantclassification = YES;
            value_1 = sender.tag;
        }else{
            for (NSInteger i=1; i<[globSubsPlantArr count]; i++) {
                RMPublicModel * model = [globSubsPlantArr objectAtIndex:i];
                UIImageView * imageView = (UIImageView *)[subView viewWithTag:i + 6];
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
            }
            
            for (NSInteger i=1; i<[globPlantArr count]; i++) {
                UIImageView * imageView = (UIImageView *)[subView viewWithTag:i + 6];
                imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 44 + kMarginWidth, 44 + kMarginWidth);
            }
            
            UIImageView * imageView = (UIImageView *)[subView viewWithTag:sender.tag];
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height + 5);
            RMPublicModel * model = [globSubsPlantArr objectAtIndex:sender.tag-6];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.change_img] placeholderImage:nil];
            isPlantSubjects = YES;
            value_2 = sender.tag;
        }
    }
}

/**
 *  更新食物科目选择状态
 */
- (void)updataPlantClassificationSelectStateWith:(NSInteger)value {
    if (value == -100){
        for (NSInteger i=1; i<[globSubsPlantArr count]; i++) {
            RMPublicModel * model = [globSubsPlantArr objectAtIndex:i];
            UIImageView * imageView = (UIImageView *)[subView viewWithTag:i + 6];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        }
    }else{
        for (NSInteger i=1; i<[globSubsPlantArr count]; i++) {
            RMPublicModel * model = [globSubsPlantArr objectAtIndex:i];
            UIImageView * imageView = (UIImageView *)[subView viewWithTag:i+6];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        }
        
        for (NSInteger i=1; i<[globPlantArr count]; i++) {
            UIImageView * imageView = (UIImageView *)[subView viewWithTag:i + 6];
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 44 + kMarginWidth, 44 + kMarginWidth);
        }
        
        UIImageView * imageView = (UIImageView *)[subView viewWithTag:value+6];
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height + 5);
        RMPublicModel * model = [globSubsPlantArr objectAtIndex:value];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.change_img] placeholderImage:nil];
    }
}

@end
