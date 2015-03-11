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
                            @"img_tzed_7",
                            @"img_tzed_8",
                            @"img_tzed_9",
                            @"img_tzed_10",
                            @"img_tzed_11",
                            @"img_tzed_12",
                            @"img_tzed_12", nil];
    
    plantTypeUnselectedArr = [[NSMutableArray alloc] initWithObjects:
                              @"img_tz_7",
                              @"img_tz_8",
                              @"img_tz_9",
                              @"img_tz_10",
                              @"img_tz_11",
                              @"img_tz_12",
                              @"img_tz_12", nil];
    
    for (NSInteger i=0; i<7; i++) {
        RMImageView * rmImg = [[RMImageView alloc] init];
        rmImg.tag = 400+i;
        rmImg.identifierString = [NSString stringWithFormat:@"%ld",(long)i];
        rmImg.frame = CGRectMake(4 + i*(width/7.0), 5, width/7.0 - 6, width/7.0 - 5);
        if (i==0){
            rmImg.image = LOADIMAGE([plantTypeSelectedArr objectAtIndex:i], kImageTypePNG);
        }else{
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
        for (NSInteger i=0; i<7; i++){
            RMImageView * img = (RMImageView *)[self viewWithTag:400 + i];
            if (img.identifierString.integerValue == currentType){
                img.image = LOADIMAGE([plantTypeSelectedArr objectAtIndex:i], kImageTypePNG);
            }else{
                img.image = LOADIMAGE([plantTypeUnselectedArr objectAtIndex:i], kImageTypePNG);
            }
        }
    }
}

@end
