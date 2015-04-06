//
//  RMMyOrderViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMMyOrderViewController.h"
#import "RMAliPayViewController.h"
@interface RMMyOrderViewController ()

@end

@implementation RMMyOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kHideCustomTabbar" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowCustomTabbar" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    [self setCustomNavTitle:@"我的订单"];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    waitDeliveryCtl = [[RMOrderListViewController alloc]initWithNibName:@"RMOrderListViewController" bundle:nil];
    waitDeliveryCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64-40);
    waitDeliveryCtl.maintableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40);
    waitDeliveryCtl.order_type = @"unorder";
    __block RMMyOrderViewController * Self = self;
    waitDeliveryCtl.didSelectCellcallback = ^(NSIndexPath * indexpath){
        if(Self.didSelectCell_callback){
            Self.didSelectCell_callback(indexpath);
        }
    };
    [waitPayCtl requestData];
    [self.view addSubview:waitDeliveryCtl.view];
    
    waitPayCtl = [[RMOrderListViewController alloc]initWithNibName:@"RMOrderListViewController" bundle:nil];
    waitPayCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64-40);
    waitPayCtl.maintableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40);
    waitPayCtl.order_type = @"unpayorder";
    waitPayCtl.didSelectCellcallback = ^(NSIndexPath * indexpath){
        if(Self.didSelectCell_callback){
            Self.didSelectCell_callback(indexpath);
        }
    };
    waitPayCtl.gopay_callback = ^(RMPublicModel *model){
        //去付款
        RMAliPayViewController * alipay = [[RMAliPayViewController alloc]initWithNibName:@"RMAliPayViewController" bundle:nil];
        alipay.is_direct = NO;
        alipay.order_id = model.content_sn;//支付宝支付的订单号
        [Self.navigationController pushViewController:alipay animated:YES];
    };
    
    
    [waitPayCtl requestData];
    waitPayCtl.view.hidden = YES;
    [self.view addSubview:waitPayCtl.view];
    
    deliveryedCtl = [[RMOrderListViewController alloc]initWithNibName:@"RMOrderListViewController" bundle:nil];
    deliveryedCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64-40);
    deliveryedCtl.maintableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40);
    deliveryedCtl.order_type = @"onorder";
    deliveryedCtl.didSelectCellcallback = ^(NSIndexPath * indexpath){
        if(Self.didSelectCell_callback){
            Self.didSelectCell_callback(indexpath);
        }
    };
    deliveryedCtl.seeLogistics_callback = ^ (RMPublicModel * model){
        //查看物流
    };
    [deliveryedCtl requestData];
    deliveryedCtl.view.hidden = YES;
    [self.view addSubview:deliveryedCtl.view];
    
    orderDoneCtl = [[RMOrderListViewController alloc]initWithNibName:@"RMOrderListViewController" bundle:nil];
    orderDoneCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64-40);
    orderDoneCtl.maintableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40);
    orderDoneCtl.order_type = @"okorder";
    orderDoneCtl.didSelectCellcallback = ^(NSIndexPath * indexpath){
        if(Self.didSelectCell_callback){
            Self.didSelectCell_callback(indexpath);
        }
    };
    [orderDoneCtl requestData];
    orderDoneCtl.view.hidden = YES;
    [self.view addSubview:orderDoneCtl.view];
    
    
    [_waitDelivery addTarget:self action:@selector(selectOrderType:) forControlEvents:UIControlEventTouchDown];
    [_waitPay addTarget:self action:@selector(selectOrderType:) forControlEvents:UIControlEventTouchDown];
    [_deliveryed addTarget:self action:@selector(selectOrderType:) forControlEvents:UIControlEventTouchDown];
    [_orderDone addTarget:self action:@selector(selectOrderType:) forControlEvents:UIControlEventTouchDown];
    
    _waitDelivery.tag = 100;
    _waitPay.tag = 101;
    _deliveryed.tag = 102;
    _orderDone.tag  =103;
    
}
- (void)selectOrderType:(UIButton *)sender{
    
    [_waitDelivery setTitleColor:UIColorFromRGB(0xef93aa) forState:UIControlStateNormal];
    [_waitPay setTitleColor:UIColorFromRGB(0xef93aa) forState:UIControlStateNormal];
    [_deliveryed setTitleColor:UIColorFromRGB(0xef93aa) forState:UIControlStateNormal];
    [_orderDone setTitleColor:UIColorFromRGB(0xef93aa) forState:UIControlStateNormal];
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        switch (sender.tag-100) {
            case 0:
            {
                //待发货
                waitDeliveryCtl.view.hidden = NO;
                waitPayCtl.view.hidden = YES;
                deliveryedCtl.view.hidden = YES;
                orderDoneCtl.view.hidden = YES;
            }
                break;
            case 1:
            {
                //待付款
                waitDeliveryCtl.view.hidden = YES;
                waitPayCtl.view.hidden = NO;
                deliveryedCtl.view.hidden = YES;
                orderDoneCtl.view.hidden = YES;
            }
                break;
            case 2:
            {
                //已发货
                waitDeliveryCtl.view.hidden = YES;
                waitPayCtl.view.hidden = YES;
                deliveryedCtl.view.hidden = NO;
                orderDoneCtl.view.hidden = YES;
            }
                break;
            case 3:
            {
                //已完成
                waitDeliveryCtl.view.hidden = YES;
                waitPayCtl.view.hidden = YES;
                deliveryedCtl.view.hidden = YES;
                orderDoneCtl.view.hidden = NO;
            }
                break;
            default:
                break;
        }
        
    }];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    if (self.callback){
        _callback();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
