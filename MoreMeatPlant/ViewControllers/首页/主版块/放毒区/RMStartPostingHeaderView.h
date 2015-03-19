//
//  RMStartPostingHeaderView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StartPostingHeaderDelegate <NSObject>

- (void)headerNavMethodWithTag:(NSInteger)tag;

@end

@interface RMStartPostingHeaderView : UIView
@property (nonatomic, assign) id <StartPostingHeaderDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;

@end
