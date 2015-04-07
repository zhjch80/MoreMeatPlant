//
//  AliPayViewController.m
//  BuyBuyring
//
//  Created by elongtian on 14-3-12.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "RMAliPayViewController.h"
#import "RMShopCarViewController.h"
#import "RMPlantWithSaleDetailsViewController.h"
@interface RMAliPayViewController ()
@end

@implementation RMAliPayViewController
@synthesize order_id;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    boo = YES;
    
    [self setCustomNavTitle:@"支付宝支付"];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];

    NSString * urlstr = [RMAFNRequestManager alipayWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] content_type:@"0" isDirectPurchase:_is_direct Order_sn:order_id content_money:nil];
    
    [_mwebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]]];
    
}
#pragma mark - UIWebviewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD showError:@"加载失败!" toView:self.view];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSRange range = [request.URL.relativeString rangeOfString:@"#pay_success"];
    if (range.location != NSNotFound) {
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        [dic setValue:@"1" forKey:@"pay_success"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaymentCompletedNotification" object:self userInfo:dic];
            
        [self animationToOrderlist];
        return NO;
    }
    return YES;
}
#pragma mark - 跳转到订单列表
- (void)animationToOrderlist
{
    
}

#pragma mark -  返回
- (void)navgationBarButtonClick:(UIBarButtonItem *)sender
{
    if(_is_direct){
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        for(UIViewController * vc in self.navigationController.viewControllers)
        {
            if([vc isKindOfClass:[RMPlantWithSaleDetailsViewController class]])
            {
                continue;
            }
            [arr addObject:vc];
            
        }
        self.navigationController.viewControllers = arr;
    }else{
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        for(UIViewController * vc in self.navigationController.viewControllers)
        {
            if([vc isKindOfClass:[RMShopCarViewController class]])
            {
                continue;
            }
            [arr addObject:vc];
            
        }
        self.navigationController.viewControllers = arr;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
