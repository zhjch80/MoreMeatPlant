//
//  ELViewDelegate.m
//  SevenStars
//
//  Created by elongtian on 14-6-30.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import "RMShareViewDelegate.h"
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/NSString+Common.h>
@implementation RMShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    
    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        UIButton *leftBtn = (UIButton *)viewController.navigationItem.leftBarButtonItem.customView;
        UIButton *rightBtn = (UIButton *)viewController.navigationItem.rightBarButtonItem.customView;
        
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = viewController.title;
        label.font = [UIFont boldSystemFontOfSize:18];
        [label sizeToFit];
        
        viewController.navigationItem.titleView = label;
        
    }
    
    if ([UIDevice currentDevice].isPad)
    {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:22];
        viewController.navigationItem.titleView = label;
        label.text = viewController.title;
        [label sizeToFit];
        
        if (UIInterfaceOrientationIsLandscape(viewController.interfaceOrientation))
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"memberCenter_btn"]];
           // [[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"memberCenter_btn"]];
            //[[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];;
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(viewController.interfaceOrientation))
        {
            if ([[UIDevice currentDevice] isPhone5])
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"memberCenter_btn"]];
                //[[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];;
            }
            else
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"memberCenter_btn"]];
                //[[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];;
            }
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"memberCenter_btn"]];
            //[[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];;
        }
    }
}

- (void)view:(UIViewController *)viewController autorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation shareType:(ShareType)shareType
{
    if ([UIDevice currentDevice].isPad)
    {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"memberCenter_btn"]];
            //[[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];;
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"memberCenter_btn"]];
            //[[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];;
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
            if ([[UIDevice currentDevice] isPhone5])
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"memberCenter_btn"]];
               // [[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];;
            }
            else
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"memberCenter_btn"]];
               // [[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];;
            }
        }
        else
        {
           [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"memberCenter_btn"]];
            //[[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];;
        }
    }
}

@end

