//
//  AliPayViewController.h
//  BuyBuyring
//
//  Created by elongtian on 14-3-12.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "RMBaseViewController.h"
@interface RMAliPayViewController : RMBaseViewController<UIWebViewDelegate>
{
    BOOL boo;
}
@property (retain, nonatomic) IBOutlet UIWebView *mwebview;
@property (retain, nonatomic) NSString * order_id;//订单号
@property (assign, nonatomic) BOOL is_direct;//直接购买
@end
