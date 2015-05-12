//
//  RMPublishCourseTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/4.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RMPublishCourseTableViewCellDelegate <NSObject>
- (void)RMPublishCourseTableViewCellDidSelectCourse:(UIButton *)sender;
@end

@interface RMPublishCourseTableViewCell : UITableViewCell
@property (retain, nonatomic) NSMutableArray * titles;
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) id <RMPublishCourseTableViewCellDelegate>delegate;
- (void)createItem:(NSArray *)array;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_line;
@end
