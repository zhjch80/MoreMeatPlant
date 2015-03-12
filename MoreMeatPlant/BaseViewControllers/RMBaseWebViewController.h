//
//  RMBaseWebViewController.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMBaseViewController.h"

@interface RMBaseWebViewController : RMBaseViewController
@property (weak, nonatomic) IBOutlet UIWebView *mWebView;

- (void)loadRequestWithUrl:(NSString *)url withTitle:(NSString *)title;

@end
