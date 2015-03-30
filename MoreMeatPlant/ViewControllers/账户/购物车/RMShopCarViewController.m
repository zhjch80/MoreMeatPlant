//
//  RMShopCarViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/9.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMShopCarViewController.h"
#import "RMShopCarGoodsTableViewCell.h"
#import "RMSopCarHeadTableViewCell.h"
#import "RMShopLeaveMsTableViewCell.h"

#import "RMSettlementViewController.h"
#import "UIViewController+ENPopUp.h"

#import "RMAddressEditViewController.h"
#import "RMMyCorpViewController.h"
#import "UIView+Expland.h"
@interface RMShopCarViewController (){
    BOOL isShow;
}

@end

@implementation RMShopCarViewController

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initPlat];
}

- (void)initPlat{
    [self setCustomNavTitle:@"购物篮"];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    _mTableView.backgroundColor = [UIColor clearColor];
    _mTableView.opaque = NO;
    [_settleBtn addTarget:self action:@selector(settlementAction:) forControlEvents:UIControlEventTouchDown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        RMSopCarHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMSopCarHeadTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMSopCarHeadTableViewCell" owner:self options:nil] lastObject];
            [cell.corpNameL addTarget:self action:@selector(goCorpAction:) forControlEvents:UIControlEventTouchDown];
        }
        cell.corpNameL.tag = 1000*indexPath.section;
        return cell;
    }else if(indexPath.row == 4){
        RMShopLeaveMsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMShopLeaveMsTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMShopLeaveMsTableViewCell" owner:self options:nil] lastObject];
            [cell.contactCorpBtn addTarget:self action:@selector(contactCorpAction:) forControlEvents:UIControlEventTouchDown];
        }
        cell.contactCorpBtn.tag = indexPath.section*1000+indexPath.row;
        return cell;
    }else{
        RMShopCarGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMShopCarGoodsTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMShopCarGoodsTableViewCell" owner:self options:nil] lastObject];
            [cell.addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchDown];
            [cell.subBtn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchDown];
            [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchDown];
            cell.numTextField.delegate = self;
        }
        cell.addBtn.tag = 1000*indexPath.section+indexPath.row;
        cell.subBtn.tag = 1000*indexPath.section+indexPath.row+1;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 30;
    }else if (indexPath.row == 4){
        return 106;
    }else{
        return 77;
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


#pragma mark - 进入店铺
- (void)goCorpAction:(UIButton *)sender{
    NSInteger tag = sender.tag/1000;
    RMMyCorpViewController * corp = [[RMMyCorpViewController alloc]initWithNibName:@"RMMyCorpViewController" bundle:nil];
    [self.navigationController pushViewController:corp animated:YES];
}


#pragma mark - 购物车商品数量的增减
- (void)addAction:(UIButton *)sender{
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:sender.tag%1000 inSection:sender.tag/1000];
    RMShopCarGoodsTableViewCell * cell = (RMShopCarGoodsTableViewCell *)[_mTableView cellForRowAtIndexPath:indexpath];
    NSInteger num = [cell.numTextField.text integerValue];
    num++;
    cell.numTextField.text = [NSString stringWithFormat:@"%ld",(long)num];
}

- (void)subAction:(UIButton *)sender{
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:sender.tag%1000-1 inSection:sender.tag/1000];
    RMShopCarGoodsTableViewCell * cell = (RMShopCarGoodsTableViewCell *)[_mTableView cellForRowAtIndexPath:indexpath];
    NSInteger num = [cell.numTextField.text integerValue];
    num--;
    if(num == 0){
        num = 1;
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"商品数量至少为一个" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
    }
    cell.numTextField.text = [NSString stringWithFormat:@"%ld",(long)num];
}

#pragma mark - 删除
- (void)deleteAction:(id)sender{

}

#pragma mark - 联系卖家
- (void)contactCorpAction:(UIButton *)sender{
     NSIndexPath * indexpath = [NSIndexPath indexPathForRow:sender.tag%1000 inSection:sender.tag/1000];
    NSLog(@"联系卖家%@",indexpath);
}

#pragma mark - 结算
- (void)settlementAction:(UIButton *)sender{
    RMSettlementViewController * settle = [[RMSettlementViewController alloc]initWithNibName:@"RMSettlementViewController" bundle:nil];
//    [self.navigationController pushViewController:settle animated:YES];
//    settle.callback = ^(void){
//        [self dismissPopUpViewControllerWithcompletion:nil];
//    };
    settle.view.frame = CGRectMake(20, 60, kScreenWidth-20*2, kScreenHeight-60*2);
    [settle.titleView drawCorner:UIRectCornerTopLeft | UIRectCornerTopRight withFrame:CGRectMake(0, 0,kScreenWidth-20*2, kScreenHeight-60*2)];
    settle.callback = ^(void){
        [self dismissPopUpViewControllerWithcompletion:nil];
    };
    settle.selectAddress_callback = ^(void){
        RMAddressEditViewController * address_edit = [[RMAddressEditViewController alloc]initWithNibName:@"RMAddressEditViewController" bundle:nil];
        [self.navigationController pushViewController:address_edit animated:YES];
    };
    [self presentPopUpViewController:settle overlaybounds:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    switch (sender.tag) {
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
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
