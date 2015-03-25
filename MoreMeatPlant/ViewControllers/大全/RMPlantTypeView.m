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

@interface RMPlantTypeView (){
    NSInteger currentType;
    NSMutableArray * plantTypeSelectedArr;
    NSMutableArray * plantTypeUnselectedArr;
}

@end


@implementation RMPlantTypeView

- (void)loadPlantType {
    self.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    plantTypeSelectedArr = [[NSMutableArray alloc] initWithObjects:
                            @"img_tzArrowed_1",
                            @"img_tzArrowed_2",
                            @"img_tzArrowed_3",
                            @"img_tzArrowed_4",
                            @"img_tzArrowed_5",
                            @"img_tzArrowed_6",
                            @"img_tzArrowed_7", nil];
    
    plantTypeUnselectedArr = [[NSMutableArray alloc] initWithObjects:
                              @"img_tzArrow_1",
                              @"img_tzArrow_2",
                              @"img_tzArrow_3",
                              @"img_tzArrow_4",
                              @"img_tzArrow_5",
                              @"img_tzArrow_6",
                              @"img_tzArrow_7", nil];
    
    for (NSInteger i=0; i<7; i++) {
        RMImageView * rmImg = [[RMImageView alloc] init];
        rmImg.tag = 400+i;
        rmImg.identifierString = [NSString stringWithFormat:@"%ld",(long)i];
        if (i==0){
            rmImg.frame = CGRectMake(4 + i*(width/7.0), 5, width/7.0 - 6, width/7.0);
            rmImg.image = LOADIMAGE([plantTypeSelectedArr objectAtIndex:i], kImageTypePNG);
        }else{
            rmImg.frame = CGRectMake(4 + i*(width/7.0), 5, width/7.0 - 6, width/7.0 - 5);
            rmImg.image = LOADIMAGE([plantTypeUnselectedArr objectAtIndex:i], kImageTypePNG);
        }
        [rmImg addTarget:self WithSelector:@selector(selectedPlantType:)];
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
        for (NSInteger i=0; i<7; i++){
            RMImageView * img = (RMImageView *)[self viewWithTag:400 + i];
            img.frame = CGRectMake(4 + i*(width/7.0), 5, width/7.0 - 6, width/7.0 - 5);
            if (img.identifierString.integerValue == currentType){
                img.image = LOADIMAGE([plantTypeSelectedArr objectAtIndex:i], kImageTypePNG);
                CGFloat x = img.frame.origin.x;
                CGFloat y = img.frame.origin.y;
                CGFloat width = img.frame.size.width;
                CGFloat height = img.frame.size.height;
                image.frame = CGRectMake(x, y, width, height + 5);
            }else{
                img.image = LOADIMAGE([plantTypeUnselectedArr objectAtIndex:i], kImageTypePNG);
            }
        }
    }
}

@end
