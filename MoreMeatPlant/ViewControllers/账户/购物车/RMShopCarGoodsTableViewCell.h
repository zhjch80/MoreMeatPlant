//
//  RMShopCarGoodsTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/9.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMShopCarGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *content_imgV;
@property (weak, nonatomic) IBOutlet UILabel *content_titleL;
@property (weak, nonatomic) IBOutlet UILabel *content_priceL;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_line;

@end
