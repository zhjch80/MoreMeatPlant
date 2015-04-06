//
//  RMMyCollectionViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMMyCollectionViewController.h"
#import "RMReleasePoisonDetailsViewController.h"
#import "RMPlantWithSaleDetailsViewController.h"
#import "RMMyCorpViewController.h"
@interface RMMyCollectionViewController ()

@end

@implementation RMMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"我的收藏"];
    
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];

    
    __block RMMyCollectionViewController * SELF = self;
    
    current_index = 0;
    postCollectionController = [[RMPostCollectionViewController alloc]initWithNibName:@"RMPostCollectionViewController" bundle:nil];
    postCollectionController.view.frame = CGRectMake(0, _operationView.frame.origin.y+_operationView.frame.size.height, kScreenWidth, kScreenHeight-( _operationView.frame.origin.y+_operationView.frame.size.height));
    postCollectionController.mainTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-( _operationView.frame.origin.y+_operationView.frame.size.height));
    postCollectionController.detailcall_back = ^ (NSString * auto_id){
        RMReleasePoisonDetailsViewController * releasePoisonDetailsCtl = [[RMReleasePoisonDetailsViewController alloc] init];
        releasePoisonDetailsCtl.auto_id = auto_id;
        [SELF.navigationController pushViewController:releasePoisonDetailsCtl animated:YES];
    };
    
    
    plantCollectionController = [[RMPlantCollectionViewController alloc]initWithNibName:@"RMPlantCollectionViewController" bundle:nil];
    plantCollectionController.view.frame = CGRectMake(0, _operationView.frame.origin.y+_operationView.frame.size.height, kScreenWidth, kScreenHeight-( _operationView.frame.origin.y+_operationView.frame.size.height));
    plantCollectionController.mainTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-( _operationView.frame.origin.y+_operationView.frame.size.height));
    plantCollectionController.detailcall_back = ^(NSString * auto_id){
        RMPlantWithSaleDetailsViewController * plantWithSaleDetailsCtl = [[RMPlantWithSaleDetailsViewController alloc] init];
        plantWithSaleDetailsCtl.auto_id = auto_id;
        [SELF.navigationController pushViewController:plantWithSaleDetailsCtl animated:YES];
    };
    
    corpCollectionController = [[RMCorpCollectionViewController alloc]initWithNibName:@"RMCorpCollectionViewController" bundle:nil];
    corpCollectionController.view.frame = CGRectMake(0, _operationView.frame.origin.y+_operationView.frame.size.height, kScreenWidth, kScreenHeight-( _operationView.frame.origin.y+_operationView.frame.size.height));
    corpCollectionController.mainTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-( _operationView.frame.origin.y+_operationView.frame.size.height));
    corpCollectionController.detailcall_back = ^ (NSString * auto_id){
        RMMyCorpViewController * corp = [[RMMyCorpViewController alloc]initWithNibName:@"RMMyCorpViewController" bundle:nil];
        corp.auto_id = auto_id;
        [SELF.navigationController pushViewController:corp animated:YES];
    };
    
    [self.view addSubview:corpCollectionController.view];
    [self.view addSubview:postCollectionController.view];
    [self.view addSubview:plantCollectionController.view];
    
    corpCollectionController.view.hidden = YES;
    postCollectionController.view.hidden = YES;
    
    [_plantBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchDown];
    [_postBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchDown];
    [_corpBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchDown];
    _plantBtn.tag = 100;
    _postBtn.tag = 101;
    _corpBtn.tag = 102;
    
}


- (void)selectedAction:(UIButton *)sender{
    
    [_postBtn setTitleColor:UIColorFromRGB(0xef93aa) forState:UIControlStateNormal];
    [_plantBtn setTitleColor:UIColorFromRGB(0xef93aa) forState:UIControlStateNormal];
    [_corpBtn setTitleColor:UIColorFromRGB(0xef93aa) forState:UIControlStateNormal];
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    
    [UIView animateWithDuration:0.3 animations:^{
        switch (sender.tag-100) {
            case 0:
            {
                //肉肉
                plantCollectionController.view.hidden = NO;
                corpCollectionController.view.hidden = YES;
                postCollectionController.view.hidden = YES;
            }
                break;
            case 1:
            {
                //帖子
                plantCollectionController.view.hidden = YES;
                corpCollectionController.view.hidden = YES;
                postCollectionController.view.hidden = NO;
            }
                break;
            case 2:
            {
                //店铺
                plantCollectionController.view.hidden = YES;
                corpCollectionController.view.hidden = NO;
                postCollectionController.view.hidden = YES;
            }
                break;
            default:
                break;
        }

    }];
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
