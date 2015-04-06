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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMPlantWithSaleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPlantWithSaleCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
        cell.delegate = self;
    }
    cell.leftPrice.text = @" ¥560";
    cell.centerPrice.text = @" ¥240";
    cell.rightPrice.text = @" ¥360";
    
    cell.leftName.text = @" 极品雪莲";
    cell.centerName.text = @" 桃美人";
    cell.rightName.text = @" 极品亚美奶酪";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0;
}

- (void)jumpPlantDetailsWithImage:(RMImageView *)image{
    RMPlantWithSaleDetailsViewController * plantWithSaleDetailsCtl = [[RMPlantWithSaleDetailsViewController alloc] init];
    [self.navigationController pushViewController:plantWithSaleDetailsCtl animated:YES];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 刷新代理
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
        isRefresh = YES;
        isLoadComplete = NO;
        //        [self requestDataWithPageCount:1];
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
            //            [self requestDataWithPageCount:pageCount];
        }
        
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
