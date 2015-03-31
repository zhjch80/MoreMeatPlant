//
//  RMMyWalletViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMMyWalletViewController.h"
#import "RMMyWalletTransferTableViewCell.h"
#import "RMMyWalletYueTableViewCell.h"
#import "UIView+Expland.h"
@interface RMMyWalletViewController (){
    BOOL isShow;
}

@end

@implementation RMMyWalletViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    self.view.backgroundColor = [UIColor clearColor];
    
    [_billBtn addTarget:self action:@selector(billAction:) forControlEvents:UIControlEventTouchDown];
    [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchDown];
    
}


#pragma mark - UITableVIewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        RMMyWalletYueTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMMyWalletYueTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMMyWalletYueTableViewCell" owner:self options:nil] lastObject];
             [cell.chargeRecordBtn addTarget:self action:@selector(billAction:) forControlEvents:UIControlEventTouchDown];
            [cell.chargeBtn addTarget:self action:@selector(chargeAction:) forControlEvents:UIControlEventTouchDown];
            [cell.turnBtn addTarget:self action:@selector(sureTurnAction:) forControlEvents:UIControlEventTouchDown];
        }
       
        return cell;
    }
    else{
        RMMyWalletTransferTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMMyWalletTransferTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMMyWalletTransferTableViewCell" owner:self options:nil] lastObject];
            [cell.sureBtn addTarget:self action:@selector(sureTurnOutAction:) forControlEvents:UIControlEventTouchDown];
            [cell.sureWithdrawalBtn addTarget:self action:@selector(sureWithdrawalAction:) forControlEvents:UIControlEventTouchDown];
            [cell.sendCodeBtn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchDown];
        }
        cell.mobileL.text = _content_mobile;
        cell.alipayName.text = [NSString stringWithFormat:@"支付宝: %@",_zfb_no];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 133.f;
    }
    else{
        return 334.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}


#pragma mark - 发送验证码
- (void)sendCodeAction:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager withdrawalSendCode:_content_mobile andCallBack:^(NSError *error, BOOL success, id object) {
        RMPublicModel * model = object;
        
        if(success && model.status){
            
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:model.msg toView:self.view];
    }];
}

#pragma mark - 确认转出
- (void)sureTurnOutAction:(id)sender{
    
    RMMyWalletTransferTableViewCell * cell =  (RMMyWalletTransferTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if([cell.otherAccountField.text length]>0 && [cell.moneyField.text length]>0){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [RMAFNRequestManager memberTransforWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] ToOtherMember:cell.otherAccountField.text Number:cell.moneyField.text andCallBack:^(NSError *error, BOOL success, id object) {
            RMPublicModel * model = object;
            if(success && model.status){
                
            }else{
                
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:model.msg toView:self.view];
        }];
    }else if ([cell.otherAccountField.text length]==0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入对方账号！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
    }else if ([cell.moneyField.text length]==0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入转出金额!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
    }
    
}
#pragma mark - 确认提现
- (void)sureWithdrawalAction:(id)sender{
    
    RMMyWalletTransferTableViewCell * cell =  (RMMyWalletTransferTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if([cell.withdrawalField.text length]>0){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [RMAFNRequestManager memberWithdrawalWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Code:cell.codeField.text Number:cell.withdrawalField.text andCallBack:^(NSError *error, BOOL success, id object) {
            RMPublicModel * model = object;
            if(success && model.status){
            
            }else{
                
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showMessag:model.msg toView:self.view];
        }];
    }else if ([cell.withdrawalField.text length]==0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入提现金额！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
    }else if ([cell.codeField.text length]==0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入验证码!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
    }
}

#pragma mark - 充值
- (void)chargeAction:(id)sender{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"充值" message:@"请输入充值金额" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSLog(@"取消");
    }else{
        
        UITextField *tf=[alertView textFieldAtIndex:0];
        NSLog(@"确认充值%@",tf.text);
    }
}

#pragma mark - 确认转余额为花币
- (void)sureTurnAction:(id)sender{
    
    RMMyWalletYueTableViewCell * cell = (RMMyWalletYueTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if([cell.yue_Z_huabiTextField.text length]>0){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [RMAFNRequestManager yu_eTurnHuabiWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Number:cell.yue_Z_huabiTextField.text andCallBack:^(NSError *error, BOOL success, id object) {
            RMPublicModel * model = object;
            if(success && model.status){
            
            }else{
            
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:model.msg toView:self.view];
        }];
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入转换的数目!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
    }
}

#pragma mark - 关闭
- (void)closeAction:(id)sender{
    if(self.closecallback){
        _closecallback(sender);
    }
}
#pragma mark - 账单
- (void)billAction:(id)sender{
    if(_billcallback){
        _billcallback(sender);
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
