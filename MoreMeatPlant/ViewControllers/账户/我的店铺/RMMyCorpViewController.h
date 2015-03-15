//
//  RMMyCorpViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMPlantWithSaleCell.h"
@interface RMMyCorpViewController : RMBaseViewController<UITableViewDelegate,UITableViewDataSource,JumpPlantDetailsDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bannerImgV;
@property (weak, nonatomic) IBOutlet UIImageView *corp_headImgV;
@property (weak, nonatomic) IBOutlet UILabel *corp_nameL;
@property (weak, nonatomic) IBOutlet UILabel *signatureL;
@property (weak, nonatomic) IBOutlet UILabel *corp_regionL;
@property (weak, nonatomic) IBOutlet UIButton *corp_level;
@property (weak, nonatomic) IBOutlet UIButton *corp_renzheng;
@property (weak, nonatomic) IBOutlet UIButton *corp_sun;
@property (weak, nonatomic) IBOutlet UIButton *collection;
@property (weak, nonatomic) IBOutlet UIView *headbackView;
@property (weak, nonatomic) IBOutlet UIView *classesView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableview;

@end
