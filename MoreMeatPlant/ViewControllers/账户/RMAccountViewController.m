//
//  RMAccountViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMAccountViewController.h"
#import "RMAccountView.h"
#import "CONST.h"

#import "RMNearFriendViewController.h"
#import "RMSysMessageViewController.h"
#import "RMShopCarViewController.h"

#import "UIViewController+ENPopUp.h"
@interface RMAccountViewController ()

@end

@implementation RMAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"账户"];
    
    [self initPlat];
    
    [self layoutViews];
}

- (void)initPlat{
    _headerImgV.layer.cornerRadius = 5;
    _headerImgV.clipsToBounds = YES;
    
    functitleArray = [[NSMutableArray alloc]init];
    if(/* DISABLES CODE */ (1)){//普通会员
        functitleArray = [NSMutableArray arrayWithObjects:@"我的\n肉友",@"我的\n钱包",@"我的\n收藏",@"申请\n开店",@"我的\n订单",@"我的\n帖子",@"系统\n通知",@"等待\n升级",@"购物\n篮",@"附近\n肉友",@"我的\n资料" ,nil];
    }
    else{//商户会员
        functitleArray = [NSMutableArray arrayWithObjects:@"我的\n肉友",@"我的\n钱包",@"我的\n收藏",@"我的\n资料",@"已出\n宝贝",@"我的\n帖子",@"系统\n通知",@"附近\n肉友",@"发布\n宝贝",@"我的\n店铺",@"发布\n广告",@"等待\n升级",nil];
    }
}

- (void)layoutViews {
    int width = (kScreenWidth-15*2-3*3)/4.0;
    int height = width*(166.0/280.0);
    for(int i = 0;i<[functitleArray count];i++)
    {
        RMAccountView * acountView = [[RMAccountView alloc]initWithFrame:CGRectMake(kScreenWidth-(width+3)*(i%4)-15-width, 204+(height+3)*(i/4), width, height)];
        acountView.tag = i+100;
        acountView.titleL.text = [functitleArray objectAtIndex:i];
        acountView.call_back = ^(RMAccountView * view){
            if(/* DISABLES CODE */ (1)){//普通会员
                switch (view.tag-100) {
                    case 0:{
                        RMNearFriendViewController * near = [[RMNearFriendViewController alloc]initWithNibName:@"RMNearFriendViewController" bundle:nil];
                        [self.navigationController pushViewController:near animated:YES];
                    }
                        break;
                    case 1:{
                        
                    }
                        break;
                    case 2:{
                        
                    }
                        break;
                    case 3:{
                        
                    }
                        break;
                    case 4:{
                        
                    }
                        break;
                    case 5:{
                        
                    }
                        break;
                    case 6:{
//                        RMSysMessageViewController * message = [[RMSysMessageViewController alloc]initWithNibName:@"RMSysMessageViewController" bundle:nil];
//                        [self.navigationController pushViewController:message animated:YES];
                        RMSysMessageViewController * message = [[RMSysMessageViewController alloc]initWithNibName:@"RMSysMessageViewController" bundle:nil];
                        message.callback = ^(RMSysMessageViewController * controller){
                            [self dismissPopUpViewControllerWithcompletion:nil];
                        };
                        message.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-49);
                        [self presentPopUpViewController:message];
                    }
                        break;
                    case 7:{
                        
                    }
                        break;
                    case 8:{//购物车
                        RMShopCarViewController * shopcar = [[RMShopCarViewController alloc]initWithNibName:@"RMShopCarViewController" bundle:nil];
                        [self.navigationController pushViewController:shopcar animated:YES];
                        
                    }
                        break;
                    case 9:{
                        
                    }
                        break;
                    case 10:{
                        
                    }
                        break;
                    default:
                        break;
                }

            }else{//商家会员
                switch (view.tag-100) {
                    case 0:{
                        
                    }
                        break;
                    case 1:{
                        
                    }
                        break;
                    case 2:{
                        
                    }
                        break;
                    case 3:{
                        
                    }
                        break;
                    case 4:{
                        
                    }
                        break;
                    case 5:{
                        
                    }
                        break;
                    case 6:{
                        
                    }
                        break;
                    case 7:{
                        
                    }
                        break;
                    case 8:{
                        
                    }
                        break;
                    case 9:{
                        
                    }
                        break;
                    case 10:{
                        
                    }
                        break;
                    case 11:{
                        
                    }
                        break;
                    default:
                        break;
                }

            }
        };
        [self.view addSubview:acountView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
