//
//  RMStartLongPostingCell.h
//  MoreMeatPlant
//
//  Created by mobei on 15/4/23.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StartLongPostingDelegate <NSObject>

- (void)editingContentWithTag:(NSInteger)tag;

@end

@interface RMStartLongPostingCell : UITableViewCell
@property (nonatomic, assign) id <StartLongPostingDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *editTitleDisplay;
@property (weak, nonatomic) IBOutlet UIButton *editTitleBtn;

@end
