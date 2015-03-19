//
//  RMFreshPlantMarketDetailsViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMFreshPlantMarketDetailsViewController.h"

@interface RMFreshPlantMarketDetailsViewController ()

@end

@implementation RMFreshPlantMarketDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"鲜肉市场详情界面"];
    
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
