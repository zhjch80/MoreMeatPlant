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
    CGFloat kWidthOffset;
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
    
    switch (counts) {
        case 6:{
            kWidthOffset = 0.0;
            kHeightChangeOffset = 0.0;
            kHeightNormalOffset = 0.0;
            break;
        }
        default:
            kWidthOffset = 10.0;
            kHeightChangeOffset = 7.0;
            kHeightNormalOffset = 12.0;
            break;
    }
    
    imagesArr = [[NSMutableArray alloc] initWithArray:imageArr];;
    /* 保存的值 model.auto_code model.auto_id model.change_img model.content_img model.modules_name*/
    
    for (NSInteger i=0; i<counts; i++) {
        RMImageView * rmImg = [[RMImageView alloc] init];
        RMPublicModel * model = [imagesArr objectAtIndex:i];
        
        rmImg.tag = 400+i;
        rmImg.identifierString = [NSString stringWithFormat:@"%ld",(long)i];
        if (i==0){
            rmImg.frame = CGRectMake(5 + i*(width/counts), 5, 44, 49);
            [rmImg sd_setImageWithURL:[NSURL URLWithString:model.change_img] placeholderImage:nil];
        }else{
            rmImg.frame = CGRectMake(5 + i*(width/counts), 5, 44, 44);
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

            img.frame = CGRectMake(4 + i*(width/counts), 5, 44, 44);
            if (img.identifierString.integerValue == currentType){
                [img sd_setImageWithURL:[NSURL URLWithString:model.change_img] placeholderImage:nil];
                CGFloat x = img.frame.origin.x;
                CGFloat y = img.frame.origin.y;
                CGFloat width = img.frame.size.width;
                CGFloat height = img.frame.size.height;
                image.frame = CGRectMake(x, y, width, height + 5);
            }else{
                [img sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
            }
        }
    }
}

@end
