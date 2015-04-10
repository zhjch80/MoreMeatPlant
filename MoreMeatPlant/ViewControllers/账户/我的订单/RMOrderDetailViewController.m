//
//  RMOrderDetailViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/22.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMOrderDetailViewController.h"
#import "RMOrderHeadTableViewCell.h"
#import "RMOrderDetailProTableViewCell.h"
#import "RMOrderDetailNumTableViewCell.h"
#import "RMOrderDetailEvaluateTableViewCell.h"
#import "RMOederDetailOperationTableViewCell.h"
#import "RMOrderReturnEditView.h"
@interface RMOrderDetailViewController (){
    RMOrderReturnEditView * returnEditView;
}

@end

@implementation RMOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"订单详情"];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
//    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.mTableView];
    [self showReturnEditView];
}

- (void)showReturnEditView{
    
    UIControl * cover = [[UIControl alloc]initWithFrame:_mTableView.frame];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction:)];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.25;
    cover.tag = 101311;
    [cover addGestureRecognizer:tap];
    [self.view addSubview:cover];
    
    if(returnEditView == nil){
        returnEditView = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderReturnEditView" owner:self options:nil] lastObject];
        returnEditView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 206);
    }

    
    [UIView animateWithDuration:0.3 animations:^{
        
               returnEditView.frame = CGRectMake(0, kScreenHeight-206, kScreenWidth, 206);

        [self.view addSubview:returnEditView];
    }];
}

- (void)dismissAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.3 animations:^{
        UIControl * cover = (UIControl *)[self.view viewWithTag:101311];
        [cover removeFromSuperview];
        returnEditView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 206);
        returnEditView.expressName.text = nil;
        returnEditView.express_price.text = nil;//这里实际上是快递单号，不是价格，
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        RMOrderHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderHeadTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderHeadTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else if (indexPath.row == 3){
        RMOrderDetailNumTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderDetailNumTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderDetailNumTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else if (indexPath.row == 4){
        RMOrderDetailEvaluateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderDetailEvaluateTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderDetailEvaluateTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else if (indexPath.row == 5){
        RMOederDetailOperationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOederDetailOperationTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOederDetailOperationTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else{
        RMOrderDetailProTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderDetailProTableViewCell"];
        if(cell == nil){
            cell =[[[NSBundle mainBundle] loadNibNamed:@"RMOrderDetailProTableViewCell" owner:self options:nil] lastObject];
            [cell.returnBtn addTarget:self action:@selector(iWantToReturn:) forControlEvents:UIControlEventTouchDown];
        }
        
        if(/* DISABLES CODE */ (1)){
            cell.fieldHeght.constant = 0;
        }else{
            cell.fieldHeght.constant = 30;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 30;
    }else if (indexPath.row == 3){
        return 38;
    }else if (indexPath.row == 4){
        return 36;
    }else if (indexPath.row == 5){
        return 40;
    }else{
        if(1){
            return 80;
        }else{
            return 110;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)iWantToReturn:(UIButton *)sender{
    [self showReturnEditView];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
