//
//  RMHadBabyViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMHadBabyViewController.h"
#import "RMSeeLogisticsViewController.h"

@interface RMHadBabyViewController ()

@end

@implementation RMHadBabyViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kHideCustomTabbar" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowCustomTabbar" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor = [UIColor clearColor];
    [self setCustomNavTitle:@"已出宝贝"];
    
    __weak RMHadBabyViewController * Self = self;
    
    waitDeliveryCtl = [[RMHadBabyListViewController alloc]initWithNibName:@"RMHadBabyListViewController" bundle:nil];
    waitDeliveryCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64  - 40);
    waitDeliveryCtl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64  - 40);
    waitDeliveryCtl.call_back = ^(){
        if(Self.callback){
            Self.callback();
        }
    };
    waitDeliveryCtl.order_type = @"unorder";
    [waitDeliveryCtl requestData];
    [self.view addSubview:waitDeliveryCtl.view];
    
    waitPayCtl = [[RMHadBabyListViewController alloc]initWithNibName:@"RMHadBabyListViewController" bundle:nil];
    waitPayCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64-40);
    waitPayCtl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40);
    waitPayCtl.order_type = @"unpayorder";
    [waitPayCtl requestData];
    waitPayCtl.view.hidden = YES;
    [self.view addSubview:waitPayCtl.view];
    
    deliveryedCtl = [[RMHadBabyListViewController alloc]initWithNibName:@"RMHadBabyListViewController" bundle:nil];
    deliveryedCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64-40);
    deliveryedCtl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40);
    deliveryedCtl.order_type = @"onorder";
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
    
    deliveryedCtl.call_back = ^(){
        if(Self.callback){
            Self.callback();
        }
    };
    [deliveryedCtl requestData];
    deliveryedCtl.view.hidden = YES;
    [self.view addSubview:deliveryedCtl.view];
    
    orderDoneCtl = [[RMHadBabyListViewController alloc]initWithNibName:@"RMHadBabyListViewController" bundle:nil];
    orderDoneCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64-40);
    orderDoneCtl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40);
    orderDoneCtl.order_type = @"okorder";

    [orderDoneCtl requestData];
    orderDoneCtl.view.hidden = YES;
    [self.view addSubview:orderDoneCtl.view];
    
    orderReturnCtl = [[RMHadBabyListViewController alloc]initWithNibName:@"RMHadBabyListViewController" bundle:nil];
    orderReturnCtl.view.frame = CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64-40);
    orderReturnCtl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40);
    orderReturnCtl.order_type = @"returnorder";
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
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
}

#pragma mark - 
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


- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    if(self.callback){
        _callback();
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
