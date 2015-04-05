//
//  RMBabyManageViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBabyManageViewController.h"

@interface RMBabyManageViewController ()

@end

@implementation RMBabyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"宝贝管理"];
    
    [rightTwoBarButton setTitle:@"发布" forState:UIControlStateNormal];
    rightTwoBarButton.titleLabel.font = FONT_1(15);
    [rightTwoBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    all_Ctl = [[RMBabyListViewController alloc]initWithNibName:@"RMBabyListViewController" bundle:nil];
    all_Ctl.view.frame = CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-44);
    all_Ctl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44);
    [self.view addSubview:all_Ctl.view];
    
    
    __block RMBabyManageViewController * SELF = self;
    all_Ctl.modifycallback = ^(RMPublicModel *model){
        RMPublishBabyViewController * publish = [[RMPublishBabyViewController alloc]initWithNibName:@"RMPublishBabyViewController" bundle:nil];
        publish.auto_id = model.auto_id;
        publish.publishCompleted = ^(void){
            [SELF->all_Ctl requestDataWithPageCount:1];
        };
        [SELF.navigationController pushViewController:publish animated:YES];
    };
    
    
//    ware_Ctl = [[RMBabyListViewController alloc]initWithNibName:@"RMBabyListViewController" bundle:nil];
//    ware_Ctl.view.frame = CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-44);
//    ware_Ctl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44);
//    
//    class_Ctl = [[RMBabyListViewController alloc]initWithNibName:@"RMBabyListViewController" bundle:nil];
//    class_Ctl.view.frame = CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-44);
//    class_Ctl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44);
    [_warehouse_baby_btn addTarget:self action:@selector(warehouse_baby_btnAction:) forControlEvents:UIControlEventTouchDown];
    [_class_baby_btn addTarget:self action:@selector(class_baby_btnAction:) forControlEvents:UIControlEventTouchDown];
}


- (void)warehouse_baby_btnAction:(UIButton *)sender{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂未开通，敬请期待！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
    [alert show];
}

- (void)class_baby_btnAction:(UIButton *)sender{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂未开通，敬请期待！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
    [alert show];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    switch (sender.tag) {
        case 1:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            RMPublishBabyViewController * publish = [[RMPublishBabyViewController alloc]initWithNibName:@"RMPublishBabyViewController" bundle:nil];
            publish.publishCompleted = ^(void){
                [self->all_Ctl requestDataWithPageCount:1];
            };
            [self.navigationController pushViewController:publish animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
