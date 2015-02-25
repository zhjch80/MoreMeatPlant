//
//  RMNearbyMerchantViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMNearbyMerchantViewController.h"

@interface RMNearbyMerchantViewController ()

@end

@implementation RMNearbyMerchantViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setCustomNavTitle:@"附近商家"];
    
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
