//
//  RMPlantTypeView.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/17.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantTypeView.h"
#import "RMImageView.h"

@implementation RMPlantTypeView

- (void)loadPlantType {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    for (NSInteger i=0; i<7; i++) {
        RMImageView * rmImg = [[RMImageView alloc] init];
        rmImg.identifierString = [NSString stringWithFormat:@"%ld",(long)i];
        rmImg.frame = CGRectMake(0 + i*(width/7.0), 0, width/7.0, width/7.0);
        rmImg.backgroundColor = (i%2==0 ? [UIColor redColor] : [UIColor orangeColor]);
        [rmImg addTarget:self WithSelector:@selector(selectedPlantType:)];
        [self addSubview:rmImg];
    }
}

- (void)selectedPlantType:(RMImageView *)image {
    if ([self.delegate respondsToSelector:@selector(selectedPlantWithType:)]){
        [self.delegate selectedPlantWithType:image.identifierString];
    }
}

@end
