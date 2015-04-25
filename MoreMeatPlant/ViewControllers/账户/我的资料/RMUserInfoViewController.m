//
//  RMUserInfoViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMUserInfoViewController.h"
#import "UIView+Expland.h"
#import "RMUserInfoTableViewCell.h"
#import "RMCorpInfoTableViewCell.h"
@interface RMUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation RMUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recevierNotification:) name:RMRequestMemberInfoAgainNotification object:nil];
    
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
    
}

- (void)recevierNotification:(NSNotification *)noti{
    
    if([noti.name isEqualToString:RMRequestMemberInfoAgainNotification]){
        [_mtableView reloadData];
    }
}

#pragma mark - 修改密码
- (void)modifyAction:(UIButton *)sender{
    if(self.modify_callback){
        _modify_callback (self);
    }
}

- (void)operation:(UIButton *)sender{
    if(self.callback){
        _callback(self);
    }
}

- (void)closeAction:(UIButton *)sender{
    if(self.close_action){
        _close_action(self);
    }
}



#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[[RMUserLoginInfoManager loginmanager] isCorp] boolValue]){
        RMCorpInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMCorpInfoTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMCorpInfoTableViewCell" owner:self options:nil] lastObject];
            [cell.editBtn addTarget:self action:@selector(operation:) forControlEvents:UIControlEventTouchDown];
            [cell.modifyBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchDown];
        }
        cell.nickL.text = __model.contentName;
        cell.passwordL.text = @"******";
        cell.signatureL.text = __model.contentQm?__model.contentQm:@"暂无";
        cell.mobileL.text = __model.contentMobile;
        cell.apliyL.text = __model.zfbNo;
        cell.content_linkL.text = __model.content_linkname;
        cell.content_mobileL.text = __model.content_mobile;
        cell.content_addressL.text = __model.content_address?__model.content_address:@"还未填写";
        [cell.card_photo sd_setImageWithURL:[NSURL URLWithString:__model.card_photo] placeholderImage:[UIImage imageNamed:@"444"]];
        [cell.corp_photo sd_setImageWithURL:[NSURL URLWithString:__model.corp_photo] placeholderImage:[UIImage imageNamed:@"222"]];
        
        
        [cell.content_face sd_setImageWithURL:[NSURL URLWithString:__model.content_face] placeholderImage:[UIImage imageNamed:@"nophote"]];
        return cell;
    }else{
        RMUserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMUserInfoTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMUserInfoTableViewCell" owner:self options:nil] lastObject];
            [cell.editBtn addTarget:self action:@selector(operation:) forControlEvents:UIControlEventTouchDown];
            [cell.modifyBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchDown];
        }
        cell.nickL.text = __model.contentName;
        cell.passwordL.text = @"******";
        cell.signatureL.text = __model.contentQm?__model.contentQm:@"暂无";
        cell.mobileL.text = __model.contentMobile;
        cell.apliyL.text = __model.zfbNo;
        [cell.content_face sd_setImageWithURL:[NSURL URLWithString:__model.content_face] placeholderImage:[UIImage imageNamed:@"nophote"]];
        return cell;
    }
    
    
    
    
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[[RMUserLoginInfoManager loginmanager] isCorp] boolValue]){
        return 667;
    }else{
        return 335;
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
