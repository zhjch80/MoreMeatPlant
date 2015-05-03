//
//  RMBabyManageViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBabyManageViewController.h"
#import "KxMenu.h"
@interface RMBabyManageViewController (){
    NSMutableArray * classArray;
}

@end

@implementation RMBabyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"宝贝管理"];
    
    classArray = [[NSMutableArray alloc]init];
    
    [rightTwoBarButton setTitle:@"发布" forState:UIControlStateNormal];
    rightTwoBarButton.titleLabel.font = FONT_1(15);
    [rightTwoBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    all_Ctl = [[RMBabyListViewController alloc] initWithNibName:@"RMBabyListViewController" bundle:nil];
    all_Ctl.view.frame = CGRectMake(0, 64+40, kScreenWidth, kScreenHeight);
    all_Ctl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40);
    all_Ctl.is_shelf = nil;
    all_Ctl.member_class = nil;
    [self.view addSubview:all_Ctl.view];
    [all_Ctl requestDataWithPageCount:1];
    
    
    __block RMBabyManageViewController * SELF = self;
    all_Ctl.modifycallback = ^(RMPublicModel *model){
        RMPublishBabyViewController * publish = [[RMPublishBabyViewController alloc]initWithNibName:@"RMPublishBabyViewController" bundle:nil];
        publish.auto_id = model.auto_id;
        publish.publishCompleted = ^(void){
            [SELF->all_Ctl requestDataWithPageCount:1];
        };
        [SELF.navigationController pushViewController:publish animated:YES];
    };
    
    
    ware_Ctl = [[RMBabyListViewController alloc]initWithNibName:@"RMBabyListViewController" bundle:nil];
    ware_Ctl.view.frame = CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-40);
    ware_Ctl.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40);
    ware_Ctl.is_shelf = @"0";
    ware_Ctl.member_class = nil;
    [self.view addSubview:ware_Ctl.view];
    [ware_Ctl requestDataWithPageCount:1];
    ware_Ctl.view.hidden = YES;
    

    [_all_baby_btn addTarget:self action:@selector(all_babyAction:) forControlEvents:UIControlEventTouchDown];
    
    [_warehouse_baby_btn addTarget:self action:@selector(warehouse_baby_btnAction:) forControlEvents:UIControlEventTouchDown];
    [_class_baby_btn addTarget:self action:@selector(class_baby_btnAction:) forControlEvents:UIControlEventTouchDown];
    [self requestMemberClass];
}


- (void)all_babyAction:(UIButton *)sender{
    all_Ctl.view.hidden = NO;
    ware_Ctl.view.hidden = YES;
    all_Ctl.member_class = nil;
    
    [all_Ctl requestDataWithPageCount:1];
}

- (void)warehouse_baby_btnAction:(UIButton *)sender{
    all_Ctl.view.hidden = YES;
    ware_Ctl.view.hidden = NO;
}

- (void)class_baby_btnAction:(UIButton *)sender{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂未开通，敬请期待！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
//    [alert show];
    all_Ctl.view.hidden = NO;
    ware_Ctl.view.hidden = YES;
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for(int i = 0;i<[classArray count];i++){
        RMPublicModel * model = [classArray objectAtIndex:i];
        KxMenuItem * item = [KxMenuItem menuItem:model.content_name image:nil target:self action:@selector(menuClassSelected:) index:100+i];
        item.foreColor = UIColorFromRGB(0x585858);
        [arr addObject:item];
    }
    
    [KxMenu setTintColor:[UIColor whiteColor]];
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(_class_baby_btn.frame.origin.x, _class_baby_btn.frame.size.height+20, _class_baby_btn.frame.size.width, _class_baby_btn.frame.size.height)  menuItems:arr];
}

- (void)menuClassSelected:(KxMenuItem *)sender{
    KxMenuItem * item = (KxMenuItem *)sender;
    RMPublicModel * model = [classArray objectAtIndex:item.tag-100];
    if(!all_Ctl.view.hidden){
        all_Ctl.member_class = model.auto_id;
        [all_Ctl requestDataWithPageCount:1];
    }else{
//        [ware_Ctl requestDataWithPageCount:1];
        
    }
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


#pragma mark - 请求分类
- (void)requestMemberClass{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager corpbabyClassRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
                [classArray addObjectsFromArray:object];
        }else{
            [self showHint:object];
        }
    }];
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
