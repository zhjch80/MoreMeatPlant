//
//  RMUpgradeSuggestViewController.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMBaseTextView.h"
#import "RMBaseTextField.h"

@interface RMUpgradeSuggestViewController : RMBaseViewController
@property (weak, nonatomic) IBOutlet RMBaseTextField *mTextField;
@property (weak, nonatomic) IBOutlet RMBaseTextView *mTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScro;

@end
