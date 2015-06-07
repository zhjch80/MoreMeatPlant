//
//  RMPublishBabyViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPublishBabyViewController.h"
#import "RMPublishTitleTableViewCell.h"
#import "RMPublishPlateTableViewCell.h"
#import "RMPublishClassTableViewCell.h"
#import "RMPublishNumberTableViewCell.h"
#import "RMPublishPhotoTableViewCell.h"
#import "RMPublishSureTableViewCell.h"
#import "RMPublishCourseTableViewCell.h"
#import "NSString+Addtion.h"
#import "RMVPImageCropper.h"
#import "RMAdvantageTipView.h"
@interface RMPublishBabyViewController ()<RMVPImageCropperDelegate,RMPublishCourseTableViewCellDelegate,RMPublishClassTableViewCellDelegate>{
    BOOL isCourseFirst;
    BOOL isClassFirst;
    BOOL selectQt;//选择其他快递
    RMAdvantageTipView * tipView;
    
    CGFloat photoCellheight;
}

@end

@implementation RMPublishBabyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"发布宝贝"];
    isCourseFirst = YES;
    isClassFirst = YES;
    selectQt = NO;
    
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    classArray = [[NSMutableArray alloc]init];
    courseArray = [[NSMutableArray alloc]init];
    if(current_Model == nil){
        current_Model = [[RMPublicModel alloc]init];
        current_Model.content_num = @"1";
    }
    
    modifyPhotoDic = [[NSMutableDictionary alloc]init];
    modifyImageDic = [[NSMutableDictionary alloc]init];
    
    newAddPhotoDic = [[NSMutableDictionary alloc]init];
    newAddImageDic = [[NSMutableDictionary alloc]init];
    
    [self courseRequest];
    
    if(self.auto_id != nil){
        photoCellheight = (kScreenWidth-10*2-4*1)/5.0+5+8;
        [self editDataequest];
    }else{
        photoCellheight = (kScreenWidth-10*2-4*1)/5.0+8+5+21+5+21+8;
    }
}

- (void)editDataequest{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager babyPublishDataRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Autoid:self.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * model = object;
            if(model.status){
                current_Model = model;
                NSLog(@"%@",current_Model.body);
                if([current_Model.content_express length]>0&&[current_Model.express_price length]>0){
                    selectQt = YES;
                }
            }else{
                
            }
            [_mTableView reloadData];
        }else{
            [self showHint:object];
        }
    }];
}

#pragma mark - 店铺分类请求
- (void)classRequest{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager corpbabyClassRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            [classArray addObjectsFromArray:object];
        }else{
            [self showHint:object];
        }
        [_mTableView reloadData];
    }];
}

#pragma mark -科目请求
- (void)courseRequest{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPlantSubjectsListWithLevel:1 callBack:^(NSError *error, BOOL success, id object) {
        if(success){
            for (NSInteger i=0; i<[(NSArray *)[object objectForKey:@"data"] count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.auto_code = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_code"]);
                model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                model.change_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"change_img"]);
                model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                model.modules_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"modules_name"]);
                [courseArray addObject:model];
                
                [_mTableView reloadData];
            }
            [self classRequest];
            
        }else{
            [self showHint:object];
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
    
        RMPublishTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishTitleTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishTitleTableViewCell" owner:self options:nil] lastObject];
            [cell.select_shunf addTarget:self action:@selector(selectSfAction:) forControlEvents:UIControlEventTouchDown];
            [cell.selectQt addTarget:self action:@selector(selectQtAction:) forControlEvents:UIControlEventTouchDown];
            cell.titleTextfield.delegate = self;
            cell.content_descField.delegate = self;
            cell.content_price.delegate  = self;
            cell.qt_nameField.delegate = self;
            cell.qt_priceField.delegate  = self;
        }
        cell.titleTextfield.text = current_Model.content_name;
        cell.content_descField.text = current_Model.content_desc;
        cell.content_price.text  =current_Model.content_price;
        cell.qt_nameField.text = current_Model.content_express;
        cell.qt_priceField.text  =current_Model.express_price;
        if([current_Model.is_sf boolValue]){
            [cell.select_shunf setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
        }else{
            [cell.select_shunf setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
        }
        
        if(selectQt){
            [cell.selectQt setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
        }else{
            [cell.selectQt setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
        }
        
        return cell;
    }else if(indexPath.row == 1){
        RMPublishCourseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishCourseTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishCourseTableViewCell" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
        
        if([courseArray count]>0&&isCourseFirst){
            [cell createItem:courseArray];
            isCourseFirst = NO;
        }
        int i = 0;
        for(RMPublicModel * model in courseArray){
            UIButton * btn = (UIButton *)[cell.contentView viewWithTag:100+i];
            [btn setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
            NSLog(@"%@",btn);
            if([model.auto_code isEqualToString:current_Model.content_course]){
                [btn setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
            }
            i++;
        }
        
        return cell;
    }else if(indexPath.row == 2){
        RMPublishPlateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishPlateTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishPlateTableViewCell" owner:self options:nil] lastObject];
            [cell.yryp_btn addTarget:self action:@selector(selectPlante:) forControlEvents:UIControlEventTouchDown];
            [cell.xrsc_btn addTarget:self action:@selector(selectPlante:) forControlEvents:UIControlEventTouchDown];
        }
        if([current_Model.content_class isEqualToString:@"1"]){//一肉一拍
            [cell.yryp_btn setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
            [cell.xrsc_btn setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
        }else if([current_Model.content_class isEqualToString:@"2"]){//鲜肉市场
            [cell.yryp_btn setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
            [cell.xrsc_btn setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
        }
        return cell;
    }else if (indexPath.row == 3){
        RMPublishClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishClassTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishClassTableViewCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            [cell.addClassBtn addTarget:self action:@selector(addClassAction:) forControlEvents:UIControlEventTouchDown];
        }
        if([classArray count]>0&&isClassFirst){
            [cell createItem:classArray andCallBack:nil];
            isClassFirst = NO;
        }
        NSArray * arr = [current_Model.member_class componentsSeparatedByString:@","];
        NSMutableArray * iArr = [[NSMutableArray alloc]init];
        for(NSString * auto_id in arr){
            int i = 0;
            for(RMPublicModel * model in classArray){

                NSLog(@"%@======%@",model.auto_id,auto_id);
                if([model.auto_id isEqualToString:auto_id]){
                    [iArr addObject:[NSNumber numberWithInt:i]];
                }else{
                }
                i++;
            }
        }

        for(int i = 0;i<[classArray count];i++){
            UIButton * btn = (UIButton *)[cell.contentView viewWithTag:100+i];
            [btn setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
        }
        
        for(NSNumber * num in iArr){
            UIButton * btn = (UIButton *)[cell.contentView viewWithTag:100+[num integerValue]];
            [btn setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];


        }
        return cell;
    }else if (indexPath.row == 4){
        RMPublishNumberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishNumberTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishNumberTableViewCell" owner:self options:nil] lastObject];
            cell.numTextfield.delegate = self;
        }
        cell.numTextfield.text = current_Model.content_num;
        return cell;
    }else if (indexPath.row == 5||indexPath.row == 6){
        RMPublishPhotoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishPhotoTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishPhotoTableViewCell" owner:self options:nil] lastObject];
            [cell.picSelect1 addTarget:self action:@selector(selectFromPics:) forControlEvents:UIControlEventTouchDown];
            [cell.picSelect2 addTarget:self action:@selector(selectFromPics:) forControlEvents:UIControlEventTouchDown];
            [cell.picSelect3 addTarget:self action:@selector(selectFromPics:) forControlEvents:UIControlEventTouchDown];
            [cell.picSelect4 addTarget:self action:@selector(selectFromPics:) forControlEvents:UIControlEventTouchDown];
            [cell.picSelect5 addTarget:self action:@selector(selectFromPics:) forControlEvents:UIControlEventTouchDown];
            
            [cell.camera1 addTarget:self action:@selector(selectFromCamera:) forControlEvents:UIControlEventTouchDown];
            [cell.camera2 addTarget:self action:@selector(selectFromCamera:) forControlEvents:UIControlEventTouchDown];
            [cell.camera3 addTarget:self action:@selector(selectFromCamera:) forControlEvents:UIControlEventTouchDown];
            [cell.camera4 addTarget:self action:@selector(selectFromCamera:) forControlEvents:UIControlEventTouchDown];
            [cell.camera5 addTarget:self action:@selector(selectFromCamera:) forControlEvents:UIControlEventTouchDown];
            
            
            if(self.auto_id != nil){
                cell.picSelect1.hidden = YES;
                cell.picSelect2.hidden = YES;
                cell.picSelect3.hidden = YES;
                cell.picSelect4.hidden = YES;
                cell.picSelect5.hidden = YES;
                cell.camera1.hidden = YES;
                cell.camera2.hidden = YES;
                cell.camera3.hidden = YES;
                cell.camera4.hidden = YES;
                cell.camera5.hidden = YES;
                
            }
            
        }
        cell.picSelect1.tag = indexPath.row*100+1;
        cell.picSelect2.tag = indexPath.row*100+2;
        cell.picSelect3.tag = indexPath.row*100+3;
        cell.picSelect4.tag = indexPath.row*100+4;
        cell.picSelect5.tag = indexPath.row*100+5;
        
        cell.camera1.tag = indexPath.row*200+1;
        cell.camera2.tag = indexPath.row*200+2;
        cell.camera3.tag = indexPath.row*200+3;
        cell.camera4.tag = indexPath.row*200+4;
        cell.camera5.tag = indexPath.row*200+5;
        
        cell.img1.tag = indexPath.row*300+1;
        cell.img2.tag = indexPath.row*300+2;
        cell.img3.tag = indexPath.row*300+3;
        cell.img4.tag = indexPath.row*300+4;
        cell.img5.tag = indexPath.row*300+5;
        
        if(indexPath.row == 5){
            cell.fengmian.hidden = NO;
            int j = 0;
            for(NSDictionary * dic in current_Model.body){
                if(j == 0){
                    [cell.img1 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                }else if(j == 1){
                    [cell.img2 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                }else if(j == 2){
                    [cell.img3 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                }else if (j == 3) {
                    [cell.img4 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                }else if (j == 4){
                    [cell.img5 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                }
                j++;
            }
        }else if(indexPath.row == 6){
            cell.fengmian.hidden = YES;
            int j = 0;
            for(NSDictionary * dic in current_Model.body){
                if(j == 5){
                    [cell.img1 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                }else if(j == 6){
                    [cell.img2 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                }else if(j == 7){
                    [cell.img3 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                }else if (j == 8) {
                    [cell.img4 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                }else if (j == 9){
                    [cell.img5 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"nophote"]];
                }
                j++;
            }
        }
        
        
        for(NSString * n in [modifyImageDic allKeys]){
            UIImageView * imageV = (UIImageView *)[cell.contentView viewWithTag:[n integerValue]];
            [imageV setImage:[modifyImageDic objectForKey:n]];
        }
        
        for(NSString * key in [newAddImageDic allKeys]){
            NSInteger tag = 0;;
            
            if([key integerValue]>5){
                tag = 6*300+[key integerValue]-5;
                UIImageView * imageV = (UIImageView *)[cell.contentView viewWithTag:tag];
                [imageV setImage:[newAddImageDic objectForKey:key]];
            }else{
                 tag = 5*300+[key integerValue];
                UIImageView * imageV = (UIImageView *)[cell.contentView viewWithTag:tag];
                [imageV setImage:[newAddImageDic objectForKey:key]];
            }
        }
        
        NSLog(@"&&&&&&&&&%@",newAddImageDic);
        
        return cell;
    }else{
        RMPublishSureTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishSureTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishSureTableViewCell" owner:self options:nil] lastObject];
            [cell.surePublish addTarget:self action:@selector(pulishAction:) forControlEvents:UIControlEventTouchDown];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 154;
    }else if(indexPath.row == 1){
        CGFloat x = 10;
        CGFloat y = 31;
        for(RMPublicModel * model in courseArray){
            CGSize size = [model.modules_name getcontentsizeWithfont:FONT_0(13) constrainedtosize:CGSizeMake(100, 20) linemode:NSLineBreakByCharWrapping];
            
            if(x+20+size.width+10*2>kScreenWidth){
                y+=20+5;
                x = 10;
            }
            x+= 10+size.width+10;
        }
        return y+31+20;
    }else if(indexPath.row == 2){
        return 65;
    }else if (indexPath.row == 3){
        CGFloat x = 10;
        CGFloat y = 31;
        for(RMPublicModel * model in classArray){
            CGSize size = [model.content_name getcontentsizeWithfont:FONT_0(13) constrainedtosize:CGSizeMake(100, 20) linemode:NSLineBreakByCharWrapping];
            
            if(x+20+size.width+10*2>kScreenWidth){
                y+=20+5;
                x = 10;
            }
            x+= 10+20+size.width+10;
        }
        return y+31+20;
        
    }else if (indexPath.row == 4){
        return 44;
    }else if (indexPath.row == 5){
        return photoCellheight;
    }else if (indexPath.row == 6){
        return photoCellheight;
    }else{
        return 58;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

#pragma mark - 选择顺丰
- (void)selectSfAction:(UIButton *)sender{
    RMPublishTitleTableViewCell * cell = (RMPublishTitleTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if([current_Model.is_sf boolValue]){
        [cell.select_shunf setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
        current_Model.is_sf = @"0";
    }else{
        [cell.select_shunf setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
        current_Model.is_sf = @"1";
    }
    [_mTableView reloadData];
}

#pragma mark - 选择其他快递
- (void)selectQtAction:(UIButton *)sender{
    RMPublishTitleTableViewCell * cell = (RMPublishTitleTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.select_shunf setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
    [cell.selectQt setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
    if(selectQt){
        [cell.selectQt setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
    }else{
        [cell.selectQt setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
    }
    selectQt = !selectQt;
    [_mTableView reloadData];
}

#pragma mark - 选择发布市场
- (void)selectPlante:(UIButton *)sender{
    RMPublishPlateTableViewCell * cell = (RMPublishPlateTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if(sender == cell.yryp_btn){
        [cell.xrsc_btn setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
        [cell.yryp_btn setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
        current_Model.content_class = @"1";
    }else{
        [cell.yryp_btn setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
        [cell.xrsc_btn setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
        current_Model.content_class = @"2";
    }
    [_mTableView reloadData];
}

#pragma mark - 拍照
- (void)selectFromCamera:(UIButton *)sender{
    img_tag = (sender.tag/200)*300+sender.tag%200;

    [[RMVPImageCropper shareImageCropper] setCtl:self];
    [[RMVPImageCropper shareImageCropper] set_scale:1.0];
    [[RMVPImageCropper shareImageCropper] openCamera];
    if((img_tag/300-5)*5+img_tag%300<=[current_Model.body count]){
        
        NSDictionary * dic = OBJC_Nil([current_Model.body objectAtIndex:(img_tag/300-5)*5+img_tag%300-1]);
        if(dic){
            [[RMVPImageCropper shareImageCropper] setFileName:[NSString stringWithFormat:@"frm[body][auto_id][%ld].png",(img_tag/300-5)*5+img_tag%300-1]];
            NSLog(@"%@",[NSString stringWithFormat:@"frm[body][auto_id][%ld].png",(img_tag/300-5)*5+img_tag%300-1]);
        }
    }else{
        [[RMVPImageCropper shareImageCropper] setFileName:[NSString stringWithFormat:@"frm[body][content_img][%lu].png",(img_tag/300-5)*5+img_tag%300-[current_Model.body count]-1]];
        NSLog(@"%@",[NSString stringWithFormat:@"frm[body][content_img][%lu].png",(img_tag/300-5)*5+img_tag%300-[current_Model.body count]-1]);
    }

}
#pragma mark - 从相册选择图片
- (void)selectFromPics:(UIButton *)sender{
    
    img_tag = (sender.tag/100)*300+sender.tag%100;

    [[RMVPImageCropper shareImageCropper] setCtl:self];
    [[RMVPImageCropper shareImageCropper] set_scale:1.0];
    [[RMVPImageCropper shareImageCropper] openPics];
    if((img_tag/300-5)*5+img_tag%300<=[current_Model.body count]){
        
        NSDictionary * dic = OBJC_Nil([current_Model.body objectAtIndex:(img_tag/300-5)*5+img_tag%300-1]);
        if(dic){
            [[RMVPImageCropper shareImageCropper] setFileName:[NSString stringWithFormat:@"frm[body][auto_id][%ld].png",(img_tag/300-5)*5+img_tag%300-1]];
            NSLog(@"%@",[NSString stringWithFormat:@"frm[body][auto_id][%ld].png",(img_tag/300-5)*5+img_tag%300-1]);
        }
    }else{
        [[RMVPImageCropper shareImageCropper] setFileName:[NSString stringWithFormat:@"frm[body][content_img][%lu].png",(img_tag/300-5)*5+img_tag%300-[current_Model.body count]-1]];
        NSLog(@"%@",[NSString stringWithFormat:@"frm[body][content_img][%lu].png",(img_tag/300-5)*5+img_tag%300-[current_Model.body count]-1]);
    }
    
}

- (void)addClassAction:(id)sender{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入要添加的分类名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSLog(@"取消");
    }else{
        
         UITextField *tf=[alertView textFieldAtIndex:0];
        NSLog(@"添加:%@",tf.text);
        [self addClassRequest:tf.text];
    }
}

- (void)addClassRequest:(NSString *)str{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager corpbabyAddClassWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] className:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        RMPublicModel * model = object;
        if(success){
            if(model.status){
                [classArray removeAllObjects];
                [self classRequest];
                RMPublishClassTableViewCell * cell = (RMPublishClassTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                RMPublicModel * model = [[RMPublicModel alloc]init];
                model.content_name = str;
                NSArray * arr = [NSArray arrayWithObjects:model ,nil];
                
                [cell createItem:arr andCallBack:^{
                    
                }];
                [_mTableView reloadData];
            }
            [self showHint:model.msg];
        }else{
            [self showHint:object];
        }
        
    }];
}


#pragma mark - 选择科目分类
- (void)RMPublishCourseTableViewCellDidSelectCourse:(UIButton *)sender{
    
    RMPublishCourseTableViewCell * cell = (RMPublishCourseTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    for(int i = 0;i<[courseArray count];i++){
        UIButton * btn = (UIButton *)[cell.contentView viewWithTag:100+i];
        [btn setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
    }
    [sender setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
    current_Model.content_course = [(RMPublicModel *)[courseArray objectAtIndex:sender.tag-100] auto_code];
    [_mTableView reloadData];
}

#pragma mark - 选择商家自己的分类
- (void)RMPublishClassTableViewCellDidSelectCourse:(UIButton *)sender{
    for(NSString * s in [current_Model.member_class componentsSeparatedByString:@","]){
        if([[(RMPublicModel *)[classArray objectAtIndex:sender.tag-100] auto_id] isEqualToString:s]){
            break;
        }
    }
    NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:[current_Model.member_class componentsSeparatedByString:@","]];
    if([arr containsObject:[(RMPublicModel *)[classArray objectAtIndex:sender.tag-100] auto_id]]){
        [sender setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
        [arr removeObject:[(RMPublicModel *)[classArray objectAtIndex:sender.tag-100] auto_id]];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
        [arr addObject:[(RMPublicModel *)[classArray objectAtIndex:sender.tag-100] auto_id]];
    }
    [arr removeObject:@""];
    current_Model.member_class = [arr componentsJoinedByString:@","];
    [_mTableView reloadData];
    
    NSLog(@"%@",current_Model.member_class);
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    RMPublishTitleTableViewCell * cell = (RMPublishTitleTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    RMPublishNumberTableViewCell * numcell = (RMPublishNumberTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    current_Model.content_name = cell.titleTextfield.text;
    current_Model.content_desc = cell.content_descField.text;
    current_Model.content_price = cell.content_price.text;
    if(selectQt){
        current_Model.content_express = cell.qt_nameField.text;
        current_Model.express_price = cell.qt_priceField.text;
    }else{
        current_Model.content_express = nil;
        current_Model.express_price = nil;
    }
    current_Model.content_num = numcell.numTextfield.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
//    RMPublishTitleTableViewCell * cell = (RMPublishTitleTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    current_Model.content_desc = textView.text;
}

#pragma mark - RMimageCropperDelegate
- (void)RMimageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage andfilePath:(NSURL *)filePath{
    
    if((img_tag/300-5)*5+img_tag%300<=[current_Model.body count]){
        [modifyImageDic setObject:editedImage forKey:[NSString stringWithFormat:@"%ld",(long)img_tag]];
        
        [modifyPhotoDic setObject:filePath forKey:[NSString stringWithFormat:@"%ld",(img_tag/300-5)*5+img_tag%300-1]];
    }else{
        [newAddPhotoDic setObject:filePath forKey:[NSString stringWithFormat:@"%ld",(img_tag/300-5)*5+img_tag%300-1]];
        [newAddImageDic setObject:editedImage forKey:[NSString stringWithFormat:@"%ld",(img_tag/300-5)*5+img_tag%300]];
    }
    [_mTableView reloadData];
//    RMPublishPhotoTableViewCell * cell = (RMPublishPhotoTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:img_tag/300 inSection:0]];
//    UIImageView * img = (UIImageView *)[cell.contentView viewWithTag:img_tag];
//    [img setImage:editedImage];
}

- (void)RMimageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    NSLog(@"发布宝贝取消选择图片");
}



- (void)commit{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:current_Model.content_name forKey:@"frm[content_name]"];
    [dic setValue:current_Model.content_desc forKey:@"frm[content_desc]"];
    [dic setValue:current_Model.content_price forKey:@"frm[content_price]"];
    [dic setValue:current_Model.is_sf forKey:@"frm[is_sf]"];
    [dic setValue:current_Model.content_express forKey:@"frm[content_express]"];
    [dic setValue:current_Model.express_price forKey:@"frm[express_price]"];
    [dic setValue:current_Model.content_course forKey:@"frm[content_course]"];
    [dic setValue:current_Model.content_class forKey:@"frm[content_class]"];
    if(![[current_Model.member_class substringToIndex:1] isEqualToString:@","]){
        current_Model.member_class = [NSString stringWithFormat:@",%@,",current_Model.member_class];
    }else{
        
    }
    NSLog(@"%@",current_Model.member_class);
    [dic setValue:current_Model.member_class forKey:@"frm[member_class]"];
    [dic setValue:current_Model.content_num forKey:@"frm[content_num]"];
    
    for(NSString * key in [modifyPhotoDic allKeys]){
        [dic setValue:[[current_Model.body objectAtIndex:[key integerValue]] objectForKey:@"auto_id"] forKey:[NSString stringWithFormat:@"frm[body][auto_id][%@]",key]];
    }
    
    NSLog(@"参数：%@",dic);
    NSLog(@"-------------------------------------------------------");
    
    
    [RMAFNRequestManager babyPublishWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Auto_id:self.auto_id newPhotoDic:newAddPhotoDic modifyPhotoDic:modifyPhotoDic otherDic:dic andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * model = object;
            if(model.status){
                if(self.publishCompleted){
                    self.publishCompleted ();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self showHint:model.msg];
        }else{
            [self showHint:object];
        }
    }];

}

#pragma mark - 发布
- (void)pulishAction:(UIButton *)sener{
    if([current_Model.content_name length]==0){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入宝贝名称" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }else if ([current_Model.content_desc length] == 0){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入宝贝描述" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }else if ([current_Model.content_price length] == 0){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入宝贝价格" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }else if (![current_Model.is_sf boolValue]&&([current_Model.content_express length]==0||[current_Model.express_price length] == 0)){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入快递信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }else if (current_Model.content_course.length == 0){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择科目分类" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }else if (current_Model.content_class.length == 0){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择发布市场" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }else if (current_Model.member_class.length == 0){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择商家分类" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }else if ([current_Model.content_num length] == 0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入库存" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }else if([current_Model.content_class isEqualToString:@"1"]&&current_Model.content_num.integerValue > 1){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"一物一拍市场的宝贝只能有一件" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }else if([newAddPhotoDic count] == 0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先通过拍照或者相册上传宝贝图片！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }
    

    if(self.auto_id == nil){
        [self showTipView];
    }else{
        [self commit];
    }
    
}


- (void)showTipView{
    
    UIControl * cover = [[UIControl alloc]initWithFrame:_mTableView.frame];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction:)];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.25;
    cover.tag = 101311;
    [cover addGestureRecognizer:tap];
    [self.view addSubview:cover];
    
    if(tipView == nil){
        tipView = [[[NSBundle mainBundle] loadNibNamed:@"RMAdvantageTipView" owner:self options:nil] lastObject];
        tipView.frame = CGRectMake(0, 0, 150, 120);
        [tipView.continueB addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchDown];
        
        tipView.layer.cornerRadius = 4;
        [tipView.closeB addTarget:self action:@selector(close:) forControlEvents:UIControlStateNormal];
    }
    
    tipView.hidden = YES;
    tipView.kouL.text = [NSString stringWithFormat:@"扣除花币: %f米",1.0];
//    tipView.yuL.text = [NSString stringWithFormat:@"剩余花币 %.0f米",[(RMPublicModel *)[planteArray lastObject] balance]];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        tipView.frame = CGRectMake(0, 0, 150, 120);
        tipView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        [self.view addSubview:tipView];
        tipView.hidden = NO;
    }];
}

- (void)dismissAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.3 animations:^{
        UIControl * cover = (UIControl *)[self.view viewWithTag:101311];
        [cover removeFromSuperview];
        tipView.hidden = YES;
    }];
    
}


- (void)close:(UIButton *)sender{
    [self dismissAction:nil];
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
