//
//  RMPlantTypeView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/17.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantTypeView.h"
#import "RMImageView.h"
#import "CONST.h"
#import "RMPublicModel.h"
#import "UIImageView+WebCache.h"

@interface RMPlantTypeView (){
    NSInteger currentType;
    NSInteger counts;
    CGFloat kHeightY;
    CGFloat kWidthOffset;
    CGFloat kHeightOffset;
    CGFloat kHeightChangeOffset;
    CGFloat kHeightNormalOffset;
    
}
@property (nonatomic, strong) NSMutableArray * imagesArr;
@end

@implementation RMPlantTypeView
@synthesize imagesArr;

- (void)loadPlantTypeWithImageArr:(NSArray *)imageArr {
    self.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    counts = [imageArr count];
    
    if (IS_IPHONE_6p_SCREEN){
        kWidthOffset = 0.0;
        kHeightY = 0.0;
        kHeightOffset = 0.0;
        kHeightChangeOffset = 0.0;
        kHeightNormalOffset = 0.0;
    }else if (IS_IPHONE_6_SCREEN){
        kWidthOffset = 8.0;
        kHeightOffset = 4.0;
        kHeightY = 3.0;
        kHeightChangeOffset = 0.0;
        kHeightNormalOffset = 0.0;
    }else{
        kWidthOffset = 0.0;
        kHeightOffset = 0.0;
        kHeightY = 0.0;
        kHeightChangeOffset = 0.0;
        kHeightNormalOffset = 0.0;
    }
    
    imagesArr = [[NSMutableArray alloc] initWithArray:imageArr];;
    /* 保存的值 model.auto_code model.auto_id model.change_img model.content_img model.modules_name*/
    
    for (NSInteger i=0; i<counts; i++) {
        RMImageView * rmImg = [[RMImageView alloc] init];
        RMPublicModel * model = [imagesArr objectAtIndex:i];
        
        rmImg.tag = 400+i;
        rmImg.identifierString = [NSString stringWithFormat:@"%ld",(long)i];
        if (i==0){
            rmImg.frame = CGRectMake(i*(width/counts), 5 + kHeightY, 44+kWidthOffset, 49 + kHeightOffset);
            rmImg.image = [UIImage imageNamed:@"img_tzArrowed_1"];
//            [rmImg sd_setImageWithURL:[NSURL URLWithString:model.change_img] placeholderImage:nil];
        }else{
            rmImg.frame = CGRectMake(i*(width/counts), 5 + kHeightY, 44+kWidthOffset, 44 + kHeightOffset);
            [rmImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        }
        [rmImg addTarget:self withSelector:@selector(selectedPlantType:)];
        [self addSubview:rmImg];
    }
    currentType = 0;
}

- (void)selectedPlantType:(RMImageView *)image {
    if (currentType == image.identifierString.integerValue){
        NSLog(@"选择的是当前!");
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(selectedPlantWithType:)]){
        [self.delegate selectedPlantWithType:image.identifierString];
        currentType = image.identifierString.integerValue;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        for (NSInteger i=0; i<counts; i++){
            RMImageView * img = (RMImageView *)[self viewWithTag:400 + i];
            RMPublicModel * model = [imagesArr objectAtIndex:i];

            img.frame = CGRectMake(i*(width/counts), 5 + kHeightY, 44+kWidthOffset, 44 + kHeightOffset);
            if (img.identifierString.integerValue == currentType){
                if (i==0){
                    img.image = [UIImage imageNamed:@"img_tzArrowed_1"];
                }else{
                    [img sd_setImageWithURL:[NSURL URLWithString:model.change_img] placeholderImage:nil];
                }
                CGFloat x = img.frame.origin.x;
                CGFloat y = img.frame.origin.y;
                CGFloat width = img.frame.size.width;
                CGFloat height = img.frame.size.height;
                image.frame = CGRectMake(x, y, width, height + 5);
            }else{
                if (i==0){
                    img.image = [UIImage imageNamed:@"img_tzArrow_1"];
                }else{
                    [img sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
                }
            }
        }
    }
}

/**
 更新选择状态
 */
- (void)updataSelectState:(NSInteger)value {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    for (NSInteger i=0; i<counts; i++){
        RMImageView * img = (RMImageView *)[self viewWithTag:400 + i];
        RMPublicModel * model = [imagesArr objectAtIndex:i];
        
        img.frame = CGRectMake(i*(width/counts), 5 + kHeightY, 44+kWidthOffset, 44 + kHeightOffset);
        
        if (value == i){
            if (i==0){
                img.image = [UIImage imageNamed:@"img_tzArrowed_1"];
            }else{
                [img sd_setImageWithURL:[NSURL URLWithString:model.change_img] placeholderImage:nil];
            }
            CGFloat x = img.frame.origin.x;
            CGFloat y = img.frame.origin.y;
            CGFloat width = img.frame.size.width;
            CGFloat height = img.frame.size.height;
            img.frame = CGRectMake(x, y, width, height + 5);
        }else{
            if (i==0){
                img.image = [UIImage imageNamed:@"img_tzArrow_1"];
            }else{
                [img sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
            }
        }
    }
    currentType = value;
}

@end
