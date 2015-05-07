//
//  RMFoundationViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/5/7.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RMFoundationViewCtlRequestStart)(void);
typedef void (^RMFoundationViewCtlRequestFinished)(void);
@interface RMFoundationViewController : UIViewController
@property (copy, nonatomic) RMFoundationViewCtlRequestStart startRequest;
@property (copy, nonatomic) RMFoundationViewCtlRequestFinished finishedRequest;

@end
