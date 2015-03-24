//
//  RMDaqoDetailsFooterView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/24.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMDaqoDetailsFooterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *chineseName;
@property (weak, nonatomic) IBOutlet UILabel *englishName;
@property (weak, nonatomic) IBOutlet UILabel *intro;

@property (weak, nonatomic) IBOutlet UIImageView *lineOne;
@property (weak, nonatomic) IBOutlet UIImageView *lineTwo;

//图集
@property (weak, nonatomic) IBOutlet UILabel *atlas;

//种植
@property (weak, nonatomic) IBOutlet UILabel *planting;
@property (weak, nonatomic) IBOutlet UIImageView *planting_1;
@property (weak, nonatomic) IBOutlet UIImageView *planting_2;
@property (weak, nonatomic) IBOutlet UIImageView *planting_3;
@property (weak, nonatomic) IBOutlet UIImageView *planting_4;
@property (weak, nonatomic) IBOutlet UIImageView *planting_5;
@property (weak, nonatomic) IBOutlet UIImageView *planting_6;
@property (weak, nonatomic) IBOutlet UIImageView *planting_7;
@property (weak, nonatomic) IBOutlet UIImageView *planting_8;
@property (weak, nonatomic) IBOutlet UIImageView *planting_9;
@property (weak, nonatomic) IBOutlet UIImageView *planting_10;

@property (weak, nonatomic) IBOutlet UIImageView *lineThree;
@property (weak, nonatomic) IBOutlet UIImageView *lineFour;

//繁殖
@property (weak, nonatomic) IBOutlet UILabel *breeding;
@property (weak, nonatomic) IBOutlet UILabel *breedingContent;


@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *addedAndCorrectedBtn;

@end
