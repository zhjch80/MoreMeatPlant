//
//  RMFreshManCourseOfStudyViewController.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMFreshManCourseOfStudyViewController : RMBaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *mWebView;

- (void)loadRequestWithUrl:(NSString *)url withTitle:(NSString *)title;

@end
