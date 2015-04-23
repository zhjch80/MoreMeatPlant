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
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+ENPopUp.h"
#import "RMAFNRequestManager.h"
#import "UIImageView+WebCache.h"
#import "RMPublicModel.h"
#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "RMUserLoginInfoManager.h"
#import "RefreshControl.h"
#import "RefreshView.h"
#import "UIImageView+WebCache.h"
#import "KeyboardManager.h"
#import "UtilityFunc.h"
#import "STDbHandle.h"

@interface RMBaseViewController : UIViewController{
    UIButton *leftBarButton;
    UIButton *rightOneBarButton;
    UIButton *rightTwoBarButton;
    IQKeyboardReturnKeyHandler *returnKeyHandler;

}

/**
 *  @param navigationBar    自定义的navigationBar
 *  @param statusBar        自定义的statusBar
 */
- (void)setHideCustomNavigationBar:(BOOL)navigationBar withHideCustomStatusBar:(BOOL)statusBar;

/**
 *  @param navColor             自定义的CustomNav的背景色
 *  @param statusColor          自定义的StatusView的背景色
 */
- (void)setCustomNavBackgroundColor:(UIColor *)navColor withStatusViewBackgroundColor:(UIColor *)statusColor;

/**
 *  @param  number          设置右边barbutton的数量 最多两个
 */
- (void)setRightBarButtonNumber:(NSInteger)number;

/**
 *  设置custom Nav Title
 */
- (void)setCustomNavTitle:(NSString *)title;
- (void)navgationBarButtonClick:(UIBarButtonItem *)sender;
@end
