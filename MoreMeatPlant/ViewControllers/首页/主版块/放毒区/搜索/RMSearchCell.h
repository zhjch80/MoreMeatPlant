//
//  RMSearchCell.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>

@optional

- (void)method;

@end

@interface RMSearchCell : UITableViewCell
@property (nonatomic, assign) id <SearchDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;

@end
