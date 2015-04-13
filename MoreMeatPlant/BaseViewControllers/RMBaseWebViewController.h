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
@property (strong, nonatomic) UIWebView *mWebView;

/**
 *  @method 请求网络url 整个直接展示webView
 *  @param      url         请求的url
 *  @param      title       custom Title
 *  @param      load        是否请求网络
 */
- (void)loadRequestWithUrl:(NSString *)url
                 withTitle:(NSString *)title
         withisloadRequest:(BOOL)load;

/**
 *  @method 加载html body
 *  @param      auto_id         标识
 *  @param      load            是否请求网络
 *  @param      title           custom Title
 */
- (void)loadHtmlWithAuto_id:(NSString *)auto_id
                  withTitle:(NSString *)title
          withisloadRequest:(BOOL)load;

@end
