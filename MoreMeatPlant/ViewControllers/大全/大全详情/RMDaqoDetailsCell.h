//
//  RMDaqoDetailsCell.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/21.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DaqoDetailsDelegate <NSObject>

@optional

- (void)daqoqMethodWithTag:(NSInteger)tag;

@end

@interface RMDaqoDetailsCell : UITableViewCell
@property (nonatomic, assign) id<DaqoDetailsDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *backupBtn;
@property (weak, nonatomic) IBOutlet UILabel *plantName;



@end
