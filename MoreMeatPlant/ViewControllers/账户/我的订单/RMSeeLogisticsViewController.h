//
//  RMSeeLogisticsViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/6.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMSeeLogisticsViewController : RMBaseViewController
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (retain, nonatomic) NSString * express_no;//快递单号
@property (retain, nonatomic) NSString * express_name;//快递名称
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewWidth;
@end
