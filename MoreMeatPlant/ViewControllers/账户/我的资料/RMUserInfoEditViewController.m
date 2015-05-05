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
#import "RMVPImageCropper.h"
@interface RMUserInfoEditViewController ()<UITableViewDelegate,UITableViewDataSource,RMVPImageCropperDelegate,UITextFieldDelegate,UITextViewDelegate>{
    NSURL * content_faceUrl;
    NSURL * cardUrl;
    NSURL * corpUrl;
    
    
}

@end

@implementation RMUserInfoEditViewController
@synthesize content_faceImg;
@synthesize cardImg;
@synthesize corpImg;
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
    
    if([[[RMUserLoginInfoManager loginmanager] isCorp] isEqualToString:@"2"]){//店铺资料修改
    
        RMCorpInfoEditTableViewCell * cell = (RMCorpInfoEditTableViewCell *)[_mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        [dic setValue:cell.content_link.text forKey:@"content_linkname"];
        [dic setValue:cell.content_mobile.text forKey:@"content_contact"];
        [dic setValue:cell.content_address.text forKey:@"content_address"];
        [dic setValue:content_faceUrl forKey:@"content_face"];
        [dic setValue:cardUrl forKey:@"content_sfzimg"];
        [dic setValue:corpUrl forKey:@"content_bjimg"];
        
        [RMAFNRequestManager myInfoModifyRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Type:nil AlipayNo:cell.apliyT.text Signature:[cell.signatureT.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] Dic:dic contentCode:cell.codeField.text andCallBack:^(NSError *error, BOOL success, id object) {
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
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        [dic setValue:content_faceUrl forKey:@"content_face"];
        NSLog(@"========%@",dic);
        
        [RMAFNRequestManager myInfoModifyRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Type:nil AlipayNo:cell.apliyT.text Signature:[cell.signatureT.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] Dic:dic contentCode:cell.codeField.text andCallBack:^(NSError *error, BOOL success, id object) {
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
    NSLog(@"%@",[[RMUserLoginInfoManager loginmanager] isCorp]);
    if([[[RMUserLoginInfoManager loginmanager] isCorp] isEqualToString:@"1"]){
        RMUserInfoEditTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMUserInfoEditTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMUserInfoEditTableViewCell" owner:self options:nil] lastObject];
            [cell.sureModifyBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchDown];
            [cell.sendBtn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchDown];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPhoto:)];
            cell.content_face.tag = 1000;
            cell.content_face.userInteractionEnabled = YES;
            [cell.content_face addGestureRecognizer:tap];
        }
        
        cell.signatureT.text = Str_Objc(__model.contentQm, @"什么也没写...");
        cell.mobileT.text = __model.contentUser;
        cell.apliyT.text = __model.zfbNo;
        if(content_faceImg == nil){
            [cell.content_face setImage:[UIImage imageNamed:@"photo"]];
        }else{
            [cell.content_face setImage:content_faceImg];
        }
        
        return cell;
    }else{
        RMCorpInfoEditTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMCorpInfoEditTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMCorpInfoEditTableViewCell" owner:self options:nil] lastObject];
            [cell.sureModifyBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchDown];
            cell.content_face.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPhoto:)];
            cell.content_face.tag = 1000;
            [cell.content_face addGestureRecognizer:tap];
            
            UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPhoto:)];
            cell.card_photo.userInteractionEnabled = YES;
            cell.card_photo.tag = 1001;
            [cell.card_photo addGestureRecognizer:tap2];
            
            UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPhoto:)];
            cell.corp_photo.userInteractionEnabled = YES;
            cell.corp_photo.tag = 1002;
            [cell.corp_photo addGestureRecognizer:tap3];
            
            [cell.sendBtn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchDown];
        }
        cell.signatureT.text = Str_Objc(__model.contentQm, @"什么也没写...");
        cell.mobileT.text = __model.contentUser;
        cell.apliyT.text = __model.zfbNo;
        if(content_faceImg == nil){
            [cell.content_face setImage:[UIImage imageNamed:@"photo"]];
        }else{
            [cell.content_face setImage:content_faceImg];
        }
        
        cell.content_link.text = __model.contentLinkname;
        cell.content_mobile.text = __model.contentContact;
        cell.content_address.text = __model.contentAddress;
        if(cardImg == nil){
            [cell.card_photo setImage:[UIImage imageNamed:@"444"]];
        }else{
            [cell.card_photo setImage:cardImg];
        }
        if(corpImg == nil){
            [cell.corp_photo setImage:[UIImage imageNamed:@"222"]];
        }else{
            [cell.corp_photo setImage:corpImg];
        }
        

        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[[RMUserLoginInfoManager loginmanager] isCorp] isEqualToString:@"2"]){
        return 649;
    }else{
        return 364;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if([[[RMUserLoginInfoManager loginmanager] isCorp] isEqualToString:@"1"]){//普通用户
        
        RMUserInfoEditTableViewCell * cell = (RMUserInfoEditTableViewCell *)[_mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if(textField == cell.apliyT){
            __model.zfbNo = textField.text;
        }else if (textField == cell.codeField){
        
        }
        
    }else{
        RMCorpInfoEditTableViewCell * cell = (RMCorpInfoEditTableViewCell *)[_mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if(textField == cell.apliyT){
            __model.zfbNo = textField.text;
        }else if (textField == cell.content_link){
            __model.contentLinkname = textField.text;
        }else if (textField == cell.content_mobile){
            __model.contentContact = textField.text;
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if([[[RMUserLoginInfoManager loginmanager] isCorp] isEqualToString:@"1"]){//普通用户
        RMUserInfoEditTableViewCell * cell = (RMUserInfoEditTableViewCell *)[_mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if(textView == cell.signatureT){
            __model.contentQm = textView.text;
        }
    }else{
        RMCorpInfoEditTableViewCell * cell = (RMCorpInfoEditTableViewCell *)[_mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if(textView == cell.signatureT){
            __model.contentQm = textView.text;
        }else if (textView == cell.content_address){
            __model.contentAddress = textView.text;
        }
    }
}

- (void)selectPhoto:(UITapGestureRecognizer *)tap{
    if(tap.view.tag == 1000){
        [[RMVPImageCropper shareImageCropper] setCtl:self];
        [[RMVPImageCropper shareImageCropper] set_scale:1.0];
        [[RMVPImageCropper shareImageCropper] showActionSheet];
        [[RMVPImageCropper shareImageCropper] setFileName:@"content_face.jpg"];
    }else if (tap.view.tag == 1001){
        [[RMVPImageCropper shareImageCropper] setCtl:self];
        [[RMVPImageCropper shareImageCropper] set_scale:5.0/8.0];
        [[RMVPImageCropper shareImageCropper] showActionSheet];
        [[RMVPImageCropper shareImageCropper] setFileName:@"content_sfzimg.jpg"];
    }else{
        [[RMVPImageCropper shareImageCropper] setCtl:self];
        [[RMVPImageCropper shareImageCropper] set_scale:1.0/3.0];
        [[RMVPImageCropper shareImageCropper] showActionSheet];
        [[RMVPImageCropper shareImageCropper] setFileName:@"content_bjimg.jpg"];
    }
}


#pragma mark - 发送验证码
- (void)sendCodeAction:(id)sender{
    if([[[RMUserLoginInfoManager loginmanager] isCorp] isEqualToString:@"2"]){//店铺资料修改
        
        RMCorpInfoEditTableViewCell * cell = (RMCorpInfoEditTableViewCell *)[_mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [RMAFNRequestManager modifyInfoSendCodeWith:cell.mobileT.text WithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd]  andCallBack:^(NSError *error, BOOL success, id object) {
            RMPublicModel * model = (RMPublicModel *)object;
            if(error){
                NSLog(@"%@",error);
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(success&&model.status){
                cell.sendBtn.enabled = NO;
                //button type要 设置成custom 否则会闪动
                [cell.sendBtn startWithSecond:60];
                
                [cell.sendBtn didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                    NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                    return title;
                }];
                [cell.sendBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                    countDownButton.enabled = YES;
                    return @"重新获取";
                }];
            }
            [MBProgressHUD showSuccess:model.msg toView:self.view];
        }];

    }else{
         RMUserInfoEditTableViewCell * cell = (RMUserInfoEditTableViewCell *)[_mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [RMAFNRequestManager modifyInfoSendCodeWith:cell.mobileT.text WithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd]  andCallBack:^(NSError *error, BOOL success, id object) {
            RMPublicModel * model = (RMPublicModel *)object;
            if(error){
                NSLog(@"%@",error);
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(success&&model.status){
                cell.sendBtn.enabled = NO;
                //button type要 设置成custom 否则会闪动
                [cell.sendBtn startWithSecond:60];
                
                [cell.sendBtn didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                    NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                    return title;
                }];
                [cell.sendBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                    countDownButton.enabled = YES;
                    return @"重新获取";
                }];
            }
            [MBProgressHUD showSuccess:model.msg toView:self.view];
        }];

    }
//    if(_mobileTextField.text.length==0){
//        
//        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
//        return;
//    }
    
}


#pragma mark - RMimageCropperDelegate
- (void)RMimageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage andfilePath:(NSURL *)filePath{
    NSLog(@"马东凯头像－－－－－－%@",editedImage);
    if([[RMVPImageCropper shareImageCropper] _scale] == 1.0){
        //头像
        content_faceUrl = filePath;
        content_faceImg = editedImage;
    }else if ([[RMVPImageCropper shareImageCropper] _scale] == 5.0/8.0){
        //身份证
        cardUrl = filePath ;
        cardImg = editedImage;
    }else{
        //店铺背景
        corpUrl = filePath ;
        corpImg = editedImage;
    }
    [_mtableView reloadData];
}

- (void)RMimageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    NSLog(@"取消替换头像");
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
