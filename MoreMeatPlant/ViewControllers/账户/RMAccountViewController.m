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
#import "RMModifyPassWordViewController.h"

#import "UIViewController+ENPopUp.h"
#import "UIView+Expland.h"
#import "RMVPImageCropper.h"
#import "RMSystemMessageDetailViewController.h"

#import "RMAliPayViewController.h"
#import "RMTransactionRecordsViewController.h"
#import "RMSeeLogisticsViewController.h"
#import "RMShareClient.h"
#define GeneralMember @"1"
@interface RMAccountViewController ()<RMVPImageCropperDelegate>

@end

@implementation RMAccountViewController
@synthesize isCorp;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_model == nil){
        _model = [[RMPublicModel alloc]init];
    }
    if(!isShow){
        [self loadInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"账户"];
    
    _headerImgV.layer.cornerRadius = 5;
    _headerImgV.clipsToBounds = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(replaceHeaderImg:)];
    [_headerImgV addGestureRecognizer:tap];
    _headerImgV.userInteractionEnabled = YES;
    
    functitleArray = [[NSMutableArray alloc]init];
    funcimgArray = [[NSMutableArray alloc]init];
    
    
    [rightTwoBarButton setTitle:@"注销" forState:UIControlStateNormal];
    rightTwoBarButton.titleLabel.font = FONT_1(15);
    [rightTwoBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self initPlat];
    
    [self layoutViews];
    
    [self loadInfo];
}

- (void)loadInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager myInfoRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] andCallBack:^(NSError *error, BOOL success, id object) {
        RMPublicModel * model = object;
        _model = model;
        if(success && model.status){
            [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:model.contentFace] placeholderImage:[UIImage imageNamed:@"nophote"]];
            self.userNameL.text = model.contentName;
            self.userDescL.text = Str_Objc(model.contentQm, @"什么也没写...");
            self.regionL.text = model.contentGps;
            self.yu_eL.text = [NSString stringWithFormat:@"余额:%.0f",model.balance];
            self.hua_biL.text = [NSString stringWithFormat:@"花币:%.0f",model.spendmoney];
            [self.member_right setTitle:model.levelId forState:UIControlStateNormal];
            [self.member_level setTitle:model.levelId forState:UIControlStateNormal];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }else{
            
        }
    }];
}

- (void)initPlat{
    [funcimgArray removeAllObjects];
    [functitleArray removeAllObjects];
    
    for(UIView * v in self.view.subviews){
        if([v isKindOfClass:[RMAccountView class]]){
            [v removeFromSuperview];
        }
    }
    
    if([[[RMUserLoginInfoManager loginmanager] isCorp] isEqualToString:GeneralMember]){//普通会员
        functitleArray = [NSMutableArray arrayWithObjects:@"我的\n肉友",@"我的\n钱包",@"我的\n收藏",@"我的\n订单",@"我的\n帖子",@"系统\n通知",@"购物\n篮",@"等待\n升级",@"附近\n肉友",@"我的\n资料" ,@"分享",nil];
        funcimgArray = [NSMutableArray arrayWithObjects:@"wdry",@"wdqb",@"wdsc",@"wddd",@"wdtz",@"xttz",@"gwl",@"ddsj",@"fjry",@"wdzl",@"wdzl", nil];
        
        self.member_right_tag.hidden = YES;
        self.member_right.hidden = YES;
    }
    else{//商户会员
        functitleArray = [NSMutableArray arrayWithObjects:@"我的\n肉友",@"我的\n钱包",@"我的\n收藏",@"我的\n资料",@"已出\n宝贝",@"我的\n帖子",@"系统\n通知",@"附近\n肉友",@"宝贝\n管理",@"我的\n店铺",@"发布\n广告",@"等待\n升级",@"分享",nil];
        funcimgArray = [NSMutableArray arrayWithObjects:@"wdry",@"wdqb",@"wdsc",@"wdzl",@"wddd",@"wdtz",@"xttz",@"fjry",@"fbbb",@"sqkd",@"fbgg",@"ddsj",@"ddsj", nil];
        
        self.member_right_tag.hidden = NO;
        self.member_right.hidden = NO;
    }
    
    [self layoutViews];
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
                        AppDelegate * dele = [[UIApplication sharedApplication] delegate];
                        [dele tabSelectController:3];
                        dele.talkMoreCtl.selectedViewController = dele.talkMoreCtl._contactsVC;
                    }
                        break;
                    case 1:{//我的钱包
                        isShow = YES;
                        RMMyWalletViewController * mywallet = [[RMMyWalletViewController alloc]initWithNibName:@"RMMyWalletViewController" bundle:nil];
                        rightTwoBarButton.enabled = NO;
                        mywallet.zfb_no = _model.zfbNo;
                        mywallet.content_mobile = _model.contentMobile;
                        mywallet.view.frame = CGRectMake(20, 20, kScreenWidth-20*2, kScreenHeight-64-44-40);
                        [mywallet.titleLabel drawCorner:UIRectCornerTopLeft | UIRectCornerTopRight withFrame:CGRectMake(0, 0,kScreenWidth-20*2, mywallet.titleLabel.frame.size.height)];
                        
                        mywallet.closecallback = ^(UIButton * sender){
                            rightTwoBarButton.enabled = YES;
                            isShow = NO;
                            [self loadInfo];
                            [self dismissPopUpViewControllerWithcompletion:nil];
                        };
                        mywallet.billcallback = ^(UIButton * sender){
                            //跳转到账单界面push
                            RMTransactionRecordsViewController * record = [[RMTransactionRecordsViewController alloc]initWithNibName:@"RMTransactionRecordsViewController" bundle:nil];
                            [self.navigationController pushViewController:record animated:YES];
                        };
                        mywallet.top_upcallback = ^(NSString * content_money){
                            RMAliPayViewController * alipay = [[RMAliPayViewController alloc]initWithNibName:@"RMAliPayViewController" bundle:nil];
                            alipay.content_type = @"1";
                            alipay.content_money = content_money;
                            [self.navigationController pushViewController:alipay animated:YES];
                        };
                        
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
                        order.didSelectCell_callback = ^(RMPublicModel *model){
                            RMOrderDetailViewController * detail = [[RMOrderDetailViewController alloc]initWithNibName:@"RMOrderDetailViewController" bundle:nil];
                            detail._model = [[RMPublicModel alloc]init];
                            detail._model = model;
                            detail.order_type = model.content_type;
                            [self.navigationController pushViewController:detail animated:YES];
                        };
                        order.gopay_callback = ^(RMPublicModel *model){
                            //去付款
                            RMAliPayViewController * alipay = [[RMAliPayViewController alloc]initWithNibName:@"RMAliPayViewController" bundle:nil];
                            alipay.is_direct = NO;
                            alipay.order_id = model.content_sn;//支付宝支付的订单号
                            [self.navigationController pushViewController:alipay animated:YES];
                        };
                        
                        order.seeLogistics_callback = ^(RMPublicModel * model){
                            //查看物流信息
                            RMSeeLogisticsViewController * see = [[RMSeeLogisticsViewController alloc]initWithNibName:@"RMSeeLogisticsViewController" bundle:nil];
                            see.express_name = model.express_name;
                            see.express_no = model.express_no;
                            [self.navigationController pushViewController:see animated:YES];
                        };
                        order.gopay_callback = ^(RMPublicModel * model){
                            RMMyCorpViewController * corp = [[RMMyCorpViewController alloc] initWithNibName:@"RMMyCorpViewController" bundle:nil];
                            corp.auto_id = [[model.pros lastObject] objectForKey:@"corp_id"];
                            [self.navigationController pushViewController:corp animated:YES];
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
                    case 5:{
                        isShow = YES;
                        RMSysMessageViewController * message = [[RMSysMessageViewController alloc]initWithNibName:@"RMSysMessageViewController" bundle:nil];
                        message.callback = ^(RMSysMessageViewController * controller){
                            isShow = NO;
                            [self dismissPopUpViewControllerWithcompletion:nil];
                        };
                        
                        message.didselect_callback = ^(NSString * auto_id){
                            RMSystemMessageDetailViewController * detail = [[RMSystemMessageDetailViewController alloc]initWithNibName:@"RMSystemMessageDetailViewController" bundle:nil];
                            detail.auto_id = auto_id;
                            [self.navigationController pushViewController:detail animated:YES];
                        };
                        message.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-44);
                        [self presentPopUpViewController:message overlaybounds:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44)];
                    }
                        break;
                    case 6:{//购物车
                        RMShopCarViewController * shopcar = [[RMShopCarViewController alloc]initWithNibName:@"RMShopCarViewController" bundle:nil];
                        [self.navigationController pushViewController:shopcar animated:YES];
                    }
                        break;
                    case 7:{//等待升级
                       
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"敬请期待!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
                        [alert show];
                        return ;
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
                        userinfo.modify_callback = ^(RMUserInfoViewController *controller){
                            //跳转到修改密码
                            RMModifyPassWordViewController * modify = [[RMModifyPassWordViewController alloc]initWithNibName:@"RMModifyPassWordViewController" bundle:nil];
                            [self.navigationController pushViewController:modify animated:YES];
                        };
                        
                        userinfo.callback = ^(RMUserInfoViewController * controller){
                            
                            RMUserInfoEditViewController * edit = [[RMUserInfoEditViewController alloc]initWithNibName:@"RMUserInfoEditViewController" bundle:nil];
                            edit._model = [[RMPublicModel alloc]init];
                            edit._model = _model;
                            [self.navigationController pushViewController:edit animated:YES];
                            
                        };
                        userinfo._model = [[RMPublicModel alloc]init];
                        userinfo._model = _model;
                        
                        
                        userinfo.view.frame = CGRectMake(20, 0, kScreenWidth-20*2, kScreenHeight/3*2);
                        
                        [userinfo.titleLabel drawCorner:UIRectCornerTopLeft | UIRectCornerTopRight withFrame:CGRectMake(0, 0,kScreenWidth-20*2, userinfo.titleLabel.frame.size.height)];
                        [self presentPopUpViewController:userinfo overlaybounds:CGRectMake(0, 64, kScreenWidth, kScreenHeight-44-64)];
                    }
                        break;
                    case 10:{//分享
                        [self share:nil];
                    }
                        break;
                    default:
                        break;
                }

            }else{//商家会员
                switch (view.tag-100) {
                    case 0:{//我的肉友
                        AppDelegate * dele = [[UIApplication sharedApplication] delegate];
                        [dele tabSelectController:3];
                        dele.talkMoreCtl.selectedViewController = dele.talkMoreCtl._contactsVC;
                    }
                        break;
                    case 1:{//我的钱包
                        isShow = YES;
                        RMMyWalletViewController * mywallet = [[RMMyWalletViewController alloc]initWithNibName:@"RMMyWalletViewController" bundle:nil];
                        rightTwoBarButton.enabled = NO;
                        mywallet.zfb_no = _model.zfbNo;
                        mywallet.content_mobile = _model.contentMobile;
                        mywallet.view.frame = CGRectMake(20, 20, kScreenWidth-20*2, kScreenHeight-64-44-40);
                        [mywallet.titleLabel drawCorner:UIRectCornerTopLeft | UIRectCornerTopRight withFrame:CGRectMake(0, 0,kScreenWidth-20*2, mywallet.titleLabel.frame.size.height)];
                        
                        mywallet.closecallback = ^(UIButton * sender){
                            rightTwoBarButton.enabled = YES;
                            isShow = NO;
                            [self loadInfo];
                            [self dismissPopUpViewControllerWithcompletion:nil];
                        };
                        mywallet.billcallback = ^(UIButton * sender){
                            //跳转到账单界面push
                            RMTransactionRecordsViewController * record = [[RMTransactionRecordsViewController alloc]initWithNibName:@"RMTransactionRecordsViewController" bundle:nil];
                            [self.navigationController pushViewController:record animated:YES];
                        };
                        mywallet.top_upcallback = ^(NSString * content_money){
                            RMAliPayViewController * alipay = [[RMAliPayViewController alloc]initWithNibName:@"RMAliPayViewController" bundle:nil];
                            alipay.content_type = @"1";
                            alipay.content_money = content_money;
                            [self.navigationController pushViewController:alipay animated:YES];
                        };
                        
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
                        userinfo.modify_callback = ^(RMUserInfoViewController *controller){
                            //跳转到修改密码
                            RMModifyPassWordViewController * modify = [[RMModifyPassWordViewController alloc]initWithNibName:@"RMModifyPassWordViewController" bundle:nil];
                            [self.navigationController pushViewController:modify animated:YES];
                        };
                        
                        userinfo.callback = ^(RMUserInfoViewController * controller){
                            
                            RMUserInfoEditViewController * edit = [[RMUserInfoEditViewController alloc]initWithNibName:@"RMUserInfoEditViewController" bundle:nil];
                            edit._model = [[RMPublicModel alloc]init];
                            edit._model = _model;
                            [self.navigationController pushViewController:edit animated:YES];
                            
                        };
                        userinfo._model = [[RMPublicModel alloc]init];
                        userinfo._model = _model;
                        
                        
                        userinfo.view.frame = CGRectMake(20, 0, kScreenWidth-20*2, kScreenHeight/3*2);
                        
                        [userinfo.titleLabel drawCorner:UIRectCornerTopLeft | UIRectCornerTopRight withFrame:CGRectMake(0, 0,kScreenWidth-20*2, userinfo.titleLabel.frame.size.height)];
                        [self presentPopUpViewController:userinfo overlaybounds:CGRectMake(0, 64, kScreenWidth, kScreenHeight-44-64)];

                    }
                        break;
                    case 4:{//已出宝贝
//                        RMHadBabyViewController * hadbaby = [RMHadBabyViewController alloc]
                        isShow = YES;
                        RMHadBabyViewController * hadbaby = [[RMHadBabyViewController alloc]initWithNibName:@"RMHadBabyViewController" bundle:nil];
                        hadbaby.callback = ^(void){
                            isShow = NO;
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
                        isShow = YES;
                        RMSysMessageViewController * message = [[RMSysMessageViewController alloc]initWithNibName:@"RMSysMessageViewController" bundle:nil];
                        message.callback = ^(RMSysMessageViewController * controller){
                            isShow = NO;
                            [self dismissPopUpViewControllerWithcompletion:nil];
                        };
                        
                        message.didselect_callback = ^(NSString * auto_id){
                            RMSystemMessageDetailViewController * detail = [[RMSystemMessageDetailViewController alloc]initWithNibName:@"RMSystemMessageDetailViewController" bundle:nil];
                            detail.auto_id = auto_id;
                            [self.navigationController pushViewController:detail animated:YES];
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
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"敬请期待!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                        [alert show];
                    }
                        break;
                    case 12:{//分享
                        [self share:nil];
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


#pragma mark - 分享
- (void)share:(id)sender
{
    RMShareClient * client = [[RMShareClient alloc]init];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"标题" forKey:@"title"];
    [dic setValue:@"内容分享内容" forKey:@"content"];
    [dic setValue:@"http://www.baidu.com" forKey:@"url"];
    [dic setValue:@"image" forKey:@"image"];
    [client share:dic];
    client.sharebtnClicked = ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end){
        //                SSResponseStateBegan = 0, /**< 开始 */
        //                SSResponseStateSuccess = 1, /**< 成功 */
        //                SSResponseStateFail = 2, /**< 失败 */
        //                SSResponseStateCancel = 3 /**< 取消 */
        if (state == SSResponseStateCancel||state == SSResponseStateFail) {
            [self showHint:@"分享失败!"];
        }
        else if(state == SSResponseStateSuccess)
        {
            [self showHint:@"分享成功!"];
        }
    };
    
    
}


//外部调用我的订单
- (void)loadMyOrderCtl {
    RMMyOrderViewController * order = [[RMMyOrderViewController alloc]initWithNibName:@"RMMyOrderViewController" bundle:nil];
    order.callback = ^(void){
        
        [self dismissPopUpViewControllerWithcompletion:nil];
    };
    order.didSelectCell_callback = ^(RMPublicModel *model){
        RMOrderDetailViewController * detail = [[RMOrderDetailViewController alloc]initWithNibName:@"RMOrderDetailViewController" bundle:nil];
        detail._model = [[RMPublicModel alloc]init];
        detail._model = model;
        detail.order_type = model.content_type;
        [self.navigationController pushViewController:detail animated:YES];
    };
    order.gopay_callback = ^(RMPublicModel *model){
        //去付款
        RMAliPayViewController * alipay = [[RMAliPayViewController alloc]initWithNibName:@"RMAliPayViewController" bundle:nil];
        alipay.is_direct = NO;
        alipay.order_id = model.content_sn;//支付宝支付的订单号
        [self.navigationController pushViewController:alipay animated:YES];
    };
    
    order.seeLogistics_callback = ^(RMPublicModel * model){
        //查看物流信息
        RMSeeLogisticsViewController * see = [[RMSeeLogisticsViewController alloc]initWithNibName:@"RMSeeLogisticsViewController" bundle:nil];
        see.express_name = model.express_name;
        see.express_no = model.express_no;
        [self.navigationController pushViewController:see animated:YES];
    };
    order.gopay_callback = ^(RMPublicModel * model){
        RMMyCorpViewController * corp = [[RMMyCorpViewController alloc] initWithNibName:@"RMMyCorpViewController" bundle:nil];
        corp.auto_id = [[model.pros lastObject] objectForKey:@"corp_id"];
        [self.navigationController pushViewController:corp animated:YES];
    };
    
    order.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self presentPopUpViewController:order overlaybounds:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
    
    AppDelegate * dele = [[UIApplication sharedApplication] delegate];
    //环信注销
    [dele logoutEaseMobWithSuccess:^(id arg) {
        
    } failure:^(id arg) {
        
    }];
}

#pragma mark - 换头像
- (void)replaceHeaderImg:(UITapGestureRecognizer *)tap{
    [[RMVPImageCropper shareImageCropper] setCtl:self];
    [[RMVPImageCropper shareImageCropper] set_scale:1.0];
    [[RMVPImageCropper shareImageCropper] showActionSheet];
}

#pragma mark - RMimageCropperDelegate
- (void)RMimageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    NSLog(@"马东凯头像－－－－－－%@",editedImage);
}

- (void)RMimageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    NSLog(@"取消替换头像");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
