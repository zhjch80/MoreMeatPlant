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

@interface RMPlantWithSaleDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,BottomDelegate,PlantWithSaleHeaderViewDelegate,PlantWithSaleDetailsDelegate>{
    
}
@property (nonatomic, strong) RMPlantWithSaleHeaderView * headerView;;
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;

@end

@implementation RMPlantWithSaleDetailsViewController
@synthesize headerView, mTableView, dataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataArr = [[NSMutableArray alloc] init];
    
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    [self loadHeaderView];
    
    [self loadBottomView];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 40) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [self.view addSubview:mTableView];
    
    
}

- (void)loadHeaderView {
    headerView = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleHeaderView" owner:nil options:nil] objectAtIndex:0];
    headerView.delegate = self;
    [headerView.userHeader.layer setCornerRadius:20.0f];
    [self.view addSubview:headerView];
}

- (void)intoShopMethodWithBtn:(UIButton *)button {
    NSLog(@"进店");
}

- (void)loadBottomView {
    RMBottomView * bottomView = [[RMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    [bottomView loadPlantWithSaleDetailsBottomView];
    [self.view addSubview:bottomView];
}

- (void)plantWithSaleDetailsBottomMethodWithTag:(NSInteger)tag {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
