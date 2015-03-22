//
//  RMPublishClassTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMPublishClassTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *classtitleL;
@property (weak, nonatomic) IBOutlet UIButton *addClassBtn;
@property (retain, nonatomic) NSMutableArray * titles;
@end
