//
//  RMPlantWithSaleDetailsViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantWithSaleDetailsViewController.h"
#import "RMPlantWithSaleHeaderView.h"
#import "RMPlantWithSaleBottomView.h"

@interface RMPlantWithSaleDetailsViewController ()<PlantWithSaleBottomDelegate,PlantWithSaleHeaderViewDelegate>{
    
}
@property (nonatomic, strong) RMPlantWithSaleHeaderView * headerView;;

@end

@implementation RMPlantWithSaleDetailsViewController
@synthesize headerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    [self loadHeaderView];
    
    [self loadBottomView];
    
    
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
    RMPlantWithSaleBottomView * plantWithSaleBottomVie = [[RMPlantWithSaleBottomView alloc] init];
    plantWithSaleBottomVie.delegate = self;
    plantWithSaleBottomVie.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    [plantWithSaleBottomVie loadPlantWithSaleDetailsBottomView];
    [self.view addSubview:plantWithSaleBottomVie];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
