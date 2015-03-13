//
//  RMStartPostingViewController.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMBaseTextField.h"
#import "RMBaseTextView.h"

@interface RMStartPostingViewController : RMBaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet RMBaseTextField *mTextField;
@property (weak, nonatomic) IBOutlet RMBaseTextView *mTextView;

@end
