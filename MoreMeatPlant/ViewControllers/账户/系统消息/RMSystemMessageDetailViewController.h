//
//  RMSystemMessageDetailViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/1.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMSystemMessageDetailViewController : RMBaseViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIWebView *mwebView;
@property (retain, nonatomic) NSString * auto_id;

@end
