//
//  RMPublishClassTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PublishClassAdded) (void);
@interface RMPublishClassTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *classtitleL;
@property (weak, nonatomic) IBOutlet UIButton *addClassBtn;
@property (retain, nonatomic) NSMutableArray * titles;
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) NSInteger index;
- (void)createItem:(NSArray *)array andCallBack:(PublishClassAdded) block;
@end
