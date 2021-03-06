//
//  RMMyOrderViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMMyOrderViewController.h"
#import "RMAliPayViewController.h"
#import "RMOrderDetailViewController.h"
#import "RMSeeLogisticsViewController.h"
@interface RMMyOrderViewController ()

@end

@implementation RMMyOrderViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kHideCustomTabbar" object:nil];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowCustomTabbar" object:nil];
//}
//
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
#pragma mark - 支付完成通知
- (void)receiveNoti:(NSNotification *)noti{
    if([noti.name isEqualToString:PaymentCompletedNotification]){
        
        [waitPayCtl requestData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:PaymentCompletedNotification object:nil];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    [self setCustomNavTitle:@"我的订单"];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    CGFloat height = self.from_memCenter? (kScreenHeight - 64 - 40 - 40):(kScreenHeight - 64-40);
    
    waitDeliveryCtl = [[RMOrderListViewController alloc]initWithNibName:@"RMOrderListViewController" bundle:nil];
    waitDeliveryCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight);
    waitDeliveryCtl.maintableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    waitDeliveryCtl.order_type = @"unorder";
    __block RMMyOrderViewController * Self = self;
    waitDeliveryCtl.didSelectCellcallback = ^(RMPublicModel * model){
        if(Self.didSelectCell_callback){
            Self.didSelectCell_callback(model);
        }else{
            [Self jumptoDetail:model];
        }
    };
    
    waitDeliveryCtl.startRequest = ^(){
        [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
    };
    waitDeliveryCtl.finishedRequest = ^(){
        [MBProgressHUD hideAllHUDsForView:Self.view animated:YES];
    };
    
    waitDeliveryCtl.goCorp_callback = ^(RMPublicModel * model){
        if(Self.goCorp_callback){
            Self.goCorp_callback(model);
        }
    };
    
    [waitDeliveryCtl requestData];
    [self.view addSubview:waitDeliveryCtl.view];
    
    waitPayCtl = [[RMOrderListViewController alloc]initWithNibName:@"RMOrderListViewController" bundle:nil];
    waitPayCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight);
    waitPayCtl.maintableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    waitPayCtl.order_type = @"unpayorder";
    waitPayCtl.didSelectCellcallback = ^(RMPublicModel *model){
        if(Self.didSelectCell_callback){
            Self.didSelectCell_callback(model);
        }else{
            [Self jumptoDetail:model];
        }
    };
    waitPayCtl.startRequest = ^(){
        [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
    };
    waitPayCtl.finishedRequest = ^(){
        [MBProgressHUD hideAllHUDsForView:Self.view animated:YES];
    };
    waitPayCtl.gopay_callback = ^(RMPublicModel *model){
        //去付款
        if(Self.gopay_callback){
            Self.gopay_callback(model);
        }else{
            //去付款
            RMAliPayViewController * alipay = [[RMAliPayViewController alloc]initWithNibName:@"RMAliPayViewController" bundle:nil];
            alipay.fromMember = YES;
            alipay.content_type = @"0";
            alipay.order_id = model.content_sn;//支付宝支付的订单号
            [Self.navigationController pushViewController:alipay animated:YES];
        }

    };
    
    
    waitPayCtl.goCorp_callback = ^(RMPublicModel * model){
        if(Self.goCorp_callback){
            Self.goCorp_callback(model);
        }
    };
    
    [waitPayCtl requestData];
    waitPayCtl.view.hidden = YES;
    [self.view addSubview:waitPayCtl.view];
    
    deliveryedCtl = [[RMOrderListViewController alloc]initWithNibName:@"RMOrderListViewController" bundle:nil];
    deliveryedCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight);
    deliveryedCtl.maintableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    deliveryedCtl.order_type = @"onorder";
    deliveryedCtl.didSelectCellcallback = ^(RMPublicModel *model){
        if(Self.didSelectCell_callback){
            Self.didSelectCell_callback(model);
        }else{
            [Self jumptoDetail:model];
        }
    };
    deliveryedCtl.startRequest = ^(){
        [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
    };
    deliveryedCtl.finishedRequest = ^(){
        [MBProgressHUD hideAllHUDsForView:Self.view animated:YES];
    };
    deliveryedCtl.seeLogistics_callback = ^ (RMPublicModel * model){
        //查看物流
        if(Self.seeLogistics_callback){
            Self.seeLogistics_callback (model);
        }else{
            //查看物流信息
            RMSeeLogisticsViewController * see = [[RMSeeLogisticsViewController alloc]initWithNibName:@"RMSeeLogisticsViewController" bundle:nil];
            see.express_name = model.express_name;
            see.express_no = model.express_no;
            [Self.navigationController pushViewController:see animated:YES];
        }
    };
    
    deliveryedCtl.goCorp_callback = ^(RMPublicModel * model){
        if(Self.goCorp_callback){
            Self.goCorp_callback(model);
        }
    };
    
    [deliveryedCtl requestData];
    deliveryedCtl.view.hidden = YES;
    [self.view addSubview:deliveryedCtl.view];
    
    orderDoneCtl = [[RMOrderListViewController alloc]initWithNibName:@"RMOrderListViewController" bundle:nil];
    orderDoneCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight);
    orderDoneCtl.maintableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    orderDoneCtl.order_type = @"okorder";
    orderDoneCtl.didSelectCellcallback = ^(RMPublicModel *model){
        if(Self.didSelectCell_callback){
            Self.didSelectCell_callback(model);
        }else{
            [Self jumptoDetail:model];
        }
    };
    orderDoneCtl.startRequest = ^(){
        [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
    };
    orderDoneCtl.finishedRequest = ^(){
        [MBProgressHUD hideAllHUDsForView:Self.view animated:YES];
    };
    orderDoneCtl.goCorp_callback = ^(RMPublicModel * model){
        if(Self.goCorp_callback){
            Self.goCorp_callback(model);
        }
    };
    
    [orderDoneCtl requestData];
    orderDoneCtl.view.hidden = YES;
    [self.view addSubview:orderDoneCtl.view];
    
//    orderReturnCtl
    orderReturnCtl = [[RMOrderListViewController alloc]initWithNibName:@"RMOrderListViewController" bundle:nil];
    orderReturnCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight);
    orderReturnCtl.maintableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    orderReturnCtl.order_type = @"returnorder";
    orderReturnCtl.didSelectCellcallback = ^(RMPublicModel *model){
        if(Self.didSelectCell_callback){
            Self.didSelectCell_callback(model);
        }else{
            [Self jumptoDetail:model];
        }
    };
    orderReturnCtl.startRequest = ^(){
        [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
    };
    orderReturnCtl.finishedRequest = ^(){
        [MBProgressHUD hideAllHUDsForView:Self.view animated:YES];
    };
    orderReturnCtl.goCorp_callback = ^(RMPublicModel * model){
        if(Self.goCorp_callback){
            Self.goCorp_callback(model);
        }
    };
    
    orderReturnCtl.seeLogistics_callback = ^ (RMPublicModel * model){
        //查看物流
        if(Self.seeLogistics_callback){
            Self.seeLogistics_callback (model);
        }else{
            //查看物流信息
            RMSeeLogisticsViewController * see = [[RMSeeLogisticsViewController alloc]initWithNibName:@"RMSeeLogisticsViewController" bundle:nil];
            see.express_name = model.express_name;
            see.express_no = model.express_no;
            [Self.navigationController pushViewController:see animated:YES];
        }
    };

    
    [orderReturnCtl requestData];
    orderReturnCtl.view.hidden = YES;
    [self.view addSubview:orderReturnCtl.view];
    
    [_waitDelivery addTarget:self action:@selector(selectOrderType:) forControlEvents:UIControlEventTouchDown];
    [_waitPay addTarget:self action:@selector(selectOrderType:) forControlEvents:UIControlEventTouchDown];
    [_deliveryed addTarget:self action:@selector(selectOrderType:) forControlEvents:UIControlEventTouchDown];
    [_orderDone addTarget:self action:@selector(selectOrderType:) forControlEvents:UIControlEventTouchDown];
    [_returned addTarget:self action:@selector(selectOrderType:) forControlEvents:UIControlEventTouchDown];
    
    _waitDelivery.tag = 100;
    _waitPay.tag = 101;
    _deliveryed.tag = 102;
    _orderDone.tag  =103;
    _returned.tag = 104;
    
}
- (void)selectOrderType:(UIButton *)sender{
    
    [_waitDelivery setTitleColor:UIColorFromRGB(0xef93aa) forState:UIControlStateNormal];
    [_waitPay setTitleColor:UIColorFromRGB(0xef93aa) forState:UIControlStateNormal];
    [_deliveryed setTitleColor:UIColorFromRGB(0xef93aa) forState:UIControlStateNormal];
    [_orderDone setTitleColor:UIColorFromRGB(0xef93aa) forState:UIControlStateNormal];
    [_returned setTitleColor:UIColorFromRGB(0xef93aa) forState:UIControlStateNormal];
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
                orderReturnCtl.view.hidden = YES;
            }
                break;
            case 1:
            {
                //待付款
                waitDeliveryCtl.view.hidden = YES;
                waitPayCtl.view.hidden = NO;
                deliveryedCtl.view.hidden = YES;
                orderDoneCtl.view.hidden = YES;
                orderReturnCtl.view.hidden = YES;
            }
                break;
            case 2:
            {
                //已发货
                waitDeliveryCtl.view.hidden = YES;
                waitPayCtl.view.hidden = YES;
                deliveryedCtl.view.hidden = NO;
                orderDoneCtl.view.hidden = YES;
                orderReturnCtl.view.hidden = YES;
            }
                break;
            case 3:
            {
                //已完成
                waitDeliveryCtl.view.hidden = YES;
                waitPayCtl.view.hidden = YES;
                deliveryedCtl.view.hidden = YES;
                orderDoneCtl.view.hidden = NO;
                orderReturnCtl.view.hidden = YES;
            }
                break;
            case 4:
            {
                //退货
                waitDeliveryCtl.view.hidden = YES;
                waitPayCtl.view.hidden = YES;
                deliveryedCtl.view.hidden = YES;
                orderDoneCtl.view.hidden = YES;
                orderReturnCtl.view.hidden = NO;
            }
                break;
            default:
                break;
        }
        
    }];
}

- (void)jumptoDetail:(RMPublicModel *)model{
    RMOrderDetailViewController * detail = [[RMOrderDetailViewController alloc]initWithNibName:@"RMOrderDetailViewController" bundle:nil];
    detail._model = [[RMPublicModel alloc]init];
    detail._model = model;
    detail.order_type = model.content_type;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    if (self.callback){
        _callback();
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
