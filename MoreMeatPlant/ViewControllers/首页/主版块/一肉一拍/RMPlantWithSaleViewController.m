//
//  RMPlantWithSaleViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantWithSaleViewController.h"
#import "RMNearbyMerchantViewController.h"
#import "RMImageView.h"
#import "RMPlantWithSaleCell.h"
#import "RMPlantTypeView.h"
#import "RMStickView.h"
#import "RMPlantWithSaleDetailsViewController.h"
#import "RMBottomView.h"
#import "RMBaseWebViewController.h"
#import "RMSearchViewController.h"
#import "ZFModalTransitionAnimator.h"
#import "RefreshControl.h"
#import "RefreshView.h"
#import "KxMenu.h"
#import "RMShopCarViewController.h"
#import "AppDelegate.h"
#import "RMMyCollectionViewController.h"

@interface RMPlantWithSaleViewController ()<UITableViewDataSource,UITableViewDelegate,StickDelegate,SelectedPlantTypeMethodDelegate,JumpPlantDetailsDelegate,BottomDelegate,RefreshControlDelegate>{
    BOOL isFirstViewDidAppear;
    BOOL isRefresh;
    NSInteger pageCount;
    BOOL isLoadComplete;
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;         //list数据
@property (nonatomic, strong) NSMutableArray * newsArr;         //置顶数据
@property (nonatomic, strong) NSMutableArray * subsPlantArr;    //植物科目

@property (nonatomic, strong) ZFModalTransitionAnimator * animator;
@property (nonatomic, strong) RefreshControl * refreshControl;

@property (nonatomic, assign) NSInteger subsPlantRequestValue;   //请求list数据 默认传空 用户可以选择科目
@property (nonatomic, strong) RMBottomView * bottomView;

@end

@implementation RMPlantWithSaleViewController
@synthesize mTableView, dataArr, animator, refreshControl, newsArr, subsPlantArr, subsPlantRequestValue, bottomView;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isFirstViewDidAppear){
        [self requestNews];
        [self requestPlantSubjects];
        isFirstViewDidAppear = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setRightBarButtonNumber:1];
    [rightOneBarButton setImage:[UIImage imageNamed:@"img_search"] forState:UIControlStateNormal];

    [self setCustomNavTitle:@"一肉一拍"];
    
    newsArr = [[NSMutableArray alloc] init];
    dataArr = [[NSMutableArray alloc] init];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 37) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:mTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    
    pageCount = 1;
    isRefresh = YES;
    isFirstViewDidAppear = NO;
    subsPlantRequestValue = -9999;
    
    [self loadBottomView];
}

#pragma mark - 加载底部View

- (void)loadBottomView {
    bottomView = [[RMBottomView alloc] init];
    bottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_backup", @"img_up", @"img_buy", @"img_moreChat", nil]];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
}

#pragma mark - 加载tableViewHead

- (void)loadTableViewHead {
    mTableView.tableHeaderView = nil;
    
    UIView * headView = [[UIView alloc] init];
    
    RMImageView * rmImage = [[RMImageView alloc] init];
    rmImage.frame = CGRectMake(0, 0, kScreenWidth, 45);
    rmImage.image = LOADIMAGE(@"img_02", kImageTypePNG);
    [rmImage addTarget:self withSelector:@selector(jumpPlantWithSaleNearbyMerchant)];
    [headView addSubview:rmImage];
    
    CGFloat height = rmImage.frame.size.height;
    
    for (NSInteger i=0; i<[newsArr count]; i++) {
        RMPublicModel * model = [newsArr objectAtIndex:i];
        RMStickView * stickView = [[RMStickView alloc] init];
        stickView.frame = CGRectMake(0, height + i*30, kScreenWidth, 30);
        [headView addSubview:stickView];
        stickView.delegate = self;
        [stickView loadStickViewWithTitle:model.content_name withOrder:i];
    }
    
    for (NSInteger i=0; i<[newsArr count]; i++) {
        height = height + 30;
    }
    
    RMPlantTypeView * plantTypeView = [[RMPlantTypeView alloc] init];
    plantTypeView.frame = CGRectMake(0, height, kScreenWidth, kScreenWidth/7.0 + 5);
    plantTypeView.delegate = self;
    [plantTypeView loadPlantTypeWithImageArr:subsPlantArr];
    [headView addSubview:plantTypeView];
    
    height = height + kScreenWidth/7.0 + 5;
    
    headView.frame = CGRectMake(0, 0, kScreenWidth, height);
    mTableView.tableHeaderView = headView;
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([dataArr count]%3 == 0){
        return [dataArr count] / 3;
    }else if ([dataArr count]%3 == 1){
        return ([dataArr count] + 2) / 3;
    }else {
        return ([dataArr count] + 1) / 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifierStr = @"plantWithSaleIdentifier";
    RMPlantWithSaleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (!cell){
        if (IS_IPHONE_6p_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleCell_6p" owner:self options:nil] lastObject];
        }else if (IS_IPHONE_6_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleCell_6" owner:self options:nil] lastObject];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
        cell.delegate = self;
    }
    
    if(indexPath.row*3 < dataArr.count){
        cell.leftPrice.hidden = NO;
        cell.leftImg.hidden = NO;
        cell.leftName.hidden = NO;
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3];
        NSString * _price = [NSString stringWithFormat:@"  ¥%@",OBJC(model.content_price)];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:_price];
        [oneAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, 3)];
        cell.leftPrice.attributedText = oneAttributeStr;
        cell.leftName.text = [NSString stringWithFormat:@" %@",model.content_name];
        cell.leftImg.identifierString = model.auto_id;
        [cell.leftImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
    }else{
        cell.leftPrice.hidden = YES;
        cell.leftImg.hidden = YES;
        cell.leftName.hidden = YES;
    }
    if(indexPath.row*3+1 < dataArr.count){
        cell.centerPrice.hidden = NO;
        cell.centerImg.hidden = NO;
        cell.centerName.hidden = NO;
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3+1];
        NSString * _price = [NSString stringWithFormat:@"  ¥%@",OBJC(model.content_price)];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:_price];
        [oneAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, 3)];
        cell.centerPrice.attributedText = oneAttributeStr;
        cell.centerName.text = [NSString stringWithFormat:@" %@",model.content_name];
        cell.centerImg.identifierString = model.auto_id;
        [cell.centerImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
    }else{
        cell.centerPrice.hidden = YES;
        cell.centerImg.hidden = YES;
        cell.centerName.hidden = YES;
    }
    if(indexPath.row*3+2 < dataArr.count){
        cell.rightPrice.hidden = NO;
        cell.rightImg.hidden = NO;
        cell.rightName.hidden = NO;
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3+2];
        NSString * _price = [NSString stringWithFormat:@"  ¥%@",OBJC(model.content_price)];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:_price];
        [oneAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, 3)];
        cell.rightPrice.attributedText = oneAttributeStr;
        cell.rightName.text = [NSString stringWithFormat:@" %@",model.content_name];
        cell.rightImg.identifierString = model.auto_id;
        [cell.rightImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
    }else{
        cell.rightPrice.hidden = YES;
        cell.rightImg.hidden = YES;
        cell.rightName.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)jumpPlantDetailsWithImage:(RMImageView *)image {
    RMPlantWithSaleDetailsViewController * plantWithSaleDetailsCtl = [[RMPlantWithSaleDetailsViewController alloc] init];
    plantWithSaleDetailsCtl.auto_id = image.identifierString;
    plantWithSaleDetailsCtl.mTitle = @"一肉一拍";
    [self.navigationController pushViewController:plantWithSaleDetailsCtl animated:YES];
}

#pragma mark - 选择肉肉类型

- (void)selectedPlantWithType:(NSString *)type {
    if ([type isEqualToString:@"0"]){
        //全部
        subsPlantRequestValue = 10000;
        isRefresh = YES;
        [self requestListWithPlantCourse:@"" withPageCount:1];
    }else{
        //分类
        subsPlantRequestValue = type.integerValue;
        isRefresh = YES;
        RMPublicModel * model_2 = [subsPlantArr objectAtIndex:subsPlantRequestValue];
        [self requestListWithPlantCourse:model_2.auto_code withPageCount:1];
    }
}

#pragma mark - 跳转到置顶详情界面

- (void)stickJumpDetailsWithOrder:(NSInteger)order {
    RMPublicModel * model = [newsArr objectAtIndex:order];
    RMBaseWebViewController * baseWebCtl = [[RMBaseWebViewController alloc] init];
    [baseWebCtl loadHtmlWithAuto_id:model.auto_id withTitle:@"详情" withisloadRequest:NO];
    [self.navigationController pushViewController:baseWebCtl animated:YES];
}

#pragma mark - 跳转到附近商家

- (void)jumpPlantWithSaleNearbyMerchant {
    RMNearbyMerchantViewController * nearbyMerchantCtl = [[RMNearbyMerchantViewController alloc] init];
    [self.navigationController pushViewController:nearbyMerchantCtl animated:YES];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{

            break;
        }
        case 2:{
            RMSearchViewController * searchCtl = [[RMSearchViewController alloc] init];
            searchCtl.searchWhere = @"一肉一拍";
            searchCtl.searchType = @"宝贝";
            [self.navigationController pushViewController:searchCtl animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 底部栏回调方法

- (void)bottomMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 0:{
            //返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:{
            //滚到顶部
            [mTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
        case 2:{
            if (![[RMUserLoginInfoManager loginmanager] state]){
                NSLog(@"去登录....");
                return;
            }
            
            RMShopCarViewController * shopCarCtl = [[RMShopCarViewController alloc] init];
            [self.navigationController pushViewController:shopCarCtl animated:YES];
            break;
        }
        case 3:{
            KxMenuItem * item1 = [KxMenuItem menuItem:@"多聊消息" image:nil target:self action:@selector(menuSelected:) index:201];
            item1.foreColor = UIColorFromRGB(0x585858);
            KxMenuItem * item2 = [KxMenuItem menuItem:@"我的收藏" image:nil target:self action:@selector(menuSelected:) index:202];
            item2.foreColor = UIColorFromRGB(0x585858);
            KxMenuItem * item3 = [KxMenuItem menuItem:@"我的账户" image:nil target:self action:@selector(menuSelected:) index:203];
            item3.foreColor = UIColorFromRGB(0x585858);
            NSArray * arr = [[NSArray alloc]initWithObjects:item1,item2,item3, nil];
            
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
            if (![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                NSLog(@"去登录...");
                return ;
            }
            
            [self.navigationController popToRootViewControllerAnimated:NO];
            AppDelegate * shareApp = [UIApplication sharedApplication].delegate;
            [shareApp tabSelectController:3];
            break;
        }
        case 202:{
            if (![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                NSLog(@"去登录...");
                return ;
            }
            
            RMMyCollectionViewController * myCollectionCtl = [[RMMyCollectionViewController alloc] init];
            [self.navigationController pushViewController:myCollectionCtl animated:YES];
            break;
        }
        case 203:{
            if (![[RMUserLoginInfoManager loginmanager] state]){
                NSLog(@"去登录...");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return ;
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

#pragma mark - 数据请求

/**
 *  请求置顶数据
 */
- (void)requestNews {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getNewsWithOptionid:971 withPageCount:1 callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            [newsArr removeAllObjects];
            for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                model.content_title = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_title"]);
                model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                model.view_link = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"view_link"]);
                [newsArr addObject:model];
            }
            [self loadTableViewHead];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

/**
 *  请求植物科目  (景天科，番杏科，仙人球...)
 */
- (void)requestPlantSubjects {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPlantSubjectsListWithLevel:1 callBack:^(NSError *error, BOOL success, id object) {
        if (error) {
            NSLog(@"植物科目error:%@",error);
            NSString * subjectsType = @"";
            
            if (subsPlantRequestValue == -9999 | subsPlantRequestValue == 10000){
                subjectsType = @"";
            }else{
                RMPublicModel * model_2 = [subsPlantArr objectAtIndex:subsPlantRequestValue];
                subjectsType = model_2.auto_code;
            }
            
            [self requestListWithPlantCourse:subjectsType withPageCount:1];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success) {
            subsPlantArr = [[NSMutableArray alloc] init];
            
            RMPublicModel * model = [[RMPublicModel alloc] init];
            [subsPlantArr addObject:model];
            
            for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.auto_code = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_code"]);
                model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                model.change_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"change_img"]);
                model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                model.modules_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"modules_name"]);
                [subsPlantArr addObject:model];
            }
            
            [self loadTableViewHead];
            
            NSString * subjectsType = @"";
            
            if (subsPlantRequestValue == -9999 | subsPlantRequestValue == 10000){
                subjectsType = @"";
            }else{
                RMPublicModel * model_2 = [subsPlantArr objectAtIndex:subsPlantRequestValue];
                subjectsType = model_2.auto_code;
            }
            
            [self requestListWithPlantCourse:subjectsType withPageCount:1];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

/**
 *  @method     请求list 列表
 *  @param      plantClass      宝贝分类    1、为一肉一拍 2、鲜肉市场
 *  @param      plantCourse     植物科目
 *  @param      pageCount       分页
 */
- (void)requestListWithPlantCourse:(NSString *)plantCourse withPageCount:(NSInteger)pc {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getBabyListWithPlantClassWith:1 withCourse:plantCourse withMemerClass:nil withCorpid:nil withCount:pc callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            if (self.refreshControl.refreshingDirection == RefreshingDirectionTop) {
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_price = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_price"]);
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
            }else if(self.refreshControl.refreshingDirection==RefreshingDirectionBottom) {
                if ([[object objectForKey:@"data"] count] == 0){
                    [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    isLoadComplete = YES;
                    return;
                }
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_price = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_price"]);
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            }
            
            if (isRefresh){
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_price = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_price"]);
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
            }

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
        isRefresh = YES;
        isLoadComplete = NO;
        NSString * subjectsType = @"";

        if (subsPlantRequestValue == -9999 | subsPlantRequestValue == 10000){
            subjectsType = @"";
        }else{
            RMPublicModel * model_2 = [subsPlantArr objectAtIndex:subsPlantRequestValue];
            subjectsType = model_2.auto_code;
        }
        
        [self requestListWithPlantCourse:subjectsType withPageCount:1];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        if (isLoadComplete){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.44 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showHint:@"没有更多宝贝啦"];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            });
        }else{
            pageCount ++;
            isRefresh = NO;
            NSString * subjectsType = @"";
            
            if (subsPlantRequestValue == -9999 | subsPlantRequestValue == 10000){
                subjectsType = @"";
            }else{
                RMPublicModel * model_2 = [subsPlantArr objectAtIndex:subsPlantRequestValue];
                subjectsType = model_2.auto_code;
            }
            [self requestListWithPlantCourse:subjectsType withPageCount:pageCount];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
