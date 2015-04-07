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
@interface RMMyCorpViewController ()<RefreshControlDelegate>{
    NSInteger pageCount;
    BOOL isRefresh;
    BOOL isLoadComplete;
    NSMutableArray * dataArr;
}
@property (nonatomic, strong) RefreshControl * refreshControl;

@end

@implementation RMMyCorpViewController
@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mainTableview.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
    
    [self setCustomNavTitle:@"我的店铺"];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    _corp_headImgV.layer.cornerRadius = 5;
    _corp_headImgV.clipsToBounds = YES;
    
    bottomView = [[RMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_class", @"img_up", @"img_buy", @"img_moreChat", nil]];
    [self.view addSubview:bottomView];
    
    UIButton * btn = (UIButton *)[bottomView viewWithTag:4];
    badge = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopRight];
    badge.badgeBackgroundColor = UIColorFromRGB(0xe21a54);
    badge.badgeTextFont = FONT(10.0);
    badge.badgeText = @"99";
    
    UIButton * car_btn = (UIButton *)[bottomView viewWithTag:3];
    car_badge = [[JSBadgeView alloc]initWithParentView:car_btn alignment:JSBadgeViewAlignmentTopRight];
    car_badge.badgeBackgroundColor = UIColorFromRGB(0xe21a54);
    car_badge.badgeTextFont = FONT(10.0);
    car_badge.badgeText = @"99";
    
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mainTableview delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[CustomRefreshView class]];
    pageCount = 1;
    isRefresh = YES;
    
    
    NSArray * titles = [NSArray arrayWithObjects:@"全部宝贝",@"一肉一拍",@"进口肉肉",@"老桩专区", nil];
    float width = (kScreenWidth-10*2-3)/4.0;
    for(NSInteger i = 0; i<4; i ++ ){
        RMCorpClassesButton * btn = [[RMCorpClassesButton alloc]initWithFrame:CGRectMake(10+(width+1)*(i%4), 0, width, 40)];
        btn.tag = 100+i;
        btn.classesNameL.text = [titles objectAtIndex:i];
        btn.classesNameL.font = FONT_0(13);
        btn.callback = ^(RMCorpClassesButton *sender){
        
            switch (sender.tag-100) {
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
                    
                default:
                    break;
            }
            
        };
        
        
        [_classesView addSubview:btn];
        
        
        if(i == 3){
            return;
        }else{
            UIImageView * img_line = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width,btn.frame.origin.y+1 , 1, btn.frame.size.height-2)];
            img_line.backgroundColor = UIColorFromRGB(0xadadad);
            [img_line setImage:[UIImage imageNamed:@""]];
            
            [_classesView addSubview:img_line];
        }
    }
    
}

#pragma mark - bottomViewDelegate

- (void)bottomMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 0:{
            KxMenuItem * item1 = [KxMenuItem menuItem:@"一肉一拍" image:nil target:self action:@selector(menuClassSelected:) index:100];
            item1.foreColor = UIColorFromRGB(0x585858);
            KxMenuItem * item2 = [KxMenuItem menuItem:@"进口肉肉" image:nil target:self action:@selector(menuClassSelected:) index:101];
            item2.foreColor = UIColorFromRGB(0x585858);
            KxMenuItem * item3 = [KxMenuItem menuItem:@"老庄专区" image:nil target:self action:@selector(menuClassSelected:) index:102];
            item3.foreColor = UIColorFromRGB(0x585858);
            NSArray * arr = [[NSArray alloc]initWithObjects:item1,item2,item3, nil];
            
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
            //购物车
            RMShopCarViewController * shop = [[RMShopCarViewController alloc]initWithNibName:@"RMShopCarViewController" bundle:nil];
            [self.navigationController pushViewController:shop animated:YES];
            break;
        }
        case 3:{
            //多聊
            NSLog(@"多聊");
            KxMenuItem * item1 = [KxMenuItem menuItem:@"多聊消息" image:nil target:self action:@selector(menuSelected:) index:100];
            item1.foreColor = UIColorFromRGB(0x585858);
            KxMenuItem * item2 = [KxMenuItem menuItem:@"一肉一拍" image:nil target:self action:@selector(menuSelected:) index:101];
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
                    chat_badge = [[JSBadgeView alloc]initWithParentView:targetlabel alignment:JSBadgeViewAlignmentCenterRight];
                    chat_badge.badgeBackgroundColor = UIColorFromRGB(0xe21a54);
                    chat_badge.badgeTextFont = FONT(10.0);
                    chat_badge.badgeText = @"99";
                    break;
                }
            }

            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 点击左下角分类
- (void)menuClassSelected:(id)sender{
    KxMenuItem * item = (KxMenuItem *)sender;
}
#pragma mark - 点击右下角聊天
- (void)menuSelected:(id)sender{
    KxMenuItem * item = (KxMenuItem *)sender;
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
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
        cell.delegate = self;
    }
    
    if(indexPath.row*3 < dataArr.count){
        cell.leftPrice.hidden = NO;
        cell.leftImg.hidden = NO;
        cell.leftName.hidden = NO;
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3];
        NSString * _price = [NSString stringWithFormat:@"¥%@",model.content_price];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:_price];
        [oneAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 1)];
        cell.leftPrice.attributedText = oneAttributeStr;
        cell.leftName.text = model.content_name;
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
        NSString * _price = [NSString stringWithFormat:@"¥%@",model.content_price];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:_price];
        [oneAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 1)];
        cell.centerPrice.attributedText = oneAttributeStr;
        cell.centerName.text = model.content_name;
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
        NSString * _price = [NSString stringWithFormat:@"¥%@",model.content_price];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:_price];
        [oneAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 1)];
        cell.rightPrice.attributedText = oneAttributeStr;
        cell.rightName.text = model.content_name;
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
    return 150.0;
}

- (void)jumpPlantDetailsWithImage:(RMImageView *)image {
    RMPlantWithSaleDetailsViewController * plantWithSaleDetailsCtl = [[RMPlantWithSaleDetailsViewController alloc] init];
    plantWithSaleDetailsCtl.auto_id = image.identifierString;
    [self.navigationController pushViewController:plantWithSaleDetailsCtl animated:YES];
}

#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
        isRefresh = YES;
        isLoadComplete = NO;
        [self requestDataWithPageCount];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        if (isLoadComplete){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.44 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showHint:@"没有更多肉肉啦"];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            });
        }else{
            pageCount ++;
            isRefresh = NO;
            [self requestDataWithPageCount];
        }
        
    }
}

- (void)requestDataWithPageCount{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//这里有问题，需要修改
    [RMAFNRequestManager myCollectionRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Type:@"3" Page:pageCount andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            if(pageCount == 1){
                [dataArr removeAllObjects];
                [dataArr addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
                if([object count] == 0){
                    [self showHint:@"暂无宝贝"];
                    
                }
            }else{
                [dataArr addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                if([object count] == 0){
                    [self showHint:@"没有更多宝贝了"];
                    pageCount--;
                }
            }
            
            
        }else{
            [self showHint:object];
        }
        
        [_mainTableview reloadData];
    }];
    
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
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
