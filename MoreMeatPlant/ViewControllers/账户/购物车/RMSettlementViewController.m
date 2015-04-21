//
//  RMSettlementViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/10.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMSettlementViewController.h"

#import "RMAddressTableViewCell.h"
#import "RMPayTypeTableViewCell.h"
#import "RMAddAddressTableViewCell.h"
#import "RMSettlementTableViewCell.h"
#import "RMAddressEditViewController.h"
@implementation RMSettlementViewController
@synthesize addressArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    self.view.backgroundColor = [UIColor clearColor];
    
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.opaque = NO;
    
    [_close_btn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchDown];
    
    addressArray = [[NSMutableArray alloc]init];
    _model = [[RMPublicModel alloc] init];
    
    _paymentType = @"1";
    
    [self loadInfo];
    [self requestAddresslist];
}

- (void)loadInfo{
    [RMAFNRequestManager myInfoRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] andCallBack:^(NSError *error, BOOL success, id object) {
        RMPublicModel * model = object;
        _model = model;
        if(success && model.status){
            balance = [NSString stringWithFormat:@"%.0f",model.balance];
            [_mainTableView reloadData];
        }else{
            
        }
    }];
}


- (void)requestAddresslist{
    [addressArray removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager addressRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            [addressArray addObjectsFromArray:object];
        }else{
            [MBProgressHUD showError:object toView:self.view];
        }
        [_mainTableView reloadData];
    }];
}

#pragma mark - UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [addressArray count]+3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row<[addressArray count]){
        RMAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMAddressTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMAddressTableViewCell" owner:self options:nil] lastObject];
            [cell.editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchDown];
        }
        RMPublicModel * model = [addressArray objectAtIndex:indexPath.row];
        if([model isEqual:_model]){
            [cell.selectAddressBtn setImage:[UIImage imageNamed:@"gwc_select"] forState:UIControlStateNormal];
        }else{
            [cell.selectAddressBtn setImage:[UIImage imageNamed:@"gwc_no_select"] forState:UIControlStateNormal];
        }

        cell.linkName.text = model.contentName;
        cell.mobile.text = model.contentMobile;
        cell.detailAddress.text = model.contentAddress;
        cell.editBtn.tag = 100+indexPath.row;
        return cell;
    }else if(indexPath.row == [addressArray count]){
        RMAddAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMAddAddressTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMAddAddressTableViewCell" owner:self options:nil] lastObject];
            [cell.addAddress addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchDown];
        }
        return cell;
    }else if (indexPath.row == [addressArray count]+1){
        RMPayTypeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPayTypeTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPayTypeTableViewCell" owner:self options:nil] lastObject];
            [cell.yu_e_payBtn addTarget:self action:@selector(selectPaymentType:) forControlEvents:UIControlEventTouchDown];
            [cell.alipayBtn addTarget:self action:@selector(selectPaymentType:) forControlEvents:UIControlEventTouchDown];
        }
        cell.yu_e_payBtn.tag = 100;
        cell.alipayBtn.tag = 101;
        cell.yu_eL.text = balance;
        if([self.paymentType isEqualToString: @"1"]){
            [cell.yu_e_payBtn setBackgroundImage:[UIImage imageNamed:@"gwc_select"] forState:UIControlStateNormal];
            [cell.alipayBtn setBackgroundImage:[UIImage imageNamed:@"gwc_no_select"] forState:UIControlStateNormal];
        }else{
            [cell.yu_e_payBtn setBackgroundImage:[UIImage imageNamed:@"gwc_no_select"] forState:UIControlStateNormal];
            [cell.alipayBtn setBackgroundImage:[UIImage imageNamed:@"gwc_select"] forState:UIControlStateNormal];
        }
        return cell;
    }else{
        RMSettlementTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMSettlementTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMSettlementTableViewCell" owner:self options:nil] lastObject];
            [cell.settlementBtn addTarget:self action:@selector(settlementAction:) forControlEvents:UIControlEventTouchDown];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row<[addressArray count]){
        return 100;
    }else if(indexPath.row == [addressArray count]){
        
        return 36;
    }else if (indexPath.row == [addressArray count]+1){
        
        return 44;
    }else{
        
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([addressArray count]!=0){
        _model = [addressArray objectAtIndex:indexPath.row];
        [tableView reloadData];
        if(self.selectAddress_callback){
            _selectAddress_callback(_model);
        }
    }
}

- (void)closeAction:(UIButton *)sender{
    if(self.callback){
        _callback();
    }
}

- (void)editAction:(UIButton *)sender{
    RMPublicModel * model = [addressArray objectAtIndex:sender.tag%100];
    if(_editAddress_callback){
        _editAddress_callback(model);
    }
}

- (void)addAction:(UIButton *)sender{
    if(_addAddress_callback){
        _addAddress_callback ();
    }
}

- (void)selectPaymentType:(UIButton *)sender{
    if(sender.tag == 100){
        self.paymentType = @"1";
        
    }else{
        self.paymentType = @"2";
    }
    [_mainTableView reloadData];
    if(self.payment_callback){
        self.payment_callback (self.paymentType);
    }
}

- (void)settlementAction:(UIButton *)sender{
    //结算
    if(_model.contentName == nil || _model.contentMobile == nil || _model.contentAddress == nil){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择收货地址" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }
    
    RMPublicModel * model = [[RMPublicModel alloc]init];
    if(_settle_callback){
        _settle_callback(model);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
