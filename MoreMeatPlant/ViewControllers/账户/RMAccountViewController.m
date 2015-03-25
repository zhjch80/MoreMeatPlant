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
#import "RMUserInfoViewController.h"
#import "RMUserInfoEditViewController.h"
#import "RMMyWalletViewController.h"
#import "RMMyCollectionViewController.h"
#import "RMMyHomeViewController.h"
#import "RMMyOrderViewController.h"
#import "RMOrderDetailViewController.h"

#import "RMMyCorpViewController.h"
#import "RMPublishBabyViewController.h"
#import "RMBabyManageViewController.h"
#import "RMAdvertisingViewController.h"
#import "RMHadBabyViewController.h"
#import "RMLoginViewController.h"
#import "AppDelegate.h"

#import "UIViewController+ENPopUp.h"

#define GeneralMember @"1"
@interface RMAccountViewController ()

@end

@implementation RMAccountViewController
@synthesize isCorp;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"账户"];
    
    [self initPlat];
    
    [self layoutViews];
    
//    CGFloat availableLabelWidth = self.userDescL.frame.size.width;
//    self.userDescL.preferredMaxLayoutWidth = availableLabelWidth;

    
}

- (void)initPlat{
    _headerImgV.layer.cornerRadius = 5;
    _headerImgV.clipsToBounds = YES;
    
    functitleArray = [[NSMutableArray alloc]init];
    funcimgArray = [[NSMutableArray alloc]init];
    
    
    [rightTwoBarButton setTitle:@"注销" forState:UIControlStateNormal];
    rightTwoBarButton.titleLabel.font = FONT_1(15);
    [rightTwoBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if([[[RMUserLoginInfoManager loginmanager] isCorp] isEqualToString:GeneralMember]){//普通会员
        functitleArray = [NSMutableArray arrayWithObjects:@"我的\n肉友",@"我的\n钱包",@"我的\n收藏",@"我的\n订单",@"我的\n帖子",@"系统\n通知",@"购物\n篮",@"等待\n升级",@"附近\n肉友",@"我的\n资料" ,nil];
        funcimgArray = [NSMutableArray arrayWithObjects:@"wdry",@"wdqb",@"wdsc",@"wddd",@"wdtz",@"xttz",@"gwl",@"ddsj",@"fjry",@"wdzl", nil];
    }
    else{//商户会员
        functitleArray = [NSMutableArray arrayWithObjects:@"我的\n肉友",@"我的\n钱包",@"我的\n收藏",@"我的\n资料",@"已出\n宝贝",@"我的\n帖子",@"系统\n通知",@"附近\n肉友",@"宝贝\n管理",@"我的\n店铺",@"发布\n广告",@"等待\n升级",nil];
        funcimgArray = [NSMutableArray arrayWithObjects:@"wdry",@"wdqb",@"wdsc",@"wdzl",@"wddd",@"wdtz",@"xttz",@"fjry",@"fbbb",@"sqkd",@"fbgg",@"ddsj", nil];
    }
    
    
}

- (void)layoutViews {
    int width = (kScreenWidth-15*2-3*3)/4.0;
    int height = width*(166.0/280.0);
    for(int i = 0;i<[functitleArray count];i++)
    {
        RMAccountView * acountView = [[RMAccountView alloc]initWithFrame:CGRectMake(kScreenWidth-(width+3)*(i%4)-15-width, 204+(height+3)*(i/4), width, height)];
        acountView.tag = i+100;
        acountView.backgroundColor = UIColorFromRGB(0x2a2a2a);
        acountView.titleL.text = [functitleArray objectAtIndex:i];
        [acountView.imgV setImage:[UIImage imageNamed:[funcimgArray objectAtIndex:i]]];
        acountView.call_back = ^(RMAccountView * view){
            if([[[RMUserLoginInfoManager loginmanager] isCorp] isEqualToString:GeneralMember]){//普通会员
                switch (view.tag-100) {
                    case 0:{//我的肉友
                        
                    }
                        break;
                    case 1:{//我的钱包
                        RMMyWalletViewController * mywallet = [[RMMyWalletViewController alloc]initWithNibName:@"RMMyWalletViewController" bundle:nil];
                        mywallet.view.frame = CGRectMake(20, 20, kScreenWidth-20*2, kScreenHeight-64-44-40);
                        [self presentPopUpViewController:mywallet overlaybounds:CGRectMake(0, 64, kScreenWidth, kScreenHeight-108)];
                    }
                        break;
                    case 2:{//我的收藏
                        RMMyCollectionViewController * collection = [[RMMyCollectionViewController alloc]initWithNibName:@"RMMyCollectionViewController" bundle:nil];
                    
                        [self.navigationController pushViewController:collection animated:YES];
                    }
                        break;
                    case 3:{//我的订单
                        RMMyOrderViewController * order = [[RMMyOrderViewController alloc]initWithNibName:@"RMMyOrderViewController" bundle:nil];
                        order.callback = ^(void){
                            [self dismissPopUpViewControllerWithcompletion:nil];
                        };
                        order.didSelectCell_callback = ^(NSIndexPath * indexpath){
                            RMOrderDetailViewController * detail = [[RMOrderDetailViewController alloc]initWithNibName:@"RMOrderDetailViewController" bundle:nil];
                            [self.navigationController pushViewController:detail animated:YES];
                        };
                        order.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                        [self presentPopUpViewController:order overlaybounds:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                    }
                        break;
                    case 4:{//我的帖子
                        RMMyHomeViewController * home = [[RMMyHomeViewController alloc]initWithNibName:@"RMMyHomeViewController" bundle:nil];
                        [self.navigationController pushViewController:home animated:YES];
                    }
                        break;
                    case 5:{//系统消息
//                        RMSysMessageViewController * message = [[RMSysMessageViewController alloc]initWithNibName:@"RMSysMessageViewController" bundle:nil];
//                        [self.navigationController pushViewController:message animated:YES];
                        RMSysMessageViewController * message = [[RMSysMessageViewController alloc]initWithNibName:@"RMSysMessageViewController" bundle:nil];
                        message.callback = ^(RMSysMessageViewController * controller){
                            [self dismissPopUpViewControllerWithcompletion:nil];
                        };
                        message.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-44);
                        [self presentPopUpViewController:message overlaybounds:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44)];
                    }
                        break;
                    case 6:{//等待升级
                       
                    }
                        break;
                    case 7:{//购物车
                        RMShopCarViewController * shopcar = [[RMShopCarViewController alloc]initWithNibName:@"RMShopCarViewController" bundle:nil];
                        [self.navigationController pushViewController:shopcar animated:YES];
                        
                    }
                        break;
                    case 8:{//附近肉友
                        RMNearFriendViewController * near = [[RMNearFriendViewController alloc]initWithNibName:@"RMNearFriendViewController" bundle:nil];
                        [self.navigationController pushViewController:near animated:YES];
                    }
                        break;
                    case 9:{
                        RMUserInfoViewController * userinfo = [[RMUserInfoViewController alloc]initWithNibName:@"RMUserInfoViewController" bundle:nil];
                        
                        userinfo.close_action = ^(RMUserInfoViewController * controller){
                            [self dismissPopUpViewControllerWithcompletion:nil];
                        };
                        
                        userinfo.callback = ^(RMUserInfoViewController * controller){
                            
                            RMUserInfoEditViewController * edit = [[RMUserInfoEditViewController alloc]initWithNibName:@"RMUserInfoEditViewController" bundle:nil];
                            [self.navigationController pushViewController:edit animated:YES];
                            
                        };
                        userinfo.view.frame = CGRectMake(20, 0, kScreenWidth-20*2, kScreenHeight/3*2);
                        [self presentPopUpViewController:userinfo overlaybounds:CGRectMake(0, 64, kScreenWidth, kScreenHeight-44-64)];
                    }
                        break;
                    default:
                        break;
                }

            }else{//商家会员
                switch (view.tag-100) {
                    case 0:{//我的肉友
                        
                    }
                        break;
                    case 1:{//我的钱包
                        RMMyWalletViewController * mywallet = [[RMMyWalletViewController alloc]initWithNibName:@"RMMyWalletViewController" bundle:nil];
                        mywallet.view.frame = CGRectMake(20, 20, kScreenWidth-20*2, kScreenHeight-64-44-40);
                        [self presentPopUpViewController:mywallet overlaybounds:CGRectMake(0, 64, kScreenWidth, kScreenHeight-108)];
                    }
                        break;
                    case 2:{//我的收藏
                        RMMyCollectionViewController * collection = [[RMMyCollectionViewController alloc]initWithNibName:@"RMMyCollectionViewController" bundle:nil];
                        [self.navigationController pushViewController:collection animated:YES];
                    }
                        break;
                    case 3:{//我的资料
                        RMUserInfoViewController * userinfo = [[RMUserInfoViewController alloc]initWithNibName:@"RMUserInfoViewController" bundle:nil];
                        
                        userinfo.close_action = ^(RMUserInfoViewController * controller){
                            [self dismissPopUpViewControllerWithcompletion:nil];
                        };
                        
                        userinfo.callback = ^(RMUserInfoViewController * controller){
                            
                            RMUserInfoEditViewController * edit = [[RMUserInfoEditViewController alloc]initWithNibName:@"RMUserInfoEditViewController" bundle:nil];
                            [self.navigationController pushViewController:edit animated:YES];
                            
                        };
                        userinfo.view.frame = CGRectMake(20, 0, kScreenWidth-20*2, kScreenHeight/3*2);
                        [self presentPopUpViewController:userinfo overlaybounds:CGRectMake(0, 64, kScreenWidth, kScreenHeight-44-64)];

                    }
                        break;
                    case 4:{//已出宝贝
//                        RMHadBabyViewController * hadbaby = [RMHadBabyViewController alloc]
                        RMHadBabyViewController * hadbaby = [[RMHadBabyViewController alloc]initWithNibName:@"RMHadBabyViewController" bundle:nil];
                        hadbaby.callback = ^(void){
                            [self dismissPopUpViewControllerWithcompletion:nil];
                        };
                        hadbaby.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                        [self presentPopUpViewController:hadbaby overlaybounds:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                    }
                        break;
                    case 5:{//我的帖子
                        RMMyHomeViewController * home = [[RMMyHomeViewController alloc]initWithNibName:@"RMMyHomeViewController" bundle:nil];
                        [self.navigationController pushViewController:home animated:YES];
                    }
                        break;
                    case 6:{//系统通知
                        RMSysMessageViewController * message = [[RMSysMessageViewController alloc]initWithNibName:@"RMSysMessageViewController" bundle:nil];
                        message.callback = ^(RMSysMessageViewController * controller){
                            [self dismissPopUpViewControllerWithcompletion:nil];
                        };
                        message.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-44);
                        [self presentPopUpViewController:message overlaybounds:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44)];
                    }
                        break;
                    case 7:{//附近肉有
                        RMNearFriendViewController * near = [[RMNearFriendViewController alloc]initWithNibName:@"RMNearFriendViewController" bundle:nil];
                        [self.navigationController pushViewController:near animated:YES];
                    }
                        break;
                    case 8:{//发布宝贝
                        
                        RMBabyManageViewController * babymanage = [[RMBabyManageViewController alloc]initWithNibName:@"RMBabyManageViewController" bundle:nil];
                        [self.navigationController pushViewController:babymanage animated:YES];
                       
                    }
                        break;
                    case 9:{//我的店铺
                        RMMyCorpViewController * corp = [[RMMyCorpViewController alloc]initWithNibName:@"RMMyCorpViewController" bundle:nil];
                        [self.navigationController pushViewController:corp animated:YES];
                    }
                        break;
                    case 10:{//发布广告
                        RMAdvertisingViewController * advertise = [[RMAdvertisingViewController alloc]initWithNibName:@"RMAdvertisingViewController" bundle:nil];
                        [self.navigationController pushViewController:advertise animated:YES];
                    }
                        break;
                    case 11:{//等待升级
                        
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

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    switch (sender.tag) {
        case 1:{
            
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            [self resignUserLogin];
            AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
            [delegate loadMainViewControllersWithType:[[RMUserLoginInfoManager loginmanager] state]];
            [delegate tabSelectController:2];
            break;
        }
            
        default:
            break;
    }
}

- (void)resignUserLogin{
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:UserName];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:UserPwd];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LoginState];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:UserType];
    
    NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
    NSString * pwd = [[NSUserDefaults standardUserDefaults] objectForKey:UserPwd];
    NSString * iscorp = [[NSUserDefaults standardUserDefaults] objectForKey:UserType];
    NSString * coorstr = [[NSUserDefaults standardUserDefaults] objectForKey:UserCoor];
    
    [[RMUserLoginInfoManager loginmanager] setState:NO];
    [[RMUserLoginInfoManager loginmanager] setUser:user];
    [[RMUserLoginInfoManager loginmanager] setPwd:pwd];
    [[RMUserLoginInfoManager loginmanager] setIsCorp:iscorp];
    [[RMUserLoginInfoManager loginmanager] setCoorStr:coorstr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
