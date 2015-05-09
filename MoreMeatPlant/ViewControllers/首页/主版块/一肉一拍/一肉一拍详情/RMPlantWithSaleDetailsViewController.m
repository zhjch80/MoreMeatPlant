//
//  RMPlantWithSaleDetailsViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantWithSaleDetailsViewController.h"
#import "RMPlantWithSaleHeaderView.h"
#import "RMBottomView.h"
#import "RMPlantWithSaleDetailsCell.h"
#import "CycleScrollView.h"
#import "RMBaseView.h"
#import "RMSettlementViewController.h"
#import "RMAddressEditViewController.h"
#import "UIView+Expland.h"
#import "RMAliPayViewController.h"
#import "RMMyCorpViewController.h"
#import "UIImage+LK.h"
#import "RMShopCarViewController.h"
#import "AppDelegate.h"
#import "RMMyOrderViewController.h"
#import "RMMyCollectionViewController.h"
#import "NSString+Addtion.h"
#import "JSBadgeView.h"

@interface RMPlantWithSaleDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,BottomDelegate,PlantWithSaleHeaderViewDelegate,PlantWithSaleDetailsDelegate,RMAddressEditViewCompletedDelegate>{
    BOOL isFirstViewDidAppear;
    BOOL isRefresh;
    NSInteger baby_num;
    BOOL isLoadComplete;
    
    BOOL isAddShopCar;//判断是否是加入购物车还是立即购买                demoker添加
    RMSettlementViewController * settle;
    RMPublicModel * parameterModel;
    NSString * is_sf;
    
    JSBadgeView * car_badge;
}
@property (nonatomic, strong) RMPlantWithSaleHeaderView * headerView;;
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) CycleScrollView * cycleView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) RMBaseView * footerView;
@property (nonatomic, strong) RMPublicModel * dataModel;
@property (nonatomic, strong) RMBottomView * bottomView;

@end

@implementation RMPlantWithSaleDetailsViewController
@synthesize headerView, mTableView, dataArr, cycleView, footerView, auto_id, dataModel,bottomView;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isFirstViewDidAppear){
        [self requestDetals];
        isFirstViewDidAppear = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    car_badge.badgeText = [self queryShopCarNumber];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataArr = [[NSMutableArray alloc] init];
    
    baby_num = 1;
    
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 37) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    
    [self loadBottomView];

    UIButton * car_btn = (UIButton *)[bottomView viewWithTag:2];
    car_badge = [[JSBadgeView alloc]initWithParentView:car_btn alignment:JSBadgeViewAlignmentTopRight];
    car_badge.badgeBackgroundColor = UIColorFromRGB(0xe21a54);
    car_badge.badgeTextFont = FONT(12.0);
    car_badge.badgeText = [self queryShopCarNumber];
}

- (void)loadTableHeaderView {
    if ([dataModel.body isKindOfClass:[NSNull class]]){
        
    }else{
        if ([dataModel.body count] == 1){
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
            image.userInteractionEnabled = YES;
            image.backgroundColor = [UIColor clearColor];
            image.contentMode = UIViewContentModeCenter;
            image.clipsToBounds = YES;
            [image sd_setImageWithURL:[NSURL URLWithString:[[dataModel.body objectAtIndex:0] objectForKey:@"content_img"]] placeholderImage:nil];
            
//            UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
//            title.backgroundColor = [UIColor clearColor];
//            title.userInteractionEnabled = YES;
//            title.numberOfLines = 1;
//            title.textColor = [UIColor whiteColor];
//            title.font = [UIFont boldSystemFontOfSize:24.0];
//            title.text = [NSString stringWithFormat:@"page index: %d",1];
//            title.adjustsFontSizeToFitWidth = YES;
//            [title sizeToFit];
//            title.center = image.center;
//            [image addSubview:title];
            
            mTableView.tableHeaderView = image;
        }else{
            NSMutableArray *displayArr = [@[] mutableCopy];
            NSInteger count = ([dataModel.body count]>5 ? 5 : [dataModel.body count]);
            
            for (NSInteger i=0; i<count; i++) {
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
                image.userInteractionEnabled = YES;
                image.backgroundColor = [UIColor clearColor];
                image.contentMode = UIViewContentModeCenter;
                image.clipsToBounds = YES;
                [image sd_setImageWithURL:[NSURL URLWithString:[[dataModel.body objectAtIndex:i] objectForKey:@"content_img"]] placeholderImage:nil];
                
//                UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
//                title.backgroundColor = [UIColor clearColor];
//                title.userInteractionEnabled = YES;
//                title.numberOfLines = 1;
//                title.textColor = [UIColor whiteColor];
//                title.font = [UIFont boldSystemFontOfSize:24.0];
//                title.text = [NSString stringWithFormat:@"page index: %ld",(long)i];
//                title.adjustsFontSizeToFitWidth = YES;
//                [title sizeToFit];
//                title.center = image.center;
//                [image addSubview:title];
                
                [displayArr addObject:image];
            }
            
            __block RMPlantWithSaleDetailsViewController * blockSelf = self;
            
            cycleView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kScreenWidth) animationDuration:-1];
            cycleView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return displayArr[pageIndex];
            };
            self.cycleView.totalPagesCount = ^NSInteger(void){
                return ([blockSelf.dataModel.body count]>5 ? 5 : [blockSelf.dataModel.body count]);
            };
            self.cycleView.TapActionBlock = ^(NSInteger pageIndex){
                NSLog(@"select index %ld",(long)pageIndex);
            };
            mTableView.tableHeaderView = self.cycleView;
        }
    }
}

- (void)loadTableFooterView {
    footerView = [[[NSBundle mainBundle] loadNibNamed:@"RMBaseView" owner:nil options:nil] objectAtIndex:0];
    
    CGFloat offsetY = 0;
    
    if ([dataModel.body isKindOfClass:[NSNull class]]){
        
    }else{
        for (NSInteger i=0; i<[dataModel.body count]; i++) {
            UIImageView * imageView = [[UIImageView alloc] init];
            
            NSRange substr = [[[dataModel.body objectAtIndex:i] objectForKey:@"content_img"] rangeOfString:@".gif"];
            if (substr.location != NSNotFound) {
            }else{
                CGSize size = [UIImage downloadImageSizeWithURL:[[dataModel.body objectAtIndex:i] objectForKey:@"content_img"]];
                CGFloat height = size.height/size.width * kScreenWidth;
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:[[dataModel.body objectAtIndex:i] objectForKey:@"content_img"]] placeholderImage:nil];
                
                [imageView setFrame:CGRectMake(0, offsetY + 20, kScreenWidth, height)];

                offsetY = offsetY + imageView.frame.size.height + 30;

                footerView.frame = CGRectMake(0, 0, kScreenWidth, offsetY);
                
                [footerView addSubview:imageView];

                mTableView.tableFooterView = footerView;
            }
        }
    }
}

#pragma mark -

- (void)loadHeaderView {
    if (IS_IPHONE_6p_SCREEN){
        headerView = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleHeaderView_6p" owner:nil options:nil] objectAtIndex:0];
    }else if (IS_IPHONE_6_SCREEN){
        headerView = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleHeaderView_6" owner:nil options:nil] objectAtIndex:0];
    }else{
        headerView = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleHeaderView" owner:nil options:nil] objectAtIndex:0];
    }
    headerView.delegate = self;
    headerView.mTitle.text = self.mTitle;
    [headerView.userHeader.layer setCornerRadius:20.0f];
    headerView.userHeader.clipsToBounds = YES;
    [headerView.userHeader sd_setImageWithURL:[NSURL URLWithString:[dataModel.members objectForKey:@"content_face"]] placeholderImage:nil];
    headerView.userName.text = [dataModel.members objectForKey:@"member_name"];
    headerView.userLocation.text = [dataModel.members objectForKey:@"content_gps"];
    [self.view addSubview:headerView];
}

- (void)intoShopMethodWithBtn:(UIButton *)button {
    RMMyCorpViewController * corp = [[RMMyCorpViewController alloc]initWithNibName:@"RMMyCorpViewController" bundle:nil];
    corp.auto_id = dataModel.member_id;
    [self.navigationController pushViewController:corp animated:YES];
}

- (void)loadBottomView {
    bottomView = [[RMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
   [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_backup", @"img_collectiom", @"img_buy", @"img_moreChat", nil]];
    [self.view addSubview:bottomView];
}

- (void)bottomMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 0:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:{
            if(![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [RMAFNRequestManager getMembersCollectWithCollect_id:@"" withContent_type:@"3" withID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd callBack:^(NSError *error, BOOL success, id object) {
                if (error){
                    NSLog(@"error:%@",error);
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    return ;
                }
                
                if (success){
                    [self showHint:[object objectForKey:@"msg"]];
                    UIButton * btn = (UIButton *)[bottomView viewWithTag:1];
                    [btn setBackgroundImage:LOADIMAGE(@"img_asced", kImageTypePNG) forState:UIControlStateNormal];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }else{
                    [self showHint:[object objectForKey:@"msg"]];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            }];
            break;
        }
        case 2:{
            if(![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            RMShopCarViewController * shopCarCtl = [[RMShopCarViewController alloc] init];
            [self.navigationController pushViewController:shopCarCtl animated:YES];
            break;
        }
        case 3:{
            KxMenuItem * item1 = [KxMenuItem menuItem:@"多聊消息" image:nil target:self action:@selector(menuSelected:) index:201];
            item1.foreColor = UIColorFromRGB(0x585858);
            
            KxMenuItem * item2 = [KxMenuItem menuItem:@"我的订单" image:nil target:self action:@selector(menuSelected:) index:202];
            item2.foreColor = UIColorFromRGB(0x585858);

            KxMenuItem * item3 = [KxMenuItem menuItem:@"我的收藏" image:nil target:self action:@selector(menuSelected:) index:203];
            item3.foreColor = UIColorFromRGB(0x585858);
            
            KxMenuItem * item4 = [KxMenuItem menuItem:@"我的账户" image:nil target:self action:@selector(menuSelected:) index:204];
            item4.foreColor = UIColorFromRGB(0x585858);
            
            NSArray * arr = [[NSArray alloc]initWithObjects:item1,item2,item3,item4, nil];
            
            [KxMenu setTintColor:[UIColor whiteColor]];
            
            [KxMenu showMenuInView:self.view fromRect:CGRectMake(kScreenWidth - 100, bottomView.frame.origin.y, 100, 100) menuItems:arr];
            break;
        }
            
        default:
            break;
    }
}

- (void)menuSelected:(KxMenuItem *)sender {
    switch (sender.tag) {
        case 201:{
            [self.navigationController popToRootViewControllerAnimated:YES];
            AppDelegate * shareApp = [UIApplication sharedApplication].delegate;
            [shareApp tabSelectController:3];
            break;
        }
        case 202:{
            if (![[RMUserLoginInfoManager loginmanager] state]){
                NSLog(@"去登录...");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            AppDelegate * shareApp = [UIApplication sharedApplication].delegate;
            [shareApp tabSelectController:2];

            [shareApp.accountCtl loadMyOrderCtl];

            break;
        }
        case 203:{
            if (![[RMUserLoginInfoManager loginmanager] state]){
                NSLog(@"去登录...");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            
            RMMyCollectionViewController * myCollectionCtl = [[RMMyCollectionViewController alloc] init];
            [self.navigationController pushViewController:myCollectionCtl animated:YES];
            break;
        }
        case 204:{
            if (![[RMUserLoginInfoManager loginmanager] state]){
                NSLog(@"去登录...");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            AppDelegate * shareApp = [UIApplication sharedApplication].delegate;
            [shareApp tabSelectController:2];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifierStr = @"plantWithSaleDetailsIdentifier";
    RMPlantWithSaleDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (!cell){
        if (IS_IPHONE_6p_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleDetailsCell_6p" owner:self options:nil] lastObject];
        }else if (IS_IPHONE_6_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleDetailsCell_6" owner:self options:nil] lastObject];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleDetailsCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        UILabel * kucun = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, cell.productIntro.frame.size.height)];
        kucun.tag = 101311;
        [cell.contentView addSubview:kucun];
        UILabel * shunfengL = [[UILabel alloc]init];
        shunfengL.tag = 101312;
        [cell.contentView addSubview:shunfengL];
        
        UIButton * shunfengB = [UIButton buttonWithType:UIButtonTypeCustom];
        shunfengB.tag = 101313;
        [shunfengB addTarget:self action:@selector(expressSelect:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:shunfengB];
        
        UILabel * other_expressL = [[UILabel alloc]init];
        other_expressL.tag = 101314;
        [cell.contentView addSubview:other_expressL];
        
        UIButton * other_expressB = [UIButton buttonWithType:UIButtonTypeCustom];
        other_expressB.tag = 101315;
        [other_expressB addTarget:self action:@selector(expressSelect:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:other_expressB];
    }
    
    NSString * _price = [NSString stringWithFormat:@"¥%@",dataModel.content_price];
    NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:_price];
    [oneAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, 1)];
    cell.price.textColor = [UIColor colorWithRed:0.94 green:0 blue:0.3 alpha:1];
    cell.price.attributedText = oneAttributeStr;

//    if ([dataModel.is_sf isEqualToString:@"1"]){
//        cell.productIntro.text = [NSString stringWithFormat:@"快递：%@元 顺风:22元 库存:%@件",dataModel.express_price,dataModel.content_num];
//    }else{
//        cell.productIntro.text = [NSString stringWithFormat:@"快递：%@元 库存:%@件",dataModel.express_price,dataModel.content_num];
//    }
    
    
    UILabel * kucun = (UILabel *)[cell.contentView viewWithTag:101311];
    kucun.text = [NSString stringWithFormat:@"库存:%@件",dataModel.content_num];
    kucun.numberOfLines = 0;
    kucun.font  = FONT_0(13);
    kucun.tag = 101311;
    CGSize size = [kucun.text getcontentsizeWithfont:kucun.font constrainedtosize:CGSizeMake(200, 30) linemode:NSLineBreakByWordWrapping];
    kucun.frame = CGRectMake(cell.productIntro.frame.size.width-size.width, 0, size.width, size.height);
    kucun.center = CGPointMake(kucun.center.x, cell.productIntro.frame.size.height/2);
    
    
    
    UILabel * shunfengL = (UILabel *)[cell.contentView viewWithTag:101312];
    UIButton * shunfengB = (UIButton *)[cell.contentView viewWithTag:101313];
    UILabel * other_expressL = (UILabel *)[cell.contentView viewWithTag:101314];
    UIButton * other_expressB = (UIButton *)[cell.contentView viewWithTag:101315];
    
    
    
    
    other_expressB.frame = CGRectMake(other_expressL.frame.origin.x-30, cell.productIntro.frame.size.height/2-30/2, 30, 30);
    
    if([dataModel.content_express length]>1 && dataModel.express_price != nil){
        other_expressL.text = [NSString stringWithFormat:@"%@:%@元",dataModel.content_express,dataModel.express_price];
        other_expressL.numberOfLines = 0;
        other_expressL.font  = FONT_0(13);
        CGSize size = [other_expressL.text getcontentsizeWithfont:other_expressL.font constrainedtosize:CGSizeMake(200, 30) linemode:NSLineBreakByWordWrapping];
        other_expressL.frame = CGRectMake(kucun.frame.origin.x-size.width-10, 0, size.width, size.height);
        other_expressL.center = CGPointMake(other_expressL.center.x, cell.productIntro.frame.size.height/2);
        
        other_expressB.frame = CGRectMake(other_expressL.frame.origin.x-20, cell.productIntro.frame.size.height/2-20/2, 20, 20);
        if([is_sf isEqualToString:@"0"]){
            [other_expressB setImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
        }else{
            [other_expressB setImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
        }
    }
    
    if([dataModel.is_sf boolValue]){
        if([dataModel.content_express length] == 0){
            other_expressL.frame = CGRectMake(kucun.frame.origin.x-other_expressL.frame.size.width-10, 0, other_expressL.frame.size.width, other_expressL.frame.size.height);
            other_expressL.center = CGPointMake(other_expressL.center.x, cell.productIntro.frame.size.height/2);
            other_expressB.frame = CGRectMake(other_expressL.frame.origin.x-20, cell.productIntro.frame.size.height/2-20/2, 0, 0);
        }
        shunfengL.text = [NSString stringWithFormat:@"顺丰:22元"];
        shunfengL.numberOfLines = 0;
        shunfengL.font  = FONT_0(13);
        CGSize size = [shunfengL.text getcontentsizeWithfont:shunfengL.font constrainedtosize:CGSizeMake(200, 30) linemode:NSLineBreakByWordWrapping];
        shunfengL.frame = CGRectMake(other_expressB.frame.origin.x-size.width-10, 0, size.width, size.height);
        shunfengL.center = CGPointMake(shunfengL.center.x, cell.productIntro.frame.size.height/2);
        
        shunfengB.frame = CGRectMake(shunfengL.frame.origin.x-20, cell.productIntro.frame.size.height/2-20/2, 20, 20);
        if([is_sf isEqualToString:@"1"]){
            [shunfengB setImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
        }else{
            [shunfengB setImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
        }
    }
    
    
    if ([dataModel.content_num isEqualToString:@"0"]){
        cell.showNum.text = @"1";
    }
    
    cell.productName.text = dataModel.content_name;
    cell.plantIntro.text = [NSString stringWithFormat:@"肉肉介绍:%@",dataModel.content_desc];
    cell.plantIntro.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *twoAttributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"肉肉介绍:%@",dataModel.content_desc]];
    [twoAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1] range:NSMakeRange(0, 5)];
    cell.plantIntro.attributedText = twoAttributeStr;
    
    CGFloat offsetY = [UtilityFunc boundingRectWithSize:CGSizeMake(kScreenWidth - 150, 0) font:FONT(13.0) text:dataModel.content_desc].height;
    
    cell.plantIntro.frame = CGRectMake(8, 90, kScreenWidth - 150, offsetY);
    [cell setCellHeight:90 + offsetY];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return (cell.frame.size.height > 165 ? cell.frame.size.height : 165);
}

#pragma mark - 
- (void)expressSelect:(UIButton *)sender{
    if(sender.tag == 101313){
        if([is_sf isEqualToString:@"1"]){
            
        }else{
            is_sf = @"1";
        }
    }else if (sender.tag == 101315){
        if([is_sf isEqualToString:@"1"]){
            is_sf = @"0";
        }else{
            
        }
    }
    [mTableView reloadData];
}

- (void)plantWithSaleCellMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 101:{
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            RMPlantWithSaleDetailsCell * cell = (RMPlantWithSaleDetailsCell *)[mTableView cellForRowAtIndexPath:indexPath];
            NSInteger num = [[NSString stringWithFormat:@"%@",cell.showNum.text] integerValue];
            
            if ([dataModel.content_class isEqualToString:@"1"]){//1 标示一肉一拍
                if (num <= 1){
                    num = 1;
                }else{
                    num --;
                }
                cell.showNum.text = [NSString stringWithFormat:@"%ld",(long)num];
            }else{//鲜肉市场
                if (num >= 1){
                    num --;
                }else{
                    num = 1;
                }
                cell.showNum.text = [NSString stringWithFormat:@"%ld",(long)num];
                
            }
            baby_num = num;
            cell.showNum.text = @"1";
            [self showHint:@"至少要选择一个宝贝！"];
            break;
        }
        case 102:{
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            RMPlantWithSaleDetailsCell * cell = (RMPlantWithSaleDetailsCell *)[mTableView cellForRowAtIndexPath:indexPath];
            NSInteger num = [[NSString stringWithFormat:@"%@",cell.showNum.text] integerValue];
            
            if ([dataModel.content_class isEqualToString:@"1"]){
                if (num > 0){
                }else{
                    if (![dataModel.content_num isEqualToString:@"0"]){
                        num ++;
                    }
                }
                cell.showNum.text = [NSString stringWithFormat:@"%ld",(long)num];
                [self showHint:@"一肉一拍区的宝贝只能选择一个哦！"];
            }else{
                num ++;
                cell.showNum.text = [NSString stringWithFormat:@"%ld",(long)num];
            }
    
            baby_num = num;
            
            break;
        }
        case 103:{
            if(![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            NSLog(@"立即购买auto_id:%@",self.auto_id);
            if([[[RMUserLoginInfoManager loginmanager] isCorp] integerValue] == 2){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"商家会员不可以进行购买服务" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            [self valliateNums];
            isAddShopCar = NO;
            break;
        }
        case 104:{
            if(![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            NSLog(@"加入购物车auto_id:%@",self.auto_id);
            if([[[RMUserLoginInfoManager loginmanager] isCorp] integerValue] == 2){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"商家会员不可以进行购买服务" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            [self valliateNums];
            isAddShopCar = YES;
            break;
        }
        case 105:{
            if(![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            NSLog(@"联系掌柜auto_id:%@",self.auto_id);
            [self.navigationController popToRootViewControllerAnimated:YES];
            AppDelegate * dele = [[UIApplication sharedApplication] delegate];
            [dele tabSelectController:3];
            [dele.talkMoreCtl._chatListVC jumpToChatView:[dataModel.members objectForKey:@"content_user"]];
            break;
        }
            
        default:
            break;
    }
}


#pragma mark - 查阅数据库该宝贝的数量
- (void)refertoBabyNum{
    if([dataModel.content_class isEqualToString:@"1"]){
    
    }else{
        
    }
}

#pragma mark - 验证库存，加入购物车
- (void)valliateNums{
    if(is_sf == nil){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择快递方式" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    NSInteger n = 0;
    if([RMProductModel existDbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",dataModel.auto_id]])
    {
        RMProductModel * pp = [[RMProductModel dbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",dataModel.auto_id] orderby:nil] lastObject];
        n = baby_num + pp.content_num;
    }else{
        n = baby_num;
    }
    
    NSLog(@"+++++++++++++++++++++%ld",(long)n);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager valliateGoodsNumWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] auto_id:self.auto_id Nums:n andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(success){
            RMPublicModel * model = object;
            if(model.status){
                [self addGoodsToShopCar:n];
                if(isAddShopCar){//加入购物车
                    
                }else{//立即购买
                    [self buyNow];
                }
                
            }else{
                //没有的话不做任何操作
            }
            
            [self showHint:model.msg];
        }else{
            [self showHint:object];
        }
    }];
}
#pragma mark -添加宝贝到购物车
- (void)addGoodsToShopCar:(NSInteger)num{

    RMProductModel * product = [[RMProductModel alloc]init];
    product.auto_id = dataModel.auto_id;
    product.content_img = dataModel.content_img;
    product.content_name = dataModel.content_name;
    product.content_price = dataModel.content_price;

    if([is_sf isEqualToString:@"1"]){
        product.express = @"2";
        product.express_price = @"22";
    }else{
        product.express = @"1";
        product.express_price = dataModel.express_price;
    }
    product.corp_id = dataModel.member_id;
    product.content_num = num;
    product.plante = dataModel.content_class;//一肉一拍 还是 鲜肉市场?
    product.corp_user = [dataModel.members objectForKey:@"content_user"];
    
    NSLog(@"%@",product);
    
    RMCorpModel * shop = [[RMCorpModel alloc]init];
    shop.corp_id = dataModel.member_id;
    shop.corp_name = [dataModel.members objectForKey:@"member_name"];
    shop.order_message = @"";
    if([RMCorpModel existDbObjectsWhere:[NSString stringWithFormat:@"corp_id=%@",shop.corp_id]])
    {
        [shop updatetoDb];
    }
    else
    {
        [shop insertToDb];
    }
    
    NSArray * arr = [RMProductModel dbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",product.auto_id] orderby:nil];
    for(RMProductModel * p in arr){//把所有的这个店铺的商品的快递方式都设置为最后添加的快递方式
        p.express = product.express;
        p.express_price = product.express_price;
        [p updatetoDb];
    }
    
    if([RMProductModel existDbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",dataModel.auto_id]])
    {
        RMProductModel * ppt = [[RMProductModel dbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",dataModel.auto_id] orderby:nil] lastObject];
        
       ppt.content_num = num;
        [ppt updatetoDb];
    }
    else
    {
        [product insertToDb];
    }
    car_badge.badgeText = [self queryShopCarNumber];
    [self showHint:@"添加购物车成功!"];
}

#pragma mark -立即购买
- (void)buyNow{
#if 1
    RMShopCarViewController * shopcar = [[RMShopCarViewController alloc]initWithNibName:@"RMShopCarViewController" bundle:nil];
    [self.navigationController pushViewController:shopcar animated:YES];
#else
    parameterModel.payment_id = @"2";
    __block RMPlantWithSaleDetailsViewController * SELF = self;
    settle = [[RMSettlementViewController alloc]initWithNibName:@"RMSettlementViewController" bundle:nil];
    
    settle.view.frame = CGRectMake(20, 60, kScreenWidth-20*2, kScreenHeight-60*2);
    [settle.titleView drawCorner:UIRectCornerTopLeft | UIRectCornerTopRight withFrame:CGRectMake(0, 0,kScreenWidth-20*2, kScreenHeight-60*2)];
    settle.callback = ^(void){
        [SELF dismissPopUpViewControllerWithcompletion:nil];
    };
//    settle.settle_callback = ^(RMPublicModel * model){//支付宝网站支付
//        [SELF commitOrderAction];
//
//    };
    settle.editAddress_callback = ^(RMPublicModel * model_){
        RMAddressEditViewController * address_edit = [[RMAddressEditViewController alloc]initWithNibName:@"RMAddressEditViewController" bundle:nil];
        address_edit._model = [[RMPublicModel alloc]init];
        address_edit._model = model_;
        address_edit.delegate = SELF;
        [SELF.navigationController pushViewController:address_edit animated:YES];
    };
    settle.addAddress_callback = ^(void){
        RMAddressEditViewController * address_edit = [[RMAddressEditViewController alloc]initWithNibName:@"RMAddressEditViewController" bundle:nil];
        address_edit.delegate = SELF;
        [SELF.navigationController pushViewController:address_edit animated:YES];
    };
    
    settle.payment_callback = ^(NSString * payment_id){
        SELF->parameterModel.payment_id = payment_id;
    };
    settle.selectAddress_callback = ^ (RMPublicModel * model){
        SELF->parameterModel.content_linkname = model.contentName;
        SELF->parameterModel.content_mobile = model.contentMobile;
        SELF->parameterModel.content_address = model.contentAddress;
    };
    
    [self presentPopUpViewController:settle overlaybounds:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
#endif

}

#pragma mark - 提交订单
//- (void)commitOrderAction{
//    
//    parameterModel.express = [dataModel.is_sf boolValue]?@"2":@"1";
//    
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
//    [dict setValue:dataModel.auto_id forKey:@"auto_id"];
//    [dict setValue:@"1" forKey:@"num"];
//    [dict setValue:parameterModel.payment_id forKey:@"frm[payment_id]"];
//    [dict setValue:parameterModel.express forKey:@"express"];
//    [dict setValue:parameterModel.content_linkname forKey:@"frm[content_linkname]"];
//    [dict setValue:parameterModel.content_mobile forKey:@"frm[content_mobile]"];
//    [dict setValue:parameterModel.content_address forKey:@"frm[content_address]"];
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [RMAFNRequestManager commitOrderWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] withDic:dict andCallBack:^(NSError *error, BOOL success, id object) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        if(success){
//            RMPublicModel * model = object;
//            if(model.status){
//                if([parameterModel.payment_id isEqualToString:@"2"]){
//                    RMAliPayViewController * alipay = [[RMAliPayViewController alloc]initWithNibName:@"RMAliPayViewController" bundle:nil];
//                    alipay.is_direct = YES;
//                    alipay.order_id = model.content_sn;//支付宝支付的订单号
//                    [self.navigationController pushViewController:alipay animated:YES];
//                }
//            }else{
//                
//            }
//            [self showHint:model.msg];
//        }else{
//            [self showHint:object];
//        }
//    }];
//}



- (void)RMAddressEditViewCompleted{
    
    [settle requestAddresslist];
}

#pragma mark - 数据请求

- (void)requestDetals {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getBabyListDetalisWithAuto_id:self.auto_id callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            dataModel = [[RMPublicModel alloc] init];
            dataModel.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"auto_id"]);
            dataModel.content_course = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_course"]);
            dataModel.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_img"]);
            dataModel.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"create_time"]);
            dataModel.create_user = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"create_user"]);
            dataModel.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_name"]);
            dataModel.content_desc = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_desc"]);
            dataModel.content_price = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_price"]);
            dataModel.content_express = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_express"]);
            dataModel.express_price = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"express_price"]);
            dataModel.content_num = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_num"]);
            dataModel.content_class = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_class"]);
            dataModel.member_class = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"member_class"]);
            dataModel.member_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"member_id"]);
            dataModel.is_sf = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"is_sf"]);
            dataModel.body = [[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"body"];
            dataModel.members = [[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"member"];
            dataModel.series = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"series"]);
            dataModel.is_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:0] objectForKey:@"is_collect"]);
            [dataArr addObject:dataModel];
            
            if([dataModel.is_sf boolValue]){
                is_sf = @"1";
            }else{
                is_sf = @"0";
            }
            
            if ([dataModel.is_collect isEqualToString:@"1"]){
                UIButton * btn = (UIButton *)[bottomView viewWithTag:1];
                [btn setBackgroundImage:LOADIMAGE(@"img_asced", kImageTypePNG) forState:UIControlStateNormal];
            }
            
            if ([dataModel.is_collect isEqualToString:@"1"]){
                UIButton * btn = (UIButton *)[bottomView viewWithTag:1];
                [btn setBackgroundImage:LOADIMAGE(@"img_asced", kImageTypePNG) forState:UIControlStateNormal];
            }
           
            [self loadHeaderView];
            
            [mTableView reloadData];
            
            [self loadTableHeaderView];
            
            [self loadTableFooterView];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
