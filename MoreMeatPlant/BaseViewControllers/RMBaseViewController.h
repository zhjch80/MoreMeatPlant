//
//  RMBaseViewController.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CONST.h"
#import "UIButton+EnlargeEdge.h"

#import "UIViewController+ENPopUp.h"
@interface RMBaseViewController : UIViewController{
    UIButton *leftBarButton;
    UIButton *rightBarButton;
}

/**
 *  @param navigationBar    自定义的navigationBar
 *  @param statusBar        自定义的statusBar
 */
- (void)hideCustomNavigationBar:(BOOL)navigationBar withHideCustomStatusBar:(BOOL)statusBar;

/**
 *  设置custom Nav Title
 */
- (void)setCustomNavTitle:(NSString *)title;
- (void)navgationBarButtonClick:(UIBarButtonItem *)sender;
@end
