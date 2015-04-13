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
    [self.mTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view endEditing:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"升级建议"];
    self.mScro.frame = CGRectMake(0, 64, kScreenWidth, 200);
    self.mTextField.frame = CGRectMake(5, 5, kScreenWidth - 10, 30);
    self.mTextView.frame = CGRectMake(5, 45, kScreenWidth - 10, 180);
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[RMUpgradeSuggestViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[RMUpgradeSuggestViewController class]];
    
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
            [self requestUpgradeSuggestionsWithTitle:self.mTextField.text withContent:self.mTextView.text];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 数据请求

- (void)requestUpgradeSuggestionsWithTitle:(NSString *)title withContent:(NSString *)content {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager postAnonymousSubmissionsUpgradeSuggestionsWithContent_title:[title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withContent_body:[content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self.mTextField resignFirstResponder];
            [self.mTextView resignFirstResponder];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
