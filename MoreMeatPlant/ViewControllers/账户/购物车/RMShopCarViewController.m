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
@interface RMShopCarViewController (){
    BOOL isShow;
}

@end

@implementation RMShopCarViewController


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)noti {
    if (!isShow) {
        CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        CGFloat height = self.mTableView.contentSize.height;
        self.mTableView.contentSize = CGSizeMake(self.mTableView.frame.size.width, height + size.height);
        isShow = !isShow;
    }
}

- (void)keyboardWillHide:(NSNotification *)noti {
    if (isShow) {
        CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        CGFloat height = self.mTableView.contentSize.height;
        self.mTableView.contentSize = CGSizeMake(self.mTableView.frame.size.width, height - size.height);
        isShow = !isShow;
    }
}

- (void)keyboardDidShow:(NSNotification *)noti {
    
}

- (void)keyboardDidHide:(NSNotification *)noti {
    
}

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
        }
        return cell;
    }else if(indexPath.row == 4){
        RMShopLeaveMsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMShopLeaveMsTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMShopLeaveMsTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else{
        RMShopCarGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMShopCarGoodsTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMShopCarGoodsTableViewCell" owner:self options:nil] lastObject];
        }
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
- (void)settlementAction:(UIButton *)sender{
    RMSettlementViewController * settle = [[RMSettlementViewController alloc]initWithNibName:@"RMSettlementViewController" bundle:nil];
//    [self.navigationController pushViewController:settle animated:YES];
//    settle.callback = ^(void){
//        [self dismissPopUpViewControllerWithcompletion:nil];
//    };
    settle.view.frame = CGRectMake(20, 60, kScreenWidth-20*2, kScreenHeight-60*2);
    settle.callback = ^(void){
        [self dismissPopUpViewControllerWithcompletion:nil];
    };
    settle.selectAddress_callback = ^(void){
        RMAddressEditViewController * address_edit = [[RMAddressEditViewController alloc]initWithNibName:@"RMAddressEditViewController" bundle:nil];
        [self.navigationController pushViewController:address_edit animated:YES];
    };
    [self presentPopUpViewController:settle overlaybounds:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
