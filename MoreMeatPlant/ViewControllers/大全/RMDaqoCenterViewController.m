//
//  RMDaqoCenterViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMDaqoCenterViewController.h"
#import "RMPlantTypeView.h"
#import "RMDaqoCell.h"
#import "RMDaqoDetailsViewController.h"
#import "RMDaqoViewController.h"
#import "RMSearchViewController.h"
#import "RMSlideParameter.h"
#import "RefreshControl.h"
#import "RefreshView.h"

@interface RMDaqoCenterViewController ()<UITableViewDataSource, UITableViewDelegate, SelectedPlantTypeMethodDelegate,DaqpSelectedPlantTypeDelegate,RefreshControlDelegate>{
    BOOL isRefresh;
    NSInteger pageCount;
    BOOL isLoadComplete;
}
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) NSMutableArray * subsPlantArr;
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) RefreshControl * refreshControl;
@property (nonatomic, strong) RMPlantTypeView * plantTypeView;
@property (nonatomic, copy) NSString * plantClassification;         //选择植物分类
@property (nonatomic, copy) NSString * currentPlantSubjects;        //当前植物科目
@property (nonatomic, copy) NSString * currentPlantGrow;            //当前植物生长季

@end

@implementation RMDaqoCenterViewController
@synthesize mTableView, dataArr, refreshControl, subsPlantArr, plantTypeView, plantClassification, currentPlantSubjects, currentPlantGrow;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    plantClassification = @"";
    currentPlantSubjects = @"";
    currentPlantGrow = @"";
    
    [self setRightBarButtonNumber:1];
    leftBarButton.frame = CGRectMake(5, 1, 43, 43);
    [leftBarButton setImage:[UIImage imageNamed:@"img_search"] forState:UIControlStateNormal];
    [rightOneBarButton setImage:[UIImage imageNamed:@"img_RightArrow"] forState:UIControlStateNormal];
    [rightOneBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -40)];
    [rightOneBarButton setTitle:@"分类" forState:UIControlStateNormal];
    [rightOneBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 10)];
    [rightOneBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setCustomNavTitle:@"全部肉肉"];
    
    dataArr = [[NSMutableArray alloc] init];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, plantTypeView.frame.size.height + 64 , kScreenWidth, kScreenHeight - plantTypeView.frame.size.height - 64 - 42) style:UITableViewStylePlain];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.62 alpha:1];
    [self.view addSubview:mTableView];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:mTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];

    pageCount = 1;
    isRefresh = YES;
    
    [self loadRecognizerView];
}

#pragma mark - center 手势管理

- (void)loadRecognizerView {
    self.recognizerView = [[UIView alloc] init];
    self.recognizerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.recognizerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.recognizerView];
    self.recognizerView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manageUserInteractionEnabled)];
    tap.numberOfTapsRequired = 1;
    [self.recognizerView addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer * swipDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipDirectionMethod:)];
    [swipDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.recognizerView addGestureRecognizer:swipDown];
    
    UISwipeGestureRecognizer * swipUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipDirectionMethod:)];
    [swipUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.recognizerView addGestureRecognizer:swipUp];
    
    UISwipeGestureRecognizer * swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipDirectionMethod:)];
    [swipLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.recognizerView addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer * swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipDirectionMethod:)];
    [swipRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.recognizerView addGestureRecognizer:swipRight];
}


- (void)manageUserInteractionEnabled {
    RMDaqoViewController * daqoCtl = self.DaqoDelegate;
    [daqoCtl updateSlideSwitchState];
}

- (void)swipDirectionMethod:(UISwipeGestureRecognizer *)swip {
    RMDaqoViewController * daqoCtl = self.DaqoDelegate;
    [daqoCtl updataSlideStateClose];
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
    static NSString * identifierStr = @"DaqoidentifierStr";
    RMDaqoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (!cell){
        if (IS_IPHONE_6p_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoCell_6p" owner:self options:nil] lastObject];
        }else if (IS_IPHONE_6_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoCell_6" owner:self options:nil] lastObject];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    
    if(indexPath.row*3 < dataArr.count){
        cell.leftTitle.hidden = NO;
        cell.leftImg.hidden = NO;
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3];
        cell.leftTitle.text = @"";
        cell.leftTitle.text = model.content_name;
        cell.leftImg.image = NULL;
        [cell.leftImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:[UIImage imageNamed:@"img_default.jpg"]];
        cell.leftImg.identifierString = model.auto_id;
    }else{
        cell.leftTitle.hidden = YES;
        cell.leftImg.hidden = YES;
    }
    if(indexPath.row*3+1 < dataArr.count){
        cell.centerTitle.hidden = NO;
        cell.centerImg.hidden = NO;
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3+1];
        cell.centerTitle.text = @"";
        cell.centerTitle.text = model.content_name;
        cell.centerImg.image = NULL;
        [cell.centerImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:[UIImage imageNamed:@"img_default.jpg"]];
        cell.centerImg.identifierString = model.auto_id;
    }else{
        cell.centerTitle.hidden = YES;
        cell.centerImg.hidden = YES;
    }
    if(indexPath.row*3+2 < dataArr.count){
        cell.rightTitle.hidden = NO;
        cell.rightImg.hidden = NO;
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3+2];
        cell.rightTitle.text = @"";
        cell.rightTitle.text = model.content_name;
        cell.rightImg.image = NULL;
        [cell.rightImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:[UIImage imageNamed:@"img_default.jpg"]];
        cell.rightImg.identifierString = model.auto_id;
    }else{
        cell.rightTitle.hidden = YES;
        cell.rightImg.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            RMDaqoViewController * daqoCtl = self.DaqoDelegate;
            RMSearchViewController * searchCtl = [[RMSearchViewController alloc] init];
            searchCtl.searchType = @"大全";
            [daqoCtl.navigationController pushViewController:searchCtl animated:YES];
            break;
        }
        case 2:{
            RMDaqoViewController * daqoCtl = self.DaqoDelegate;
            [daqoCtl updateSlideSwitchState];
            break;
        }
            
        default:
            break;
    }
}

- (void)selectedPlantWithType:(NSString *)type {

    if ([type isEqualToString:@"0"]){
        plantClassification = @"10000";
    }else{
        plantClassification = type;
    }
    
    if ([plantClassification isEqualToString:@"10000"] | [plantClassification isEqualToString:@""]){
        currentPlantSubjects = @"";
    }else{
        RMPublicModel * model_1 = [subsPlantArr objectAtIndex:plantClassification.integerValue];
        currentPlantSubjects = model_1.auto_code;
    }
    
    isRefresh = YES;
    [self requestDataWithPageCount:1 withPlantType:currentPlantSubjects withGrow:currentPlantGrow];
}

- (void)daqoSelectedPlantTypeMethod:(RMImageView *)image {
    RMDaqoViewController * daqoCtl = self.DaqoDelegate;
    RMDaqoDetailsViewController * daqoDetailsCtl = [[RMDaqoDetailsViewController alloc] init];
    daqoDetailsCtl.auto_id = image.identifierString;
    [daqoCtl.navigationController pushViewController:daqoDetailsCtl animated:YES];
}

- (void)updateCurrentList:(RMPublicModel *)model withRow:(NSInteger)row {
    currentPlantGrow = @"";
    currentPlantSubjects = @"";
    isRefresh = YES;

    if (row == -1){
        //header
        if ([model.isGrow isEqualToString:@"YES"]){
            currentPlantGrow = model.auto_code;
        }else{
            currentPlantSubjects = model.auto_code;
        }
        [self requestDataWithPageCount:1 withPlantType:currentPlantSubjects withGrow:currentPlantGrow];
    }else if (row == -2){
        //刷新全部
        [self requestDataWithPageCount:1 withPlantType:currentPlantSubjects withGrow:currentPlantGrow];
    }else{
        //二级分类
        currentPlantSubjects = model.auto_code;
        [self requestDataWithPageCount:1 withPlantType:currentPlantSubjects withGrow:currentPlantGrow];
    }
    [plantTypeView updataSelectState:0];
}

#pragma mark -  数据请求

/**
 *  @method     获取顶部分类
 */
- (void)requestPlantSubjects {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPlantSubjectsListWithLevel:1 callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            subsPlantArr = [[NSMutableArray alloc] init];
            
            RMPublicModel * _model = [[RMPublicModel alloc] init];
            [subsPlantArr addObject:_model];
//            if([[object objectForKey:@"data"] isKindOfClass:[NSArray class]]){
                for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++){
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_code = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_code"]);
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.change_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"change_img"]);
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.modules_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"modules_name"]);
                    [subsPlantArr addObject:model];
                }
//            }
            
            
            CGFloat offsetY = 0;
            if (IS_IPHONE_6p_SCREEN) {
                offsetY = 70;
            }else if (IS_IPHONE_6_SCREEN){
                offsetY = 65;
            }else{
                offsetY = 55;
            }
            
            plantTypeView = [[RMPlantTypeView alloc] init];
            plantTypeView.frame = CGRectMake(0, 64, kScreenWidth, offsetY);
            plantTypeView.delegate = self;
            plantTypeView.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.62 alpha:1];
            [plantTypeView loadPlantTypeWithImageArr:subsPlantArr];
            [self.view insertSubview:plantTypeView belowSubview:self.recognizerView];
            
            [UIView animateWithDuration:0.3 animations:^{
                mTableView.frame = CGRectMake(0, plantTypeView.frame.size.height + 60, kScreenWidth, kScreenHeight - plantTypeView.frame.size.height - 64 - 42);
            } completion:^(BOOL finished) {
            }];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

/**
 *  @method     获取list数据
 *  @param      pc                  分页
 *  @param      plantType           植物科目
 *  @param      grow                生长季
 */
- (void)requestDataWithPageCount:(NSInteger)pc
                   withPlantType:(NSString *)plantType
                        withGrow:(NSString *)grow {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPlantDaqoListWithSubPlantClassification:plantType withPageCount:pc withGrow:grow callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
        }
        
        if (success) {
            if (self.refreshControl.refreshingDirection == RefreshingDirectionTop) {
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
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
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            }
            
            if (isRefresh){
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
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
        
        [self requestDataWithPageCount:1 withPlantType:currentPlantSubjects withGrow:currentPlantGrow];
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
            
            [self requestDataWithPageCount:pageCount withPlantType:currentPlantSubjects withGrow:currentPlantGrow];
        }
    }
}

/**
 *  @method     获取大全 全部肉肉 总数量
 */
- (void)requestDaqoAllCounts {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getDaqoAllcountscallBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            NSString * counts = [[object objectForKey:@"data"] objectForKey:@"counts"];
            [self setCustomNavTitle:[NSString stringWithFormat:@"全部肉肉(%@)",counts]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

@end
