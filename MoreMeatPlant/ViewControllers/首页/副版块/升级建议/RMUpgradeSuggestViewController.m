//
//  RMUpgradeSuggestViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMUpgradeSuggestViewController.h"

@interface RMUpgradeSuggestViewController ()<UIWebViewDelegate>{
    BOOL isFirstAppear;
}

@end

@implementation RMUpgradeSuggestViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"升级建议"];
    
    [self setRightBarButtonNumber:1];
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];

    [rightOneBarButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightOneBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.mTextView.layer setCornerRadius:8.0f];
    self.mTextView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    isFirstAppear = YES;
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 2:{
            NSLog(@"提交");
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
