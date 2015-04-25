//
//  RMUserInfoEditViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMUserInfoEditViewController.h"
#import "UIAlertView+Expland.h"
#import "RMUserInfoEditTableViewCell.h"
#import "RMCorpInfoEditTableViewCell.h"
@interface RMUserInfoEditViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RMUserInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"资料编辑"];
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    
}
//修改资料请求有问题
- (void)commit{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if([[[RMUserLoginInfoManager loginmanager] isCorp] boolValue]){//店铺资料修改
    
        RMCorpInfoEditTableViewCell * cell = (RMCorpInfoEditTableViewCell *)[_mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [RMAFNRequestManager myInfoModifyRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Type:nil AlipayNo:cell.apliyT.text Signature:[cell.signatureT.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] Dic:nil andCallBack:^(NSError *error, BOOL success, id object) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(success){
                RMPublicModel * model = object;
                if(model.status){
                    __model.contentQm = cell.signatureT.text;
                    __model.zfbNo = cell.apliyT.text;
                    [[NSNotificationCenter defaultCenter] postNotificationName:RMRequestMemberInfoAgainNotification object:__model];
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:model.msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
                    [alert handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
                        [self navgationBarButtonClick:nil];
                    }];
                    [alert show];
                    
                }else{
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:model.msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                    [alert show];
                    
                }
                
            }else{
                [self showHint:object];
            }
        }];

    }else{//用户资料修改
        RMUserInfoEditTableViewCell * cell = (RMUserInfoEditTableViewCell *)[_mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [RMAFNRequestManager myInfoModifyRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Type:nil AlipayNo:cell.apliyT.text Signature:[cell.signatureT.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] Dic:nil andCallBack:^(NSError *error, BOOL success, id object) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(success){
                RMPublicModel * model = object;
                if(model.status){
                    __model.contentQm = cell.signatureT.text;
                    __model.zfbNo = cell.apliyT.text;
                    [[NSNotificationCenter defaultCenter] postNotificationName:RMRequestMemberInfoAgainNotification object:__model];
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:model.msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
                    [alert handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
                        [self navgationBarButtonClick:nil];
                    }];
                    [alert show];
                    
                }else{
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:model.msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                    [alert show];
                    
                }
                
            }else{
                [self showHint:object];
            }
        }];

    }
    
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[[RMUserLoginInfoManager loginmanager] isCorp] boolValue]){
        RMUserInfoEditTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMUserInfoEditTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMUserInfoEditTableViewCell" owner:self options:nil] lastObject];
            [cell.sureModifyBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchDown];

        }
        
        cell.signatureT.text = Str_Objc(__model.contentQm, @"什么也没写...");
        cell.mobileT.text = __model.contentMobile;
        cell.apliyT.text = __model.zfbNo;
        [cell.content_face sd_setImageWithURL:[NSURL URLWithString:__model.content_face] placeholderImage:[UIImage imageNamed:@"nophote"]];
        return cell;
    }else{
        RMCorpInfoEditTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMCorpInfoEditTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMCorpInfoEditTableViewCell" owner:self options:nil] lastObject];
            [cell.sureModifyBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchDown];

        }
        cell.signatureT.text = Str_Objc(__model.contentQm, @"什么也没写...");
        cell.mobileT.text = __model.contentMobile;
        cell.apliyT.text = __model.zfbNo;
        [cell.content_face sd_setImageWithURL:[NSURL URLWithString:__model.content_face] placeholderImage:[UIImage imageNamed:@"nophote"]];
        
        cell.content_link.text = __model.content_linkname;
        cell.content_mobile.text = __model.content_mobile;
        cell.content_address.text = __model.content_address;
        [cell.card_photo sd_setImageWithURL:[NSURL URLWithString:__model.card_photo] placeholderImage:[UIImage imageNamed:@"444"]];
        [cell.corp_photo sd_setImageWithURL:[NSURL URLWithString:__model.corp_photo] placeholderImage:[UIImage imageNamed:@"222"]];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[[RMUserLoginInfoManager loginmanager] isCorp] boolValue]){
        return 621;
    }else{
        return 364;
    }
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
