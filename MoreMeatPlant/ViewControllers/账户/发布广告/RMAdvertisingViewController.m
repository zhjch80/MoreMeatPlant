//
//  RMAdvertisingViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMAdvertisingViewController.h"
#import "RMAdvertisingSectionTableViewCell.h"
#import "RMAdvertisingHeadTableViewCell.h"
#import "RMVPImageCropper.h"
#import "RMSectionFooterTableViewCell.h"
@interface RMAdvertisingViewController ()<RMVPImageCropperDelegate>

@end

@implementation RMAdvertisingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
    [self setCustomNavTitle:@"发布广告"];
    
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    planteArray = [[NSMutableArray alloc]init];
    selectArray = [[NSMutableArray alloc]init];
    [self planteRequest];
}

- (void)planteRequest{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager corpAdvantageListRequestWithUser:[[RMUserLoginInfoManager loginmanager]user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            [planteArray addObjectsFromArray:object];
            [_mTableView reloadData];
        }else{
            [MBProgressHUD showError:object toView:self.view];
        }

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [planteArray count]+3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        RMAdvertisingHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMAdvertisingHeadTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMAdvertisingHeadTableViewCell" owner:self options:nil] lastObject];
            
            [cell.publishBtn addTarget:self action:@selector(postImg:) forControlEvents:UIControlEventTouchDown];
        }
        return cell;
    }else if (indexPath.row == 1){
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"发到的版块";
        cell.textLabel.font = FONT_1(14);
        return cell;
    }else if (indexPath.row == [planteArray count]+2){
        RMSectionFooterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMSectionFooterTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMSectionFooterTableViewCell" owner:self options:nil] lastObject];
            [cell.surePublish addTarget:self action:@selector(surePublishAction:) forControlEvents:UIControlEventTouchDown];
        }
        cell.balanceL.text = [NSString stringWithFormat:@"%.0f",[(RMPublicModel *)[planteArray lastObject] balance]];
        cell.totalL.text = [NSString stringWithFormat:@"共计: %ld (%.0f米)",num_total,money_total];
        return cell;
    }
    else {

        RMAdvertisingSectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMAdvertisingSectionTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMAdvertisingSectionTableViewCell" owner:self options:nil] lastObject];
            [cell.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchDown];
            
            [cell.subBtn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchDown];
            [cell.addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchDown];
            cell.numTextField.delegate = self;
        }
        cell.selectBtn.tag = indexPath.row*100;
        cell.subBtn.tag = indexPath.row*100+1;
        cell.addBtn.tag = indexPath.row*100+2;
        RMPublicModel * model = [planteArray objectAtIndex:indexPath.row-2];
        cell.planteName.text = model.content_name;
//        cell.numTextField.text = [NSString stringWithFormat:@"%ld",model.textField_value];
        cell.priceL.text = [NSString stringWithFormat:@"%@米/天",model.content_price];
        cell.yu_weiL.text = [NSString stringWithFormat:@"余位 %ld",model.num];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 85;
    }else if (indexPath.row == 1){
        return 40;
    }else if (indexPath.row == [planteArray count]+2){
        return 81;
    }else{
        return 40;
    }
}

#pragma mark - 选择 100
- (void)selectAction:(UIButton *)sender{
    RMAdvertisingSectionTableViewCell * cell =  (RMAdvertisingSectionTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag/100 inSection:0]];
//    RMPublicModel * model = [planteArray objectAtIndex:sender.tag/100-2];
    for(NSNumber * number in selectArray){
        if(sender.tag/100 == [number integerValue]){
//            model.textField_value = 0;
            [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
            [selectArray removeObject:number];
            [self caculateDays];
            return;
        }
    }
//    model.textField_value = 1;
    [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"fbbb_select"] forState:UIControlStateNormal];
    [selectArray addObject:[NSNumber numberWithInteger:sender.tag/100]];
    [self caculateDays];
}

#pragma mark - 减 101
- (void)subAction:(UIButton *)sender{

    RMAdvertisingSectionTableViewCell * cell =  (RMAdvertisingSectionTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag/100 inSection:0]];
    NSInteger num = [cell.numTextField.text integerValue];
    num--;
    if(num>0){
        cell.numTextField.text = [NSString stringWithFormat:@"%ld",num];
    }else{
        cell.numTextField.text = [NSString stringWithFormat:@"%ld",++num];
    }
    RMPublicModel * model = [planteArray objectAtIndex:sender.tag/100-2];
    model.textField_value = num;
    
    [self caculateDays];
}

#pragma mark - 加 102
- (void)addAction:(UIButton *)sender{
    RMAdvertisingSectionTableViewCell * cell =  (RMAdvertisingSectionTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag/100 inSection:0]];
    NSInteger num = [cell.numTextField.text integerValue];
    num++;
    cell.numTextField.text = [NSString stringWithFormat:@"%ld",num];
    RMPublicModel * model = [planteArray objectAtIndex:sender.tag/100-2];
    model.textField_value = num;
    [self caculateDays];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField.text length] == 0 ){
        textField.text = 0;
    }
    [self caculateDays];
}


- (void)caculateDays{
    num_total = 0;
    money_total = 0;
    for(NSNumber * number in selectArray){
        RMAdvertisingSectionTableViewCell * cell =  (RMAdvertisingSectionTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[number integerValue] inSection:0]];
        RMPublicModel * model = [planteArray objectAtIndex:number.integerValue-2];
        num_total+=[cell.numTextField.text integerValue];
        money_total += [cell.numTextField.text integerValue]*[model.content_price floatValue];
    }
    [_mTableView reloadData];
}

#pragma mark - 确认发布
- (void)surePublishAction:(UIButton *)sender{
    NSLog(@"%@",selectArray);
    int i = 0;
    NSMutableDictionary * multabledic = [[NSMutableDictionary alloc]init];
    for(NSNumber * number in selectArray){
        RMAdvertisingSectionTableViewCell * cell =  (RMAdvertisingSectionTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[number integerValue] inSection:0]];
        RMPublicModel * model = [planteArray objectAtIndex:[number integerValue]-2];
        [multabledic setValue:model.auto_id forKey:[NSString stringWithFormat:@"frm[position][%d]",i]];
        [multabledic setValue:cell.numTextField.text forKey:[NSString stringWithFormat:@"frm[day][%d]",i]];
        i++;
    }
    if([selectArray count] == 0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择广告位" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }else if (default_image == nil){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择广告位显示图片" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager corpAdvantageApplyWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Dic:multabledic filePath:_filePath andCallBack:^(NSError *error, BOOL success, id object) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * model = object;
            [MBProgressHUD showSuccess:model.msg toView:self.view];
        }else{
            [MBProgressHUD showSuccess:object toView:self.view];
        }
        
    }];
}

- (void)postImg:(UIButton *)sender{
    [[RMVPImageCropper shareImageCropper] setCtl:self];
    [[RMVPImageCropper shareImageCropper] set_scale:0.14];
    [[RMVPImageCropper shareImageCropper] showActionSheet];
    [[RMVPImageCropper shareImageCropper] setFileName:@"content_img.png"];
}


#pragma mark - RMimageCropperDelegate
- (void)RMimageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage andfilePath:(NSURL *)filePath{
    RMAdvertisingHeadTableViewCell * cell = (RMAdvertisingHeadTableViewCell*)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.placeImgV setImage:editedImage];
    _filePath = filePath;
    default_image = editedImage;
    NSLog(@"发布广告图片路径:%@",filePath);
}

- (void)RMimageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    
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
