//
//  RMPlantWithSaleDetailsCell.h
//  MoreMeatPlant
//
//  Created by 郑俊超 on 15/3/14.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  PlantWithSaleDetailsDelegate <NSObject>

@optional

- (void)plantWithSaleCellMethodWithTag:(NSInteger)tag;

@end

@interface RMPlantWithSaleDetailsCell : UITableViewCell
@property (nonatomic, assign) id <PlantWithSaleDetailsDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *productIntro;
@property (weak, nonatomic) IBOutlet UIImageView *lineOne;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productSubTitle;
@property (weak, nonatomic) IBOutlet UIImageView *lineTwo;
@property (weak, nonatomic) IBOutlet UILabel *plantIntro;
@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;
@property (weak, nonatomic) IBOutlet UIButton *addToCartBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactSeller;
@property (weak, nonatomic) IBOutlet UIButton *deleteNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusNumBtn;
@property (weak, nonatomic) IBOutlet UILabel *showNum;

@end
