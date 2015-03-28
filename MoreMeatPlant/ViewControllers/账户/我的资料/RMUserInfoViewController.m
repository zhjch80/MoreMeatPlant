//
//  RMUserInfoViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMUserInfoViewController.h"

@interface RMUserInfoViewController ()

@end

@implementation RMUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [_editBtn addTarget:self action:@selector(operation:) forControlEvents:UIControlEventTouchDown];
    [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchDown];
    [_modifyBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchDown];
    
}

#pragma mark - 修改密码
- (void)modifyAction:(UIButton *)sender{
    if(self.modify_callback){
        _modify_callback (self);
    }
}

- (void)operation:(UIButton *)sender{
    if(self.callback){
        _callback(self);
    }
}

- (void)closeAction:(UIButton *)sender{
    if(self.close_action){
        _close_action(self);
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
