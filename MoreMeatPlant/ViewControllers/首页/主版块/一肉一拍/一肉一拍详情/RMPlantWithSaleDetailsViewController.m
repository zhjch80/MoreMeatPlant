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

@interface RMPlantWithSaleDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,BottomDelegate,PlantWithSaleHeaderViewDelegate,PlantWithSaleDetailsDelegate>{
    BOOL isFirstViewDidAppear;
    BOOL isRefresh;
    NSInteger pageCount;
    BOOL isLoadComplete;
}
@property (nonatomic, strong) RMPlantWithSaleHeaderView * headerView;;
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) CycleScrollView * cycleView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) NSMutableArray * topDataArr;
@property (nonatomic, strong) RMBaseView * footerView;
@property (nonatomic, strong) RMPublicModel * dataModel;

@end

@implementation RMPlantWithSaleDetailsViewController
@synthesize headerView, mTableView, dataArr, cycleView, topDataArr, footerView, auto_id, dataModel;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isFirstViewDidAppear){
        [self requestDetals];
        isFirstViewDidAppear = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataArr = [[NSMutableArray alloc] initWithObjects:@"", nil];
    topDataArr = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", nil];
    
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    [self loadBottomView];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 40) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
}

- (void)loadTableHeaderView {
    if ([topDataArr count] == 1){
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        image.userInteractionEnabled = YES;
        image.backgroundColor = [UIColor yellowColor];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
        title.backgroundColor = [UIColor clearColor];
        title.userInteractionEnabled = YES;
        title.numberOfLines = 1;
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont boldSystemFontOfSize:24.0];
        title.text = [NSString stringWithFormat:@"page index: %d",1];
        title.adjustsFontSizeToFitWidth = YES;
        [title sizeToFit];
        title.center = image.center;
        [image addSubview:title];
        
        mTableView.tableHeaderView = image;
    }else{
        NSMutableArray *displayArr = [@[] mutableCopy];
        
        for (NSInteger i=0; i<[topDataArr count]; i++) {
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
            image.userInteractionEnabled = YES;
            image.backgroundColor = [UIColor cyanColor];
            
            UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
            title.backgroundColor = [UIColor clearColor];
            title.userInteractionEnabled = YES;
            title.numberOfLines = 1;
            title.textColor = [UIColor whiteColor];
            title.font = [UIFont boldSystemFontOfSize:24.0];
            title.text = [NSString stringWithFormat:@"page index: %ld",(long)i];
            title.adjustsFontSizeToFitWidth = YES;
            [title sizeToFit];
            title.center = image.center;
            [image addSubview:title];
            
            [displayArr addObject:image];
        }
        
        __block RMPlantWithSaleDetailsViewController * blockSelf = self;
        
        cycleView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) animationDuration:3];
        cycleView.backgroundColor = [UIColor whiteColor];
        cycleView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return displayArr[pageIndex];
        };
        self.cycleView.totalPagesCount = ^NSInteger(void){
            return [blockSelf.topDataArr count];
        };
        self.cycleView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"select index %ld",(long)pageIndex);
        };
        mTableView.tableHeaderView = self.cycleView;
    }
}

- (void)loadTableFooterView {
    footerView = [[[NSBundle mainBundle] loadNibNamed:@"RMBaseView" owner:nil options:nil] objectAtIndex:0];
    
    __block CGFloat offsetY = 0;
    
    if ([dataModel.body isKindOfClass:[NSNull class]]){
        
    }else{
        for (NSInteger i=0; i<[dataModel.body count]; i++) {
            UIImageView * imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseHeaderUrl,[[dataModel.body objectAtIndex:i] objectForKey:@"content_img"]]] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [imageView setFrame:CGRectMake(5, offsetY + 20, kScreenWidth - 10, image.size.height)];
                offsetY = offsetY + imageView.frame.size.height + 30;
                footerView.frame = CGRectMake(0, 0, kScreenWidth, offsetY);
                mTableView.tableFooterView = footerView;
            }];
            [footerView addSubview:imageView];
        }
    }
}

#pragma mark -

- (void)loadHeaderView {
    headerView = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleHeaderView" owner:nil options:nil] objectAtIndex:0];
    headerView.delegate = self;
    [headerView.userHeader.layer setCornerRadius:20.0f];
    headerView.userHeader.clipsToBounds = YES;
    [headerView.userHeader sd_setImageWithURL:[NSURL URLWithString:[dataModel.members objectForKey:@"content_face"]] placeholderImage:nil];
    headerView.userName.text = [dataModel.members objectForKey:@"member_name"];
    headerView.userLocation.text = @"正在定位. . .";
    [self.view addSubview:headerView];
}

- (void)intoShopMethodWithBtn:(UIButton *)button {
    NSLog(@"进店");
}

- (void)loadBottomView {
    RMBottomView * bottomView = [[RMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_backup", @"img_collectiom", @"img_buy", @"img_share", nil]];
    [self.view addSubview:bottomView];
}

- (void)bottomMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 0:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            
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
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleDetailsCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0f;
}

- (void)plantWithSaleCellMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 101:{
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            RMPlantWithSaleDetailsCell * cell = (RMPlantWithSaleDetailsCell *)[mTableView cellForRowAtIndexPath:indexPath];
            NSInteger num = [[NSString stringWithFormat:@"%@",cell.showNum.text] integerValue];
            if (num <= 0){
            }else{
                num--;
            }
            cell.showNum.text = [NSString stringWithFormat:@"%ld",(long)num];
            break;
        }
        case 102:{
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            RMPlantWithSaleDetailsCell * cell = (RMPlantWithSaleDetailsCell *)[mTableView cellForRowAtIndexPath:indexPath];
            NSInteger num = [[NSString stringWithFormat:@"%@",cell.showNum.text] integerValue];
            if (num > 9){
            }else{
                num++;
            }
            cell.showNum.text = [NSString stringWithFormat:@"%ld",(long)num];
            break;
        }
        case 103:{
            NSLog(@"立即购买auto_id:%@",self.auto_id);
            break;
        }
        case 104:{
            NSLog(@"加入购物车auto_id:%@",self.auto_id);
            break;
        }
        case 105:{
            NSLog(@"联系掌柜auto_id:%@",self.auto_id);
            break;
        }
            
        default:
            break;
    }
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
