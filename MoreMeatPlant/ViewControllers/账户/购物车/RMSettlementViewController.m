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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    self.view.backgroundColor = [UIColor clearColor];
    
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.opaque = NO;
    
    [_close_btn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchDown];
}

#pragma mark - UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row<2){
        RMAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMAddressTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMAddressTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else if(indexPath.row == 2){
        RMAddAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMAddAddressTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMAddAddressTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else if (indexPath.row == 3){
        RMPayTypeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPayTypeTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPayTypeTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else{
        RMSettlementTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMSettlementTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMSettlementTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row<2){
        return 100;
    }else if(indexPath.row == 2){
        
        return 36;
    }else if (indexPath.row == 3){
        
        return 44;
    }else{
        
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.selectAddress_callback){
        _selectAddress_callback();
    }
}

- (void)closeAction:(UIButton *)sender{
    if(self.callback){
        _callback();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
