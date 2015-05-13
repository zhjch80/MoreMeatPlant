//
//  RMMyCorpViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMMyCorpViewController.h"
#import "RMCorpClassesButton.h"
#import "RMPlantWithSaleDetailsViewController.h"
#import "RMShopCarViewController.h"
#import "RMCorpHeadTableViewCell.h"
#import "AppDelegate.h"
#import "RMPlantWithSaleViewController.h"
#import "RMFreshPlantMarketViewController.h"
#import "RMMyHomeViewController.h"
#import "RMBaseWebViewController.h"
#import "RMVPImageCropper.h"

@interface RMMyCorpViewController ()<RefreshControlDelegate,RMVPImageCropperDelegate>{
    NSInteger pageCount;
    BOOL isRefresh;
    BOOL isLoadComplete;
    NSMutableArray * dataArr;
    RMCorpHeadTableViewCell * headView;
    NSURL * _filePath;
    NSURL * _headPath;
    CGFloat oneCellHeight;
}
@property (nonatomic, strong) RefreshControl * refreshControl;

@end

@implementation RMMyCorpViewController
@synthesize refreshControl;

- (void)viewWillAppear:(BOOL)animated{
    [badge setCount:[[self queryInfoNumber] intValue]];
    [car_badge setCount:[[self queryShopCarNumber] intValue]];
    [chat_badge setCount:[[self queryInfoNumber] intValue]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    oneCellHeight = kScreenWidth/3.0+19.5+40;
    
    self.mainTableview.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
    
    dataArr = [[NSMutableArray alloc]init];
   
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    
    rightOneBarButton.frame = CGRectMake(rightOneBarButton.frame.origin.x-20, rightOneBarButton.frame.origin.y, rightOneBarButton.frame.size.width+20, rightOneBarButton.frame.size.height);
    rightOneBarButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightOneBarButton setTitle:@"我的主页" forState:UIControlStateNormal];
    [rightOneBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    
    if(headView == nil){
        headView = [[[NSBundle mainBundle] loadNibNamed:@"RMCorpHeadTableViewCell" owner:self options:nil] lastObject];
        [headView.collection addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchDown];
        [headView.corp_level addTarget:self action:@selector(jumpToNews:) forControlEvents:UIControlEventTouchDown];
        [headView.corp_renzheng addTarget:self action:@selector(jumpToNews:) forControlEvents:UIControlEventTouchDown];
        [headView.corp_sun addTarget:self action:@selector(jumpToNews:) forControlEvents:UIControlEventTouchDown];
    }
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(replaceBannerImg:)];
    [headView.corp_headImgV addGestureRecognizer:tap2];
    headView.corp_headImgV.tag = 10000;
    headView.bannerImgV.tag = 10001;
    
    headView.corp_headImgV.layer.cornerRadius = 5;
    headView.corp_headImgV.clipsToBounds = YES;
    if(self.auto_id == nil){
        headView.collection.hidden = YES;
        headView.collectWidth.constant = 0;
        self.auto_id = [[RMUserLoginInfoManager loginmanager] s_id];
        rightOneBarButton.hidden = NO;
        self.titleName = @"我的店铺";
        headView.bannerImgV.userInteractionEnabled = YES;
        headView.corp_headImgV.userInteractionEnabled = YES;

    }else{
        self.titleName = @"店铺主页";
        rightOneBarButton.hidden = YES;
        headView.bannerImgV.userInteractionEnabled = NO;
        headView.corp_headImgV.userInteractionEnabled = NO;

    }
    
    [self setCustomNavTitle:self.titleName];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(replaceBannerImg:)];
    [headView.bannerImgV addGestureRecognizer:tap];
    

    
    bottomView = [[RMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_class", @"img_up", @"img_buy", @"img_moreChat", nil]];
    [self.view addSubview:bottomView];
    
    UIButton * btn = (UIButton *)[bottomView viewWithTag:3];
    badge = [[RKNotificationHub alloc]initWithView:btn];
    [badge scaleCircleSizeBy:0.5];
    [badge setCount:[[self queryInfoNumber] intValue]];
    
    UIButton * car_btn = (UIButton *)[bottomView viewWithTag:2];
    car_badge = [[RKNotificationHub alloc]initWithView:car_btn];
    [car_badge scaleCircleSizeBy:0.5];
    [car_badge setCount:[[self queryShopCarNumber] intValue]];
    
    
    
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mainTableview delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    pageCount = 1;
    isRefresh = YES;
    
    
    classsModel = [[RMPublicModel alloc]init];
    
    [self requestCorpid];
    
}




- (void)createClassView{
    float width = (kScreenWidth-10*2-3)/4.0;
    
    for(NSInteger i = 0; i<([classsModel.classs count]>4?4:[classsModel.classs count]); i ++ ){
        RMCorpClassesButton * btn = [[RMCorpClassesButton alloc]initWithFrame:CGRectMake(10+(width+1)*(i%4), 0, width, 40)];
        btn.tag = 100+i;
        btn.classesNameL.text = [[classsModel.classs objectAtIndex:i] objectForKey:@"content_name"];
        btn.classesNameL.font = FONT_1(14);
        btn.callback = ^(RMCorpClassesButton *sender){
            pageCount = 1;
            self.member_class = [[classsModel.classs objectAtIndex:i] objectForKey:@"auto_id"];
            [self requestListWithPlant];
        };
        [headView.classesView addSubview:btn];
        
        
        if(i == 3){
            return;
        }else{
            UIImageView * img_line = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width,btn.frame.origin.y+5 , 1, btn.frame.size.height-15)];
            img_line.backgroundColor = UIColorFromRGB(0xadadad);
            img_line.alpha = 0.8;
            [img_line setImage:[UIImage imageNamed:@""]];
            
            [headView.classesView addSubview:img_line];
        }
    }
}

#pragma mark - bottomViewDelegate

- (void)bottomMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 0:{
            NSMutableArray * arr = [[NSMutableArray alloc]init];
            for(int i = 1;i<[classsModel.classs count];i++){
                NSDictionary * dic = [classsModel.classs objectAtIndex:i];
                KxMenuItem * item = [KxMenuItem menuItem:[dic objectForKey:@"content_name"] image:nil target:self action:@selector(menuClassSelected:) index:100+i];
                item.foreColor = UIColorFromRGB(0x585858);
                [arr addObject:item];
            }
            
            [KxMenu setTintColor:[UIColor whiteColor]];
            UIButton * btn = (UIButton *)[bottomView viewWithTag:0];
            [KxMenu showMenuInView:self.view fromRect:CGRectMake(btn.frame.origin.x, bottomView.frame.origin.y, 100, 100) menuItems:arr];

            break;
        }
        case 1:{
            //滚到置顶
            [_mainTableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
        case 2:{
            if(![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            //购物车
            RMShopCarViewController * shop = [[RMShopCarViewController alloc]initWithNibName:@"RMShopCarViewController" bundle:nil];
            [self.navigationController pushViewController:shop animated:YES];
            break;
        }
        case 3:{
            if(![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            //多聊
            NSLog(@"多聊");
            KxMenuItem * item1 = [KxMenuItem menuItem:@"多聊消息" image:nil target:self action:@selector(menuSelected:) index:100];
            item1.foreColor = UIColorFromRGB(0x585858);
            KxMenuItem * item2 = [KxMenuItem menuItem:@"一物一拍" image:nil target:self action:@selector(menuSelected:) index:101];
            item2.foreColor = UIColorFromRGB(0x585858);
            KxMenuItem * item3 = [KxMenuItem menuItem:@"鲜肉市场" image:nil target:self action:@selector(menuSelected:) index:102];
            item3.foreColor = UIColorFromRGB(0x585858);
            NSArray * arr = [[NSArray alloc]initWithObjects:item1,item2,item3, nil];
            
            [KxMenu setTintColor:[UIColor whiteColor]];
            UIButton * btn = (UIButton *)[bottomView viewWithTag:3];
            [KxMenu showMenuInView:self.view fromRect:CGRectMake(btn.frame.origin.x, bottomView.frame.origin.y, 100, 100) menuItems:arr];
            
            
           
            for(UIView * v in self.view.subviews){
                if([v isKindOfClass:[KxMenuOverlay class]]){
                    KxMenuView * menuView = (KxMenuView *)[v.subviews lastObject];
                    UIView * targetView = [menuView viewWithTag:100];
                    
                    UILabel * targetlabel = (UILabel *)[targetView viewWithTag:1];
                    chat_badge = [[RKNotificationHub alloc]initWithView:targetlabel];
                    [chat_badge scaleCircleSizeBy:0.5];
                    [chat_badge setCount:[[self queryInfoNumber] intValue]];
                    break;
                }
            }

            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark  -点击认证图标的新闻介绍
- (void)jumpToNews:(UIButton *)sender{
    RMBaseWebViewController * baseWebView = [[RMBaseWebViewController alloc] init];
    [self.navigationController pushViewController:baseWebView animated:YES];
    [baseWebView loadHtmlWithAuto_id:@"10" withTitle:@"说明" withisloadRequest:NO];
}

#pragma mark - 点击左下角分类
- (void)menuClassSelected:(id)sender{
    KxMenuItem * item = (KxMenuItem *)sender;
    pageCount = 1;
    self.member_class = [[classsModel.classs objectAtIndex:item.tag-100] objectForKey:@"auto_id"];
    [self requestListWithPlant];
}
#pragma mark - 点击右下角聊天
- (void)menuSelected:(id)sender{
    KxMenuItem * item = (KxMenuItem *)sender;
    switch (item.tag-100) {
        case 0:
        {
            [self.navigationController popToRootViewControllerAnimated:NO];
            AppDelegate * dele = [[UIApplication sharedApplication] delegate];
            [dele tabSelectController:3];
        }
            break;
        case 1:
        {
            RMPlantWithSaleViewController * plante = [[RMPlantWithSaleViewController alloc]init];
            [self.navigationController pushViewController:plante animated:YES];
        }
            break;
        case 2:
        {
            RMFreshPlantMarketViewController * plante = [[RMFreshPlantMarketViewController alloc]init];
            [self.navigationController pushViewController:plante animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else{
        if ([dataArr count]%3 == 0){
            return [dataArr count] / 3;
        }else if ([dataArr count]%3 == 1){
            return ([dataArr count] + 2) / 3;
        }else {
            return ([dataArr count] + 1) / 3;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return headView;
    }else{
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return oneCellHeight;
    }else{
        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}
- (void)jumpPlantDetailsWithImage:(RMImageView *)image {
    RMPlantWithSaleDetailsViewController * plantWithSaleDetailsCtl = [[RMPlantWithSaleDetailsViewController alloc] init];
    plantWithSaleDetailsCtl.auto_id = image.identifierString;
    [self.navigationController pushViewController:plantWithSaleDetailsCtl animated:YES];
}

#pragma mark - 请求
- (void)requestListWithPlant {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getBabyListWithPlantClassWith:1 withCourse:0 withMemerClass:[self.member_class stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withCorpid:self.auto_id withCount:pageCount callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            if (self.refreshControl.refreshingDirection == RefreshingDirectionTop) {
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_price = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_price"]);
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    [dataArr addObject:model];
                }
                [_mainTableview reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
            }else if(self.refreshControl.refreshingDirection==RefreshingDirectionBottom) {
                if ([(NSArray *)[object objectForKey:@"data"] count] == 0){
                    [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    isLoadComplete = YES;
                    return;
                }
                for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_price = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_price"]);
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    [dataArr addObject:model];
                }
                [_mainTableview reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            }
            
            if (isRefresh){
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_price = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_price"]);
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    [dataArr addObject:model];
                }
                [_mainTableview reloadData];
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
        
        [self requestListWithPlant];
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
            [self requestListWithPlant];
        }
    }
}

#pragma mark - 获取店铺标示
- (void)requestCorpid{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getCorpHomeInfoWithAuto_id:self.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * model = object;
            classsModel = model;

//            headView = (RMCorpHeadTableViewCell *)[_mainTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [headView.corp_headImgV sd_setImageWithURL:[NSURL URLWithString:model.content_face] placeholderImage:[UIImage imageNamed:@"nophote"]];
            [headView.bannerImgV sd_setImageWithURL:[NSURL URLWithString:model.corp_photo] placeholderImage:[UIImage imageNamed:@"222"]];
            headView.corp_nameL.text = classsModel.content_name;
            headView.signatureL.text = classsModel.contentQm;
            headView.corp_regionL.text = classsModel.content_gps;
            [headView.corp_level setTitle:classsModel.levelId forState:UIControlStateNormal];
            if([model.publish boolValue]){
                
            }else{//没有审核通过
                headView.renzhengWidth.constant = 0;
                headView.renzheng_rightspace.constant = 0;
                headView.corp_renzheng.hidden = YES;
            }
            
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@"全部",@"auto_id",@"全部宝贝",@"content_name", nil];
            [classsModel.classs insertObject:dic atIndex:0];
            self.member_class = [[classsModel.classs objectAtIndex:0] objectForKey:@"auto_id"];
            [self createClassView];
            [self requestListWithPlant];
        }else{
            [self showHint:object];
        }
    }];
}

#pragma mark - 收藏
- (void)collectionAction:(UIButton *)sender{
    if(![[RMUserLoginInfoManager loginmanager] state]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    //收藏
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getMembersCollectWithCollect_id:self.auto_id withContent_type:@"2" withID:[[RMUserLoginInfoManager loginmanager] user] withPWD:[[RMUserLoginInfoManager loginmanager] pwd] callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showHint:[object objectForKey:@"msg"]];

    }];
}

- (void)goCorp:(id)sender{
    RMMyHomeViewController * home = [[RMMyHomeViewController alloc]init];
    if([self.auto_id isEqualToString:[[RMUserLoginInfoManager loginmanager] s_id]]){
        
    }else{
        home.auto_id = self.auto_id;
    }
    [self.navigationController pushViewController:home animated:YES];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 2:{
            break;
        }
        case 3:{
            [self goCorp:nil];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 换头像
- (void)replaceBannerImg:(UITapGestureRecognizer *)tap{
    if(tap.view.tag == 10001){
        [[RMVPImageCropper shareImageCropper] setCtl:self];
        [[RMVPImageCropper shareImageCropper] set_scale:1.0/2.0];
        [[RMVPImageCropper shareImageCropper] showActionSheet];
        [[RMVPImageCropper shareImageCropper] setFileName:@"content_bjimg.jpg"];
    }else{
        [[RMVPImageCropper shareImageCropper] setCtl:self];
        [[RMVPImageCropper shareImageCropper] set_scale:1.0/1.0];
        [[RMVPImageCropper shareImageCropper] showActionSheet];
        [[RMVPImageCropper shareImageCropper] setFileName:@"content_face.jpg"];
    }
    
}

#pragma mark - RMimageCropperDelegate
- (void)RMimageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage andfilePath:(NSURL *)filePath{
    if([[RMVPImageCropper shareImageCropper] _scale] == 1){
        _headPath = filePath;
        
    }else{
        _filePath = filePath;
    }
    
    [self modifyPhoto];
}

- (void)RMimageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    NSLog(@"取消替换头像");
}

#pragma mark -
- (void)modifyPhoto{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    if(_filePath != nil){
        [dic setValue:_filePath forKey:@"content_bjimg"];
    }
    if(_headPath != nil){
        [dic setValue:_headPath forKey:@"content_face"];
    }
    [RMAFNRequestManager myInfoModifyRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Type:nil AlipayNo:nil Signature:nil Dic:dic contentCode:nil andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * model = object;
            if(model.status){
                _filePath = nil;
                _headPath = nil;
                [self showHint:model.msg];
                [self requestCorpid];
                pageCount = 1;
            }else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:model.msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                
            }
            
        }else{
            [self showHint:object];
        }
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
